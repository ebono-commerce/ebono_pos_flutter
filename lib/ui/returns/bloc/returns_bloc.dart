import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'returns_event.dart';
part 'returns_state.dart';

class ReturnsBloc extends Bloc<ReturnsEvent, ReturnsState> {
  ReturnsBloc() : super(const ReturnsState()) {
    on<ReturnsEvent>(
      (event, emit) => emit(state.updateSingleParameter(isLoading: true)),
    );

    on<FetchCustomerOrdersData>((event, emit) {
      emit(state.updateSingleParameter(isCustomerOrdersDataFetched: true));
    });

    on<FetchOrderDataBasedOnOrderId>((event, emit) {
      emit(state.updateSingleParameter(isOrderItemsFetched: true));
    });
  }
}
