import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpn_pos_application/data_store/shared_preference_helper.dart';
import 'package:kpn_pos_application/ui/payment_summary/bloc/payment_event.dart';
import 'package:kpn_pos_application/ui/payment_summary/bloc/payment_state.dart';
import 'package:kpn_pos_application/ui/payment_summary/model/payment_summary_request.dart';
import 'package:kpn_pos_application/ui/payment_summary/model/payment_summary_response.dart';
import 'package:kpn_pos_application/ui/payment_summary/repository/PaymentRepository.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _paymentRepository;
  final SharedPreferenceHelper _sharedPreferenceHelper;

  late PaymentSummaryRequest paymentSummaryRequest;
  late PaymentSummaryResponse paymentSummaryResponse;
  String cashPayment = '';
  String onlinePayment = '';
  String loyaltyValue = '';
  String walletValue = '';
  PaymentBloc(this._paymentRepository, this._sharedPreferenceHelper)
      : super(PaymentState()) {
    on<PaymentInitialEvent>(_onInitial);
    on<FetchPaymentSummary>(_fetchPaymentSummary);
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
}
