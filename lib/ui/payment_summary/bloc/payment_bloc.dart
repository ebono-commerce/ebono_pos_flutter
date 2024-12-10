import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:ebono_pos/constants/shared_preference_constants.dart';
import 'package:ebono_pos/data_store/hive_storage_helper.dart';
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
import 'package:ebono_pos/ui/payment_summary/repository/PaymentRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _paymentRepository;
  final HiveStorageHelper hiveStorageHelper;

  Timer? _timer;
  late PaymentSummaryRequest paymentSummaryRequest;
  late PaymentSummaryResponse paymentSummaryResponse;
  late OrderSummaryResponse orderSummaryResponse;

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
  double totalPayable = 0;
  double balancePayable = 0;
  bool allowPlaceOrder = false;

  PaymentBloc(this._paymentRepository, this.hiveStorageHelper)
      : super(PaymentState()) {
    on<PaymentInitialEvent>(_onInitial);
    on<FetchPaymentSummary>(_fetchPaymentSummary);
    on<PaymentStartEvent>(_paymentInitiateApi);
    on<PaymentStatusEvent>(_paymentStatusApi);
    on<PaymentCancelEvent>(_paymentCancelApi);
    on<PlaceOrderEvent>(_placeOrder);
    on<GetBalancePayableAmountEvent>(_getBalancePayableAmount);
    on<PaymentIdealEvent>(_onIdeal);
  }

  void _startPeriodicPaymentStatusCheck() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (!state.stopTimer) {
        add(PaymentStatusEvent());
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> _onIdeal(
      PaymentIdealEvent event, Emitter<PaymentState> emit) async {
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
    final random = Random();
    final reqBody = {
      "amount": onlinePayment,
      "externalRefNumber": "${random.nextInt(10)}",
      "customerName":
          "${hiveStorageHelper.read(SharedPreferenceConstants.sessionCustomerName)}",
      "customerEmail": "",
      "customerMobileNumber":
          "${hiveStorageHelper.read(SharedPreferenceConstants.sessionCustomerNumber)}",
      "is_emi": false,
      //"terminal_id": "10120",demo account
      "terminal_id":
          "${hiveStorageHelper.read(SharedPreferenceConstants.selectedTerminalId)}",
      "username": "2211202100",
      "appKey": "eaa762ba-08ac-41d6-b6d3-38f754ed1572",
      "pushTo": {"deviceId": "0821387918|ezetap_android"}
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
      "username": "2211202100",
      "appKey": "eaa762ba-08ac-41d6-b6d3-38f754ed1572",
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
      "username": "2211202100",
      "appKey": "eaa762ba-08ac-41d6-b6d3-38f754ed1572",
      "origP2pRequestId": p2pRequestId,
      "pushTo": {"deviceId": "0821387918|ezetap_android"}
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
    var givenAmount = double.parse(event.cash) +
        double.parse(event.online) +
        double.parse(event.wallet);
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
          amount: double.parse(cashPayment),
        ));
      }
      if (onlinePayment.isNotEmpty) {
        onlinePaymentOption = paymentSummaryResponse.paymentOptions?.firstWhere(
          (option) => option.code == 'ONLINE',
        );
        paymentMethods?.add(PaymentMethod(
          paymentOptionId: onlinePaymentOption?.paymentOptionId,
          pspId: onlinePaymentOption?.pspId,
          requestId: p2pRequestId,
          transactionReferenceId: paymentStatusResponse.txnId,
          amount: double.parse(onlinePayment),
        ));
      }

      orderSummaryResponse = await _paymentRepository.placeOrder(
          PlaceOrderRequest(
              cartId: paymentSummaryRequest.cartId,
              phoneNumber: paymentSummaryRequest.phoneNumber,
              cartType: paymentSummaryRequest.cartType,
              paymentMethods: paymentMethods));

      emit(state.copyWith(
          isLoading: false,
          isPlaceOrderSuccess: true,
          isPaymentStatusSuccess: false,
          showPaymentPopup: false,
          isPaymentStartSuccess: false));
      listenToOrderInvoiceSSE("9000000068");
    } catch (error) {
      emit(state.copyWith(
          isLoading: false,
          isPlaceOrderError: true,
          errorMessage: error.toString()));
    }
  }

  listenToOrderInvoiceSSE(String orderId) {
    _paymentRepository.listenToPaymentUpdates(orderId).listen((event) {
      print("event data from sse");
      orderSummaryResponse = orderSummaryResponseFromJson(jsonEncode(event.data));
      print(event.data.toString());
      print(event.toString());

    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
