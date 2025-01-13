import 'package:ebono_pos/ui/returns/models/customer_order_model.dart';
import 'package:ebono_pos/ui/returns/models/order_items_model.dart';
import 'package:ebono_pos/ui/returns/repository/returns_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'returns_event.dart';
part 'returns_state.dart';

class ReturnsBloc extends Bloc<ReturnsEvent, ReturnsState> {
  late ReturnsRepository returnsRepository;

  ReturnsBloc(this.returnsRepository) : super(const ReturnsState()) {
    on<ReturnsEvent>(_onReturnsEvent);
    on<FetchCustomerOrdersData>(_onFetchCustomerOrdersData);
    on<FetchOrderDataBasedOnOrderId>(_onFetchOrderDataBasedOnOrderId);
    on<UpdateSelectedItem>(_onUpdateSelectedItem);
    on<ProceedToReturnItems>(_proccedToReturnItems);
  }

  void _onReturnsEvent(ReturnsEvent event, Emitter<ReturnsState> emit) {
    emit(state.updateSelectedParameters(isLoading: true));
  }

  Future<void> _proccedToReturnItems(
    ProceedToReturnItems event,
    Emitter<ReturnsState> emit,
  ) async {
    try {
      emit(state.updateSelectedParameters(
        isOrderReturnedSuccessfully: false,
        isReturningOrders: true,
        orderItemsData: event.orderItemsModel,
      ));

      await Future.delayed(Duration(seconds: 10));

      // Should make an actual API call through repository here
      // For example:
      // await returnsRepository.submitReturnItems(state.orderItemsData);

      emit(state.updateSelectedParameters(
        isOrderReturnedSuccessfully: true,
      ));
    } catch (e) {
      emit(state.updateSelectedParameters(
        isError: true,
        errorMessage: e.toString(),
        isReturningOrders: false,
      ));
    }
  }

  Future<void> _onFetchCustomerOrdersData(
    FetchCustomerOrdersData event,
    Emitter<ReturnsState> emit,
  ) async {
    try {
      List<CustomerOrderDetails> customerOrdersList =
          await returnsRepository.fetchCustomerOrderDetails(
        phoneNumber: event.customerMobileNumber,
      );

      emit(state.updateSelectedParameters(
        isCustomerOrdersDataFetched: true,
        isLoading: false,
        customerOrdersList: customerOrdersList,
      ));
    } catch (e) {
      emit(state.updateSelectedParameters(
        isError: true,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onFetchOrderDataBasedOnOrderId(
    FetchOrderDataBasedOnOrderId event,
    Emitter<ReturnsState> emit,
  ) async {
    try {
      OrderItemsModel orderItemsData =
          await returnsRepository.fetchOrderItemBasedOnOrderId(
        orderId: event.orderId,
      );

      if (event.isRetrivingOrderItems) {
        final updatedItems = event.customerOrderDetailsList.map((customer) {
          if (customer.orderNumber == event.orderId) {
            return customer.copyWith(isLoading: true);
          }
          return customer;
        }).toList();

        emit(
          state.updateSelectedParameters(customerOrdersList: updatedItems),
        );
      }

      emit(state.updateSelectedParameters(
        isOrderItemsFetched: true,
        orderItemsData: orderItemsData,
      ));
    } catch (e) {
      emit(state.updateSelectedParameters(
        isError: true,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateSelectedItem(
    UpdateSelectedItem event,
    Emitter<ReturnsState> emit,
  ) async {
    try {
      var updatedOrderItems = event.reason.isEmpty
          ? event.orderItems.copyWith(
              orderLines: event.orderItems.orderLines?.map((item) {
                if (item.orderLineId == event.id) {
                  return item.copyWith(isSelected: !item.isSelected);
                }
                return item;
              }).toList(),
            )
          : event.orderItems.copyWith(
              orderLines: event.orderItems.orderLines?.map((item) {
                if (item.orderLineId == event.id) {
                  return item.copyWith(returnReason: event.reason);
                }
                return item;
              }).toList(),
            );

      final isBtnEnabled =
          updatedOrderItems.orderLines?.any((order) => order.isSelected);
      emit(state.updateSelectedParameters(
        lastSelectedItem: event.orderLine,
        orderItemsData: updatedOrderItems,
        isProceedBtnEnabled: isBtnEnabled,
      ));
    } catch (e) {
      emit(state.updateSelectedParameters(
        isError: true,
        errorMessage: e.toString(),
      ));
    }
  }
}
