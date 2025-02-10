part of 'search_bloc.dart';

@immutable
class SearchState {
  final List<ScanProductsResponse> searchResultsData;
  final bool isLoading;
  final bool isError;
  final String errorMessage;
  final bool isResetAll;

  const SearchState({
    this.searchResultsData = const <ScanProductsResponse>[],
    this.isLoading = false,
    this.isError = false,
    this.errorMessage = '',
    this.isResetAll = false,
  });

  SearchState copyWith({
    List<ScanProductsResponse>? searchResultsData,
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    bool? isResetAll,
  }) {
    return SearchState(
      searchResultsData: searchResultsData ?? this.searchResultsData,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      isResetAll: isResetAll ?? this.isResetAll,
    );
  }
}
