import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpn_pos_application/data_store/shared_preference_helper.dart';
import 'package:kpn_pos_application/ui/home/bloc/home_event.dart';
import 'package:kpn_pos_application/ui/home/bloc/home_state.dart';
import 'package:kpn_pos_application/ui/home/model/cart_request.dart';
import 'package:kpn_pos_application/ui/home/model/cart_response.dart';
import 'package:kpn_pos_application/ui/home/model/customer_request.dart';
import 'package:kpn_pos_application/ui/home/model/customer_response.dart';
import 'package:kpn_pos_application/ui/home/model/scan_products_response.dart';
import 'package:kpn_pos_application/ui/home/repository/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  final SharedPreferenceHelper _sharedPreferenceHelper;

  HomeBloc(this._homeRepository, this._sharedPreferenceHelper)
      : super(HomeInitial()) {
    on<ScanProduct>(_onScanApiCall);
    on<FetchCart>(_onFetchCartCall);
    on<FetchCustomer>(_onFetchCustomerCall);
  }

  Future<void> _onScanApiCall(
      ScanProduct event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final ScanProductsResponse response =
          await _homeRepository.getScanProduct(event.code);
      emit(HomeSuccess());
    } catch (error) {
      emit(HomeFailure(error.toString()));
    }
  }

  Future<void> _onFetchCartCall(
      FetchCart event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final CartResponse response =
          await _homeRepository.getCart(CartRequest(cartId: event.cartId));
      emit(HomeSuccess());
    } catch (error) {
      emit(HomeFailure(error.toString()));
    }
  }

  Future<void> _onFetchCustomerCall(
      FetchCustomer event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final CustomerResponse response = await _homeRepository.fetchCustomer(
          CustomerRequest(
              phoneNumber: event.phoneNumber,
              cartType: event.cartType,
              outletId: event.outletId));
      emit(HomeSuccess());
    } catch (error) {
      emit(HomeFailure(error.toString()));
    }
  }

  Future<void> _onAddToCartCall(
      AddToCart event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final cartLine = CartLineAddToCart(
        esin: event.esin,
        quantity: QuantityAddToCart(
            quantityNumber: event.qty, quantityUom: event.qtyUom),
        mrpId: event.mrpId,
      );

      final CartResponse response = await _homeRepository.addToCart(
          AddToCartRequest(cartLines: [cartLine]), event.cartId);
      emit(HomeSuccess());
    } catch (error) {
      emit(HomeFailure(error.toString()));
    }
  }
}
