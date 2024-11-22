import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:kpn_pos_application/constants/shared_preference_constants.dart';
import 'package:kpn_pos_application/data_store/get_storage_helper.dart';
import 'package:kpn_pos_application/data_store/shared_preference_helper.dart';
import 'package:kpn_pos_application/ui/payment_summary/bloc/payment_event.dart';
import 'package:kpn_pos_application/ui/payment_summary/bloc/payment_state.dart';
import 'package:kpn_pos_application/ui/payment_summary/model/payment_cancel_request.dart';
import 'package:kpn_pos_application/ui/payment_summary/model/payment_initiate_request.dart';
import 'package:kpn_pos_application/ui/payment_summary/model/payment_initiate_response.dart';
import 'package:kpn_pos_application/ui/payment_summary/model/payment_status_request.dart';
import 'package:kpn_pos_application/ui/payment_summary/model/payment_status_response.dart';
import 'package:kpn_pos_application/ui/payment_summary/model/payment_summary_request.dart';
import 'package:kpn_pos_application/ui/payment_summary/model/payment_summary_response.dart';
import 'package:kpn_pos_application/ui/payment_summary/repository/PaymentRepository.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _paymentRepository;
  final SharedPreferenceHelper _sharedPreferenceHelper;
  Timer? _timer;
  late PaymentSummaryRequest paymentSummaryRequest;
  late PaymentSummaryResponse paymentSummaryResponse;

  // payment EDC

  late PaymentInitiateResponse paymentInitiateResponse;
  late PaymentStatusResponse paymentStatusResponse;

  String cashPayment = '';
  String onlinePayment = '';
  String loyaltyValue = '';
  String walletValue = '';

  String p2pRequestId = '241122060944906E020075684';

  PaymentBloc(this._paymentRepository, this._sharedPreferenceHelper)
      : super(PaymentState()) {
    on<PaymentInitialEvent>(_onInitial);
    on<FetchPaymentSummary>(_fetchPaymentSummary);

    on<PaymentStartEvent>(_paymentInitiateApi);
    on<PaymentStatusEvent>(_paymentStatusApi);
    on<PaymentCancelEvent>(_paymentCancelApi);
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
          "${GetStorageHelper.read(SharedPreferenceConstants.sessionCustomerName)}",
      "customerEmail": "",
      "customerMobileNumber":
          "${GetStorageHelper.read(SharedPreferenceConstants.sessionCustomerNumber)}",
      "is_emi": false,
      "terminal_id": "10120",
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
      emit(state.copyWith(isLoading: false, isPaymentStatusSuccess: true));

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
          p2pRequestId = '';
          emit(state.copyWith(stopTimer: true));
          Get.back();
          break;
        case "P2P_STATUS_UNKNOWN":
          break;
        case "P2P_DEVICE_CANCELED":
          p2pRequestId = '';
          emit(state.copyWith(stopTimer: true));
          Get.back();
          break;
        case "P2P_STATUS_IN_CANCELED_FROM_EXTERNAL_SYSTEM":
          p2pRequestId = '';
          emit(state.copyWith(stopTimer: true));
          Get.back();
          break;
        case "P2P_ORIGINAL_P2P_REQUEST_IS_MISSING":
          p2pRequestId = '';
          emit(state.copyWith(stopTimer: true));
          Get.back();
          break;
        default:
          Get.back();
          emit(state.copyWith(stopTimer: true));
          break;
      }
      Get.snackbar('Payment status', '${paymentStatusResponse.message}');
    } catch (error) {
      emit(state.copyWith(
          isLoading: false,
          isPaymentSummaryError: true,
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
            isPaymentCancelSuccess: paymentStatusResponse.success));
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

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}