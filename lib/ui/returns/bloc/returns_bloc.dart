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
    on<ReturnsEvent>(
      (event, emit) => emit(state.updateSelectedParameters(isLoading: true)),
    );

    on<FetchCustomerOrdersData>((event, emit) async {
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
    });

    on<FetchOrderDataBasedOnOrderId>((event, emit) async {
      try {
        OrderItemsModel orderItemsData =
            await returnsRepository.fetchOrderItemBasedOnOrderId(
          orderId: event.orderId,
        );

        emit(state.updateSelectedParameters(
          isOrderItemsFetched: true,
          isLoading: false,
          orderItemsData: orderItemsData,
        ));
      } catch (e) {
        emit(state.updateSelectedParameters(
          isError: true,
          errorMessage: e.toString(),
        ));
      }
    });

    // on<UpdateSelectedItem>((event, emit) async {
    //   // final updatedData =
    //   //     state.orderItemsData.orderLines?.forEach((OrderLine orderLine) {
    //   //   if (orderLine.orderLineId == event.id) {
    //   //     orderLine.copyWith(
    //   //       isSelected: orderLine.isSelected,
    //   //     );
    //   //   }
    //   // });

    //   final updatedOrderLines =
    //       event.orderItems.orderLines?.map((OrderLine orderLine) {
    //     if (orderLine.orderLineId == event.id) {
    //       return orderLine.copyWith(
    //         isSelected: !orderLine.isSelected,
    //       );
    //     }
    //     return orderLine;
    //   }).toList();

    //   // final updatedData = event.orderItems.orderLines!.copyWith(
    //   //   orderLines: updatedOrderLines ?? [],
    //   // );

    //   emit(state.updateSelectedParameters(
    //     isCustomerOrdersDataFetched: true,
    //     orderItemsData: state,
    //   ));
    // });
  }
}
