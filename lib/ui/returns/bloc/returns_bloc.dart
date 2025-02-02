import 'package:ebono_pos/ui/returns/models/customer_order_model.dart';
import 'package:ebono_pos/ui/returns/models/order_items_model.dart';
import 'package:ebono_pos/ui/returns/models/refund_success_model.dart';
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
    on<ReturnsResetEvent>(_resetReturns);
    on<ValidateConfirmReturnEvent>(_validateConfirmReturnBtn);
    on<OnSelectAllBtnEvent>(_onSelectAllBtn);
    on<UpdateCommonReasonEvent>(_updateCommonReason);
    on<ResetValuesOnDialogCloseEvent>(_resetValuesOnDialogClose);
  }

  void _onReturnsEvent(ReturnsEvent event, Emitter<ReturnsState> emit) {
    emit(state.updateSelectedParameters(isLoading: true));
  }

  Future<void> _resetReturns(
    ReturnsResetEvent event,
    Emitter<ReturnsState> emit,
  ) async {
    emit(state.updateSelectedParameters());
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

      final response = await returnsRepository.proceedToReturnItems(
        refundItems: event.orderItemsModel.copyWith(
          orderLines: event.orderItemsModel.orderLines!
              .where((order) => order.isSelected)
              .toList(),
        ),
      );

      emit(state.updateSelectedParameters(
        isOrderReturnedSuccessfully: true,
        isConfirmReturnBtnEnabled: false,
        refundSuccessModel: response,
      ));
    } catch (e) {
      emit(state.updateSelectedParameters(
        isError: true,
        errorMessage: e.toString(),
        orderItemsData: event.orderItemsModel,
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
      if (event.isRetrivingOrderItems) {
        final updatedItems = event.customerOrderDetailsList.map((customer) {
          if (customer.orderNumber == event.orderId) {
            return customer.copyWith(isLoading: true);
          }
          return customer;
        }).toList();

        emit(
          state.updateSelectedParameters(
            customerOrdersList: updatedItems,
            isFetchingOrderItems: event.isRetrivingOrderItems,
          ),
        );
      }

      OrderItemsModel orderItemsData =
          await returnsRepository.fetchOrderItemBasedOnOrderId(
        orderId: event.orderId,
      );

      emit(state.updateSelectedParameters(
        isOrderItemsFetched: true,
        orderItemsData: orderItemsData,
      ));
    } catch (e) {
      emit(state.updateSelectedParameters(
        isError: true,
        customerOrdersList:
            event.isRetrivingOrderItems ? event.customerOrderDetailsList : [],
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

      if (event.reason.isEmpty) {
        updatedOrderItems = updatedOrderItems.copyWith(
          isAllOrdersSelected: updatedOrderItems.orderLines
                  ?.every((order) => order.isSelected) ==
              true,
        );
      }

      /* checking if any orderline is selected */
      final isItemsSelected = updatedOrderItems.orderLines
          ?.any((orderLine) => orderLine.isSelected == true);

      /* checking if all selected items return quantity entered */
      final isQuantityEnteredonSelected = updatedOrderItems.orderLines!
          .where((orderLine) => orderLine.isSelected == true)
          .every((order) =>
              order.returnedQuantity != null &&
              order.returnedQuantity.toString().isNotEmpty);

      final isBtnEnabled =
          isQuantityEnteredonSelected && isItemsSelected == true;

      final isBtnEnabled2 = updatedOrderItems.orderLines
          ?.where((order) => order.isSelected == true)
          .every(
            (order) =>
                order.returnedQuantity != null &&
                order.returnReason != null &&
                order.returnReason.toString().isNotEmpty &&
                order.returnedQuantity.toString().isNotEmpty,
          );

      emit(state.updateSelectedParameters(
        lastSelectedItem: event.orderLine,
        orderItemsData: updatedOrderItems,
        isConfirmReturnBtnEnabled: isBtnEnabled2,
        isProceedBtnEnabled: isBtnEnabled,
      ));
    } catch (e) {
      emit(
        state.updateSelectedParameters(
          isError: true,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _validateConfirmReturnBtn(
    ValidateConfirmReturnEvent event,
    Emitter<ReturnsState> emit,
  ) async {
    try {
      bool isBtnEnabled = event.orderItemsModel.orderLines?.any((order) =>
              order.isSelected &&
              order.returnedQuantity != null &&
              order.returnedQuantity.toString().isNotEmpty) ==
          true;

      isBtnEnabled =
          event.name.trim().isNotEmpty && event.phoneNumber.trim().isNotEmpty;

      emit(
        state.updateSelectedParameters(
          isConfirmReturnBtnEnabled: isBtnEnabled,
          orderItemsData: event.orderItemsModel,
        ),
      );
    } catch (e) {
      emit(
        state.updateSelectedParameters(
          isError: true,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSelectAllBtn(
    OnSelectAllBtnEvent event,
    Emitter<ReturnsState> emit,
  ) async {
    OrderItemsModel updatedOrderItems = event.orderItemsModel;
    try {
      updatedOrderItems = event.orderItemsModel.copyWith(
        orderLines: event.orderItemsModel.orderLines?.map((item) {
          return item.copyWith(
            isSelected: !event.orderItemsModel.isAllOrdersSelected,
            returnedQuantity: !event.orderItemsModel.isAllOrdersSelected
                ? item.returnableQuantity?.quantityUom == "pcs"
                    ? int.parse(
                        item.returnableQuantity?.quantityNumber.toString() ??
                            '0')
                    : double.parse(
                        item.returnableQuantity?.quantityNumber.toString() ??
                            '0',
                      )
                : '',
          );
        }).toList(),
        isAllOrdersSelected: !event.orderItemsModel.isAllOrdersSelected,
      );

      /* checking if any orderline is selected */
      final isItemsSelected = updatedOrderItems.orderLines
          ?.any((orderLine) => orderLine.isSelected == true);

      /* checking if all selected items return quantity entered */
      final isQuantityEnteredonSelected = updatedOrderItems.orderLines!
          .where((orderLine) => orderLine.isSelected == true)
          .every((order) =>
              order.returnedQuantity != null &&
              order.returnedQuantity.toString().isNotEmpty);

      final isBtnEnabled =
          isQuantityEnteredonSelected && isItemsSelected == true;

      emit(state.updateSelectedParameters(
        isProceedBtnEnabled: isBtnEnabled,
        orderItemsData: updatedOrderItems,
      ));
    } catch (e) {
      emit(
        state.updateSelectedParameters(
          isError: true,
          orderItemsData: updatedOrderItems,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _updateCommonReason(
    UpdateCommonReasonEvent event,
    Emitter<ReturnsState> emit,
  ) async {
    try {
      final updatedOrderItems = event.orderItemsModel.copyWith(
        orderLines: event.orderItemsModel.orderLines
            ?.where((order) => order.isSelected == true)
            .map((orderLine) {
          return orderLine.copyWith(returnReason: event.reason);
        }).toList(),
      );

      final isBtnEnabled2 = updatedOrderItems.orderLines
          ?.where((order) => order.isSelected == true)
          .every(
            (order) =>
                order.returnedQuantity != null &&
                order.returnReason != null &&
                order.returnReason.toString().isNotEmpty &&
                order.returnedQuantity.toString().isNotEmpty,
          );

      emit(state.updateSelectedParameters(
        orderItemsData: updatedOrderItems,
        isConfirmReturnBtnEnabled: isBtnEnabled2,
        commonSelectedReason: event.reason,
      ));
    } catch (e) {
      emit(
        state.updateSelectedParameters(
          isError: true,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _resetValuesOnDialogClose(
    ResetValuesOnDialogCloseEvent event,
    Emitter<ReturnsState> emit,
  ) async {
    final updatedOrderItems = event.orderItemsModel.copyWith(
      orderLines: event.orderItemsModel.orderLines?.map((orderLine) {
        return orderLine.copyWith(
          returnReason: '',
        );
      }).toList(),
    );
    emit(state.updateSelectedParameters(
      isConfirmReturnBtnEnabled: false,
      orderItemsData: updatedOrderItems,
      isProceedBtnEnabled: false,
      commonSelectedReason: '',
    ));
  }
}
