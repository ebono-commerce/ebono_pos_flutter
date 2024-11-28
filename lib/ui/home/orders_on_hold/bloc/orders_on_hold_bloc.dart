import 'package:ebono_pos/constants/shared_preference_constants.dart';
import 'package:ebono_pos/data_store/get_storage_helper.dart';
import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:ebono_pos/models/cart_response.dart';
import 'package:ebono_pos/ui/home/model/orders_on_hold.dart';
import 'package:ebono_pos/ui/home/model/orders_onhold_request.dart';
import 'package:ebono_pos/ui/home/model/resume_hold_cart_request.dart';
import 'package:ebono_pos/ui/home/orders_on_hold/bloc/orders_on_hold_event.dart';
import 'package:ebono_pos/ui/home/orders_on_hold/bloc/orders_on_hold_state.dart';
import 'package:ebono_pos/ui/home/orders_on_hold/repository/orders_on_hold_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersOnHoldBloc extends Bloc<OrdersOnHoldEvent, OrdersOnHoldState> {
  final OrdersOnHoldRepository _ordersOnHoldRepository;
  final SharedPreferenceHelper _sharedPreferenceHelper;

  late OrdersOnHoldResponse ordersOnHoldResponse;
  late CartResponse cartResponse;

  OrdersOnHoldBloc(this._ordersOnHoldRepository, this._sharedPreferenceHelper)
      : super(OrdersOnHoldState()) {
    on<OrdersOnHoldInitialEvent>(_onInitial);
    on<FetchHoldOrdersEvent>(_ordersOnHoldApiCall);
    on<ResumeOrdersEvent>(_resumeHoldCartApiCall);
  }

  Future<void> _onInitial(
      OrdersOnHoldInitialEvent event, Emitter<OrdersOnHoldState> emit) async {
    emit(state.copyWith(initialState: true));
    add(FetchHoldOrdersEvent());
  }

  Future<void> _resumeHoldCartApiCall(
      ResumeOrdersEvent event, Emitter<OrdersOnHoldState> emit) async {
    //cartId | holdCartId | terminal Id
    try {
      emit(state.copyWith(isLoading: true, initialState: false));

      var response = await _ordersOnHoldRepository.resumeHoldCart(
          "${GetStorageHelper.read(SharedPreferenceConstants.cartId)}",
          ResumeHoldCartRequest(
              terminalId:
                  "${GetStorageHelper.read(SharedPreferenceConstants.selectedTerminalId)}",
              holdCartId: event.id));
      cartResponse = response;
      emit(state.copyWith(
          isLoading: false, isResumeOrderSuccess: true, ordersOnHold: []));
    } catch (error) {
      emit(state.copyWith(
          isLoading: false,
          isResumeOrderSuccess: false,
          errorMessage: error.toString()));
    }
  }

  Future<void> _ordersOnHoldApiCall(
      FetchHoldOrdersEvent event, Emitter<OrdersOnHoldState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, ordersOnHold: []));
      var response = await _ordersOnHoldRepository.ordersOnHold(OrdersOnHoldRequest(
          outletId:
              "${GetStorageHelper.read(SharedPreferenceConstants.selectedOutletId)}"));
      ordersOnHoldResponse = response;
      if (ordersOnHoldResponse.data != null) {
        emit(state.copyWith(
            isLoading: false,
            ordersOnHold: List<OnHoldItems>.from(ordersOnHoldResponse.data!),
            isFetchOrderOnHoldSuccess: true));
      } else {
        emit(state.copyWith(
            isLoading: false,
            ordersOnHold: [],
            isFetchOrderOnHoldSuccess: true));
      }
    } catch (error) {
      emit(state.copyWith(
          isLoading: false,
          ordersOnHold: [],
          isFetchOrderOnHoldSuccess: false,
          errorMessage: error.toString()));
    }
  }
}
