part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

class TriggerSearchEvent extends SearchEvent {
  TriggerSearchEvent(this.searchText);

  final String searchText;
}

class ClearSearchEvent extends SearchEvent {}

class ResetSearchEvent extends SearchEvent {}
