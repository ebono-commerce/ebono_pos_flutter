import 'package:ebono_pos/models/scan_products_response.dart';
import 'package:ebono_pos/ui/search/repository/search_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _searchRepository;
  SearchBloc(this._searchRepository)
      : super(SearchState(isResetAll: false, searchResultsData: [])) {
    on<SearchEvent>(_onSearchEvent);
    on<TriggerSearchEvent>(_onTriggerSearchEvent);
    on<ClearSearchEvent>(_onClearSearchEvent);
    on<ResetSearchEvent>(_onResetAllEvent);
  }

  void _onSearchEvent(SearchEvent event, Emitter<SearchState> emit) {
    emit(state.copyWith(isLoading: true));
  }

  void _onTriggerSearchEvent(
    TriggerSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    try {
      List<ScanProductsResponse> result =
          await _searchRepository.searchItems(searchText: event.searchText);
      emit(state.copyWith(
        isError: false,
        isLoading: false,
        isResetAll: false,
        searchResultsData: result,
      ));
    } catch (e) {
      emit(state.copyWith(
        isError: true,
        isLoading: false,
        isResetAll: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onClearSearchEvent(SearchEvent event, Emitter<SearchState> emit) async {
    try {
      emit(state.copyWith(
        isLoading: false,
        searchResultsData: [],
      ));
    } catch (e) {
      emit(state.copyWith(
        isError: true,
        isLoading: false,
        isResetAll: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onResetAllEvent(
      ResetSearchEvent event, Emitter<SearchState> emit) async {
    try {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: '',
        isError: false,
        isResetAll: true,
        searchResultsData: [],
      ));
    } catch (e) {
      emit(state.copyWith(
        isError: true,
        isLoading: false,
        isResetAll: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
