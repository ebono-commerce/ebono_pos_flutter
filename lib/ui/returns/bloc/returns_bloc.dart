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
    on<OnSelectAllBtnEvent>(_onSelectAllBtn);
    on<UpdateCommonReasonEvent>(_updateCommonReason);
    on<ResetValuesOnDialogCloseEvent>(_resetValuesOnDialogClose);
    on<UpdateOrderLineQuantity>(_onUpdateOrderLineQuantity);
    on<UpdateOrderItemsInternalState>(_onUpdateOrderItemsInternalState);
  }

  void _onReturnsEvent(ReturnsEvent event, Emitter<ReturnsState> emit) {
    /* always triggers loading event when ever event is added */
    emit(state.copyWith(isLoading: true));
  }

  Future<void> _resetReturns(
    ReturnsResetEvent event,
    Emitter<ReturnsState> emit,
  ) async {
    emit(state.updateInputValuesAndResetRemaining(
      resetAllValues: true,
    ));
  }

  Future<void> _proccedToReturnItems(
    ProceedToReturnItems event,
    Emitter<ReturnsState> emit,
  ) async {
    try {
      emit(state.copyWith(
        isOrderReturnedSuccessfully: false,
        isReturningOrders: true,
      ));

      final payloadData = state.orderItemsData.copyWith(
        orderLines: state.orderItemsData.orderLines
            ?.where((order) => order.isSelected == true)
            .toList(),
      );

      final response = await returnsRepository.proceedToReturnItems(
        refundItems: payloadData,
      );

      emit(state.updateInputValuesAndResetRemaining(
        isOrderReturnedSuccessfully: true,
        isConfirmReturnBtnEnabled: false,
        refundSuccessModel: response,
      ));
    } catch (e) {
      emit(state.updateInputValuesAndResetRemaining(
        isError: true,
        errorMessage: e.toString(),
        orderItemsData: state.orderItemsData,
      ));
    }
  }

  Future<void> _onFetchCustomerOrdersData(
    FetchCustomerOrdersData event,
    Emitter<ReturnsState> emit,
  ) async {
    try {
      CustomerOrders customerOrders =
          await returnsRepository.fetchCustomerOrderDetails(
        phoneNumber: event.customerMobileNumber,
      );

      emit(state.updateInputValuesAndResetRemaining(
        isCustomerOrdersDataFetched: true,
        customerOrders: customerOrders,
      ));
    } catch (e) {
      emit(state.copyWith(
        isError: true,
        isCustomerOrdersDataFetched: false,
        isLoading: false,
        errorMessage: e.toString(),
      ));
    } finally {
      emit(state.copyWith(
        isCustomerOrdersDataFetched: false,
        isOrderItemsFetched: false,
        isError: false,
      ));
    }
  }

  Future<void> _onFetchOrderDataBasedOnOrderId(
    FetchOrderDataBasedOnOrderId event,
    Emitter<ReturnsState> emit,
  ) async {
    try {
      if (event.isRetrivingOrderItems) {
        final updatedItems =
            state.customerOrders.customerOrderList.map((customer) {
          if (customer.orderNumber == event.orderId) {
            return customer.copyWith(isLoading: true);
          }
          return customer;
        }).toList();

        emit(
          state.updateInputValuesAndResetRemaining(
            customerOrders: state.customerOrders.copyWith(
              customerOrderList: updatedItems,
            ),
            // isCustomerOrdersDataFetched: true,
            isFetchingOrderItems: event.isRetrivingOrderItems,
          ),
        );
      }

      OrderItemsModel orderItemsData =
          await returnsRepository.fetchOrderItemBasedOnOrderId(
        orderId: event.orderId,
      );

      emit(state.updateInputValuesAndResetRemaining(
        isOrderItemsFetched: true,
        isFetchingOrderItems: true,
        orderItemsData: orderItemsData,
      ));
    } catch (e) {
      emit(state.updateInputValuesAndResetRemaining(
        isError: true,
        customerOrders: event.isRetrivingOrderItems
            ? state.customerOrders
            : const CustomerOrders(),
        errorMessage: e.toString(),
      ));
    } finally {
      emit(state.copyWith(
        isOrderItemsFetched: false,
        isFetchingOrderItems: false,
        isCustomerOrdersDataFetched: false,
        isError: false,
      ));
    }
  }

  Future<void> _onUpdateSelectedItem(
    UpdateSelectedItem event,
    Emitter<ReturnsState> emit,
  ) async {
    try {
      var updatedOrderItems = event.reason.isEmpty
          ? state.orderItemsData.copyWith(
              orderLines: state.orderItemsData.orderLines?.map((item) {
                if (item.orderLineId == event.id) {
                  return item.copyWith(
                    isSelected: event.isSelected,
                    returnedQuantity:
                        !event.isSelected ? "" : item.returnedQuantity,
                  );
                }
                return item;
              }).toList(),
            )
          : state.orderItemsData.copyWith(
              orderLines: state.orderItemsData.orderLines?.map((item) {
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

      emit(state.updateInputValuesAndResetRemaining(
        lastSelectedItem: event.orderLine,
        orderItemsData: updatedOrderItems,
        isConfirmReturnBtnEnabled: isBtnEnabled2,
        isProceedBtnEnabled: isBtnEnabled,
      ));
    } catch (e) {
      emit(
        state.updateInputValuesAndResetRemaining(
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
    OrderItemsModel updatedOrderItems = state.orderItemsData;
    try {
      updatedOrderItems = state.orderItemsData.copyWith(
        orderLines: state.orderItemsData.orderLines?.map((item) {
          return item.copyWith(
            isSelected: !state.orderItemsData.isAllOrdersSelected,
            returnedQuantity: !state.orderItemsData.isAllOrdersSelected
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
        isAllOrdersSelected: !state.orderItemsData.isAllOrdersSelected,
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

      emit(state.updateInputValuesAndResetRemaining(
        isProceedBtnEnabled: isBtnEnabled,
        orderItemsData: updatedOrderItems,
      ));
    } catch (e) {
      emit(
        state.updateInputValuesAndResetRemaining(
          isError: true,
          orderItemsData: updatedOrderItems,
          errorMessage: e.toString(),
          lastSelectedItem: OrderLine(),
        ),
      );
    }
  }

  Future<void> _updateCommonReason(
    UpdateCommonReasonEvent event,
    Emitter<ReturnsState> emit,
  ) async {
    try {
      final updatedOrderItems = state.orderItemsData.copyWith(
        orderLines: state.orderItemsData.orderLines?.map((orderLine) {
          if (orderLine.isSelected == true) {
            return orderLine.copyWith(returnReason: event.reason);
          }
          return orderLine;
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

      emit(state.updateInputValuesAndResetRemaining(
        orderItemsData: updatedOrderItems,
        isConfirmReturnBtnEnabled: isBtnEnabled2,
        commonSelectedReason: event.reason,
      ));
    } catch (e) {
      emit(
        state.updateInputValuesAndResetRemaining(
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
    final updatedOrderItems = state.orderItemsData.copyWith(
      orderLines: state.orderItemsData.orderLines?.map((orderLine) {
        return orderLine.copyWith(
          returnReason: '',
        );
      }).toList(),
    );

    /* checking if any orderline is selected */
    final isItemsSelected = updatedOrderItems.orderLines
        ?.any((orderLine) => orderLine.isSelected == true);

    /* checking if all selected items return quantity entered */
    final isQuantityEnteredonSelected = updatedOrderItems.orderLines
        ?.where((orderLine) => orderLine.isSelected == true)
        .every((order) =>
            order.returnedQuantity != null &&
            order.returnedQuantity.toString().isNotEmpty);

    final isBtnEnabled =
        isQuantityEnteredonSelected == true && isItemsSelected == true;

    emit(state.updateInputValuesAndResetRemaining(
      orderItemsData: updatedOrderItems,
      isProceedBtnEnabled: isBtnEnabled,
      commonSelectedReason: '',
    ));
  }

  Future<void> _onUpdateOrderLineQuantity(
    UpdateOrderLineQuantity event,
    Emitter<ReturnsState> emit,
  ) async {
    try {
      final updatedItem = state.lastSelectedItem.copyWith(
        isSelected: true,
        returnedQuantity:
            state.lastSelectedItem.returnableQuantity?.quantityUom == "pcs"
                ? int.parse(event.quantity)
                : double.parse(event.quantity),
      );

      final updatedOrderLines = state.orderItemsData.orderLines?.map((item) {
        if (item.orderLineId == updatedItem.orderLineId) {
          return updatedItem;
        }
        return item;
      }).toList();

      final updatedOrderItemsData = state.orderItemsData.copyWith(
        orderLines: updatedOrderLines,
      );

      /* checking if any orderline is selected */
      final isItemsSelected = updatedOrderItemsData.orderLines
          ?.any((orderLine) => orderLine.isSelected == true);

      /* checking if all selected items return quantity entered */
      final isQuantityEnteredonSelected = updatedOrderItemsData.orderLines!
          .where((orderLine) => orderLine.isSelected == true)
          .every((order) =>
              order.returnedQuantity != null &&
              order.returnedQuantity.toString().isNotEmpty);

      final isBtnEnabled =
          isQuantityEnteredonSelected && isItemsSelected == true;

      emit(state.copyWith(
        orderItemsData: updatedOrderItemsData,
        isProceedBtnEnabled: isBtnEnabled,
        lastSelectedItem: updatedItem,
      ));
    } catch (e) {
      emit(state.copyWith(
        isError: true,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateOrderItemsInternalState(
    UpdateOrderItemsInternalState event,
    Emitter<ReturnsState> emit,
  ) async {
    try {
      final updatedOrderItemsData = state.orderItemsData.copyWith(
        isCustomerVerificationRequired: false,
        customer: state.orderItemsData.customer?.copyWith(
          customerName: event.customerName,
          phoneNumber: state.orderItemsData.customer?.phoneNumber?.copyWith(
            number: event.customerNumber,
          ),
          isProxyNumber: false,
        ),
      );

      emit(
        state.copyWith(
          isOrderItemsFetched: true,
          isFetchingOrderItems: true,
          orderItemsData: updatedOrderItemsData,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        isError: true,
        errorMessage: e.toString(),
      ));
    } finally {
      emit(state.copyWith(
        isOrderItemsFetched: false,
        isCustomerOrdersDataFetched: false,
        isError: false,
      ));
    }
  }
}
