import 'dart:async';

import 'package:ebono_pos/constants/shared_preference_constants.dart';
import 'package:ebono_pos/data_store/hive_storage_helper.dart';
import 'package:ebono_pos/ui/home/model/phone_number_request.dart';
import 'package:ebono_pos/ui/login/model/terminal_details_response.dart';
import 'package:ebono_pos/ui/payment_summary/bloc/payment_event.dart';
import 'package:ebono_pos/ui/payment_summary/bloc/payment_state.dart';
import 'package:ebono_pos/ui/payment_summary/model/order_summary_response.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_cancel_request.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_initiate_request.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_initiate_response.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_status_request.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_status_response.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_summary_request.dart';
import 'package:ebono_pos/ui/payment_summary/model/payment_summary_response.dart';
import 'package:ebono_pos/ui/payment_summary/model/place_order_request.dart';
import 'package:ebono_pos/ui/payment_summary/model/wallet_charge_request.dart';
import 'package:ebono_pos/ui/payment_summary/repository/PaymentRepository.dart';
import 'package:ebono_pos/utils/common_methods.dart';
import 'package:ebono_pos/utils/price.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _paymentRepository;
  final HiveStorageHelper hiveStorageHelper;

  Timer? _timer;
  late PaymentSummaryRequest paymentSummaryRequest;
  late PaymentSummaryResponse paymentSummaryResponse;
  late OrderSummaryResponse orderSummaryResponse;
  late OrderSummaryResponse invoiceSummaryResponse;

  // payment EDC

  late PaymentInitiateResponse paymentInitiateResponse;
  late PaymentStatusResponse paymentStatusResponse;

  String cashPayment = '';
  String onlinePayment = '';
  String loyaltyValue = '';
  String walletValue = '';
  String p2pRequestId = '';
  List<PaymentMethod>? paymentMethods = [];
  late PaymentOption? cashPaymentOption;
  late PaymentOption? onlinePaymentOption;
  late RedeemablePaymentOption? walletPaymentOption;
  double cashAmount = 0;
  double onlineAmount = 0;
  double walletAmount = 0;
  double totalPayable = 0;
  double balancePayable = 0;
  bool allowPlaceOrder = false;
  bool allowPrintInvoice = false;
  List<EdcDevice> edcDetails = [];
  StreamSubscription? _orderInvoiceSubscription;
  Timer? _sseFallbackTimer;

  PaymentBloc(this._paymentRepository, this.hiveStorageHelper)
      : super(PaymentState()) {
    on<PaymentInitialEvent>(_onInitial);
    on<FetchPaymentSummary>(_fetchPaymentSummary);
    on<PaymentStartEvent>(_paymentInitiateApi);
    on<PaymentStatusEvent>(_paymentStatusApi);
    on<PaymentCancelEvent>(_paymentCancelApi);
    on<PlaceOrderEvent>(_placeOrder);
    on<GetInvoiceEvent>(_getInvoice);
    on<GetBalancePayableAmountEvent>(_getBalancePayableAmount);
    on<WalletAuthenticationEvent>(_walletAuthentication);
    on<WalletChargeEvent>(_walletCharge);
    on<WalletIdealEvent>(_onWalletIdeal);
    on<PaymentIdealEvent>(_onIdeal);
  }

  void _startPeriodicPaymentStatusCheck() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (!state.stopTimer) {
        add(PaymentStatusEvent());
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> _onIdeal(
      PaymentIdealEvent event, Emitter<PaymentState> emit) async {
    paymentMethods?.clear();
    cashPayment = '';
    onlinePayment = '';
    emit(state.copyWith(
      initialState: false,
      isLoading: false,
      isPlaceOrderSuccess: false,
      isPlaceOrderError: false,
    ));
  }

  Future<void> _onInitial(
      PaymentInitialEvent event, Emitter<PaymentState> emit) async {
    emit(state.copyWith(initialState: true));
    paymentSummaryRequest = event.request;
    add(FetchPaymentSummary());

    var edcDevice = hiveStorageHelper
        .read(SharedPreferenceConstants.edcDeviceDetails) as List;

    List<EdcDevice> edcDeviceDetails = edcDevice.map((item) {
      if (item is Map<String, dynamic>) {
        return EdcDevice.fromJson(item);
      } else {
        return EdcDevice.fromJson(Map<String, dynamic>.from(item));
      }
    }).toList();
    print(edcDeviceDetails.first.username);
    edcDetails = edcDeviceDetails;
  }

  Future<void> _fetchPaymentSummary(
      FetchPaymentSummary event, Emitter<PaymentState> emit) async {
    emit(state.copyWith(isLoading: true, initialState: false));

    try {
      paymentSummaryResponse =
          await _paymentRepository.fetchPaymentSummary(paymentSummaryRequest);

      emit(state.copyWith(isLoading: false, isPaymentSummarySuccess: true));
    } catch (error) {
      emit(state.copyWith(
          isLoading: false,
          isPaymentSummaryError: true,
          errorMessage: error.toString()));
    }
  }

  Future<void> _paymentInitiateApi(
      PaymentStartEvent event, Emitter<PaymentState> emit) async {
    emit(state.copyWith(isLoading: true, initialState: false));

    final reqBody = {
      "amount": onlinePayment,
      "externalRefNumber":
          paymentSummaryResponse.orderNumber ?? generateRandom8DigitNumber(),
      "customerName":
          "${hiveStorageHelper.read(SharedPreferenceConstants.sessionCustomerName)}",
      "customerEmail": "",
      "customerMobileNumber":
          "${hiveStorageHelper.read(SharedPreferenceConstants.sessionCustomerNumber)}",
      "is_emi": false,
      //"terminal_id": "10120",demo account
      "terminal_id":
          "${hiveStorageHelper.read(SharedPreferenceConstants.selectedTerminalId)}",
      "username": edcDetails.firstOrNull?.username,
      "appKey": edcDetails.firstOrNull?.appKey,
      "pushTo": {"deviceId": edcDetails.firstOrNull?.deviceId}
    };
    var paymentRequest = PaymentRequest.fromJson(reqBody);
    print(
        'Payment Request: ${paymentRequest.amount}, ${paymentRequest.customerName}, ${paymentRequest.customerMobileNumber}');

    try {
      paymentInitiateResponse =
          await _paymentRepository.paymentInitiateApiCall(paymentRequest);

      if (paymentInitiateResponse.success == true) {
        print(
            "Success p2pRequestId --> : ${paymentInitiateResponse.p2PRequestId}");
        emit(state.copyWith(
            isLoading: false,
            showPaymentPopup: paymentInitiateResponse.success,
            isPaymentStartSuccess: paymentInitiateResponse.success));
        if (paymentInitiateResponse.p2PRequestId != "") {
          _startPeriodicPaymentStatusCheck();
          p2pRequestId = paymentInitiateResponse.p2PRequestId!;
        } else {
          p2pRequestId = '';
        }
      } else {
        Get.snackbar('Error', '${paymentInitiateResponse.message}');
        emit(state.copyWith(
            isLoading: false,
            showPaymentPopup: false,
            isPaymentStartSuccess: false));
      }
    } catch (error) {
      emit(state.copyWith(
          isLoading: false,
          isPaymentSummaryError: true,
          errorMessage: error.toString()));
    }
  }

  Future<void> _paymentStatusApi(
      PaymentStatusEvent event, Emitter<PaymentState> emit) async {
    emit(state.copyWith(isLoading: false, initialState: false));
    final reqBody = {
      "username": edcDetails.firstOrNull?.username,
      "appKey": edcDetails.firstOrNull?.appKey,
      "origP2pRequestId": p2pRequestId
    };
    var paymentStatusRequest = PaymentStatusRequest.fromJson(reqBody);
    print('Payment Status Request: ${paymentStatusRequest.origP2PRequestId}');

    try {
      paymentStatusResponse =
          await _paymentRepository.paymentStatusApiCall(paymentStatusRequest);

      print(
          "Success payment status --> : ${paymentStatusResponse.abstractPaymentStatus}");
      switch (paymentStatusResponse.messageCode) {
        case "P2P_DEVICE_RECEIVED":
          break;
        case "P2P_STATUS_QUEUED":
          break;
        case "P2P_STATUS_IN_EXPIRED":
          break;
        case "P2P_DEVICE_TXN_DONE":
          if (paymentStatusResponse.abstractPaymentStatus == "SUCCESS") {
            emit(state.copyWith(
              stopTimer: true,
              showPaymentPopup: false,
              isOnlinePaymentSuccess: true,
              isPaymentStatusSuccess: true,
            ));
          } else {
            emit(state.copyWith(
                stopTimer: true,
                showPaymentPopup: false,
                isOnlinePaymentSuccess: false,
                isPaymentCancelSuccess: true));
          }
          Get.back();
          Get.snackbar('Payment status ${paymentStatusResponse.status}',
              '${paymentStatusResponse.message}');

          break;

        case "P2P_STATUS_UNKNOWN":
          break;
        case "P2P_DEVICE_CANCELED":
          p2pRequestId = '';
          emit(state.copyWith(
              stopTimer: true,
              showPaymentPopup: false,
              isOnlinePaymentSuccess: false,
              isPaymentCancelSuccess: true));
          Get.back();
          Get.snackbar('Payment status', '${paymentStatusResponse.message}');
          break;
        case "P2P_STATUS_IN_CANCELED_FROM_EXTERNAL_SYSTEM":
          p2pRequestId = '';
          emit(state.copyWith(
              stopTimer: true,
              showPaymentPopup: false,
              isOnlinePaymentSuccess: false,
              isPaymentCancelSuccess: true));
          Get.snackbar('Payment status', '${paymentStatusResponse.message}');
          break;
        case "P2P_ORIGINAL_P2P_REQUEST_IS_MISSING":
          p2pRequestId = '';
          emit(state.copyWith(stopTimer: true, showPaymentPopup: false));
          Get.back();
          Get.snackbar('Payment status', '${paymentStatusResponse.message}');
          break;
        default:
          Get.back();
          emit(state.copyWith(stopTimer: true, showPaymentPopup: false));
          break;
      }
    } catch (error) {
      emit(state.copyWith(
          isLoading: false,
          isPaymentSummaryError: true,
          showPaymentPopup: false,
          errorMessage: error.toString(),
          stopTimer: true));
      _timer?.cancel();
    }
  }

  Future<void> _paymentCancelApi(
      PaymentCancelEvent event, Emitter<PaymentState> emit) async {
    emit(state.copyWith(isLoading: false, initialState: false));
    final reqBody = {
      "username": edcDetails.firstOrNull?.username,
      "appKey": edcDetails.firstOrNull?.appKey,
      "origP2pRequestId": p2pRequestId,
      "pushTo": {
        "deviceId": edcDetails.firstOrNull?.deviceId,
      }
    };
    var paymentCancelRequest = PaymentCancelRequest.fromJson(reqBody);
    print('Payment Cancel Request: ${paymentCancelRequest.origP2PRequestId}');

    try {
      paymentStatusResponse =
          await _paymentRepository.paymentCancelApiCall(paymentCancelRequest);

      if (paymentStatusResponse.success == true) {
        emit(state.copyWith(
            isPaymentCancelSuccess: paymentStatusResponse.success,
            showPaymentPopup: false));
        Get.back();
      } else {
        if (paymentInitiateResponse.realCode ==
                "P2P_DUPLICATE_CANCEL_REQUEST" ||
            paymentInitiateResponse.realCode ==
                "P2P_ORIGINAL_P2P_REQUEST_IS_MISSING") {
          Get.back();
        }
        Get.snackbar('Error', '${paymentInitiateResponse.message}');
      }
    } catch (error) {
      emit(state.copyWith(
          isLoading: false,
          isPaymentSummaryError: true,
          errorMessage: error.toString()));
    }
  }

  _getBalancePayableAmount(
      GetBalancePayableAmountEvent event, Emitter<PaymentState> emit) {
    cashAmount = double.parse(event.cash);
    onlineAmount = double.parse(event.online);
    walletAmount = double.parse(event.wallet);
    var givenAmount = cashAmount + onlineAmount /*+ walletAmount*/;
    totalPayable = (paymentSummaryResponse.amountPayable?.centAmount ?? 0) /
        (paymentSummaryResponse.amountPayable?.fraction ?? 1);
    if (event.online != '0') {
      emit(state.copyWith(isOnlinePaymentSuccess: true));
    }
    balancePayable = totalPayable - givenAmount;

    if (balancePayable <= 0) {
      if (onlinePayment.isNotEmpty && onlinePayment != '0') {
        if (state.isPaymentStatusSuccess) {
          allowPlaceOrder = true;
        } else {
          allowPlaceOrder = false;
        }
      } else {
        allowPlaceOrder = true;
      }
    } else {
      allowPlaceOrder = false;
    }
    emit(state.copyWith(
        balancePayableAmount: balancePayable,
        allowPlaceOrder: allowPlaceOrder));
  }

  Future<void> _placeOrder(
      PlaceOrderEvent event, Emitter<PaymentState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      if (cashPayment.isNotEmpty) {
        cashPaymentOption = paymentSummaryResponse.paymentOptions?.firstWhere(
          (option) => option.code == 'CASH',
        );
        if (balancePayable < 0) {}
        paymentMethods?.add(PaymentMethod(
            paymentOptionId: cashPaymentOption?.paymentOptionId,
            pspId: cashPaymentOption?.pspId,
            requestId: paymentSummaryRequest.cartId,
            transactionReferenceId: paymentSummaryRequest.cartId,
            amount: onlinePayment.isEmpty
                ? (cashAmount - (balancePayable.abs()))
                : cashAmount,
            methodDetail: [
              MethodDetail(key: "METHOD", value: "CASH"),
            ]));
      }
      if (onlinePayment.isNotEmpty) {
        onlinePaymentOption = paymentSummaryResponse.paymentOptions?.firstWhere(
          (option) =>
              option.code == paymentStatusResponse.paymentMode?.toUpperCase(),
        );
        paymentMethods?.add(PaymentMethod(
            paymentOptionId: onlinePaymentOption?.paymentOptionId,
            pspId: onlinePaymentOption?.pspId,
            requestId: p2pRequestId,
            transactionReferenceId: paymentStatusResponse.txnId,
            amount: onlineAmount,
            methodDetail: [
              MethodDetail(
                  key: "METHOD", value: paymentStatusResponse.paymentMode),
            ]));
      }
      var appliedWalletAmount = getPrice(
          paymentSummaryResponse.redeemedWalletAmount?.centAmount,
          paymentSummaryResponse.redeemedWalletAmount?.fraction);
      if (appliedWalletAmount > 0) {
        walletPaymentOption =
            paymentSummaryResponse.redeemablePaymentOptions?.firstWhere(
          (option) => option.code == 'WALLET',
        );
        paymentMethods?.add(PaymentMethod(
            paymentOptionId: walletPaymentOption?.paymentOptionId,
            pspId: walletPaymentOption?.pspId,
            requestId: paymentSummaryRequest.cartId,
            transactionReferenceId: paymentSummaryRequest.cartId,
            amount: appliedWalletAmount,
            methodDetail: [
              MethodDetail(key: "METHOD", value: "WALLET"),
            ]));
      }
      orderSummaryResponse =
          await _paymentRepository.placeOrder(PlaceOrderRequest(
        cartId: paymentSummaryRequest.cartId,
        phoneNumber: paymentSummaryRequest.phoneNumber,
        cartType: paymentSummaryRequest.cartType,
        paymentMethods: paymentMethods,
        registerId:
            "${hiveStorageHelper.read(SharedPreferenceConstants.registerId)}",
        terminalId:
            "${hiveStorageHelper.read(SharedPreferenceConstants.selectedTerminalId)}",
        registerTransactionId: hiveStorageHelper
            .read(SharedPreferenceConstants.registerTransactionId),
      ));

      emit(state.copyWith(
          isLoading: false,
          isPlaceOrderSuccess: true,
          isPaymentStatusSuccess: false,
          showPaymentPopup: false,
          isPaymentStartSuccess: false));
      if (orderSummaryResponse.orderNumber != null &&
          orderSummaryResponse.orderNumber?.isNotEmpty == true) {
        emit(state.copyWith(
          isLoading: true,
          allowPrintInvoice: false,
        ));
        listenToOrderInvoiceSSE(orderSummaryResponse.orderNumber!);
      }
    } catch (error) {
      emit(state.copyWith(
          isLoading: false,
          isPlaceOrderError: true,
          errorMessage: error.toString()));
    }
  }

  _getInvoice(GetInvoiceEvent event, Emitter<PaymentState> emit) async {
    emit(state.copyWith(isLoading: true, initialState: false));

    try {
      invoiceSummaryResponse = await _paymentRepository
          .getInvoice(orderSummaryResponse.orderNumber!);

      emit(state.copyWith(isLoading: false));
      _sseFallbackTimer?.cancel();
      _orderInvoiceSubscription?.cancel();
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }

  listenToOrderInvoiceSSE(String orderId) {
    _orderInvoiceSubscription?.cancel();
    _sseFallbackTimer?.cancel();

    _orderInvoiceSubscription =
        _paymentRepository.listenToPaymentUpdates(orderId).listen((event) {
      print("event data from sse ${event.data}");
      if (event.data != null && event.data?.isNotEmpty == true) {
        print("event data from sse");
        try {
          invoiceSummaryResponse = orderSummaryResponseFromJson(event.data!);
          if (invoiceSummaryResponse.invoiceNumber != null) {
            allowPrintInvoice = true;
            emit(state.copyWith(
              isLoading: false,
              allowPrintInvoice: true,
            ));
            _sseFallbackTimer?.cancel();
            _orderInvoiceSubscription?.cancel();
          } else {
            emit(state.copyWith(
              isLoading: true,
              allowPrintInvoice: false,
            ));
          }
        } on Exception catch (e) {
          print('error in sse event parsing: $e');
        }
      }
    });

    _sseFallbackTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      add(GetInvoiceEvent());
    });
  }

  Future<void> _walletAuthentication(
      WalletAuthenticationEvent event, Emitter<PaymentState> emit) async {
    emit(state.copyWith(
      isLoading: true,
      initialState: false,
      isResendOTPLoading: event.isResendOTP,
      isVerifyOTPLoading: !event.isResendOTP,
    ));

    try {
      var response = await _paymentRepository.walletAuthentication(
          PhoneNumberRequest(phoneNumber: paymentSummaryRequest.phoneNumber));

      if (response.success == true) {
        Get.snackbar('OTP SENT',
            'otp sent successfully to ${paymentSummaryRequest.phoneNumber}');
      }

      emit(state.copyWith(
          isLoading: false, isWalletAuthenticationSuccess: true));
    } catch (error) {
      emit(state.copyWith(
          isLoading: false,
          isWalletAuthenticationError: true,
          errorMessage: error.toString()));
    } finally {
      emit(state.copyWith(
        isLoading: false,
        isWalletChargeError: false,
        isWalletAuthenticationError: false,
        isWalletAuthenticationSuccess: false,
        isVerifyOTPLoading: false,
        isResendOTPLoading: false,
      ));
    }
  }

  Future<void> _walletCharge(
      WalletChargeEvent event, Emitter<PaymentState> emit) async {
    emit(state.copyWith(
      isLoading: true,
      isVerifyOTPLoading: true,
      isResendOTPLoading: false,
      initialState: false,
    ));

    try {
      paymentSummaryResponse = await _paymentRepository.walletCharge(
          WalletChargeRequest(
              phoneNumber: paymentSummaryRequest.phoneNumber,
              otp: event.otp,
              amount: Amount(
                  centAmount: double.parse(
                      '${(paymentSummaryResponse.redeemablePaymentOptions!.firstOrNull?.applicableBalance) ?? 0}'),
                  fraction: 1,
                  currency: 'INR')));

      emit(state.copyWith(
          isLoading: false,
          isWalletChargeSuccess: true,
          isPaymentSummarySuccess: true));
    } catch (error) {
      emit(state.copyWith(
          isLoading: false,
          isWalletChargeError: true,
          errorMessage: error.toString()));
    } finally {
      emit(state.copyWith(
        isLoading: false,
        isWalletChargeError: false,
        isWalletAuthenticationError: false,
        isWalletChargeSuccess: false,
        isVerifyOTPLoading: false,
        isResendOTPLoading: false,
      ));
    }
  }

  Future<void> _onWalletIdeal(
      WalletIdealEvent event, Emitter<PaymentState> emit) async {
    emit(state.copyWith(
      initialState: false,
      isLoading: false,
      isWalletAuthenticationSuccess: false,
      isWalletAuthenticationError: false,
      isWalletChargeSuccess: false,
      isWalletChargeError: false,
    ));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
