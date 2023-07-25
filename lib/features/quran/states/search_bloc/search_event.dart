part of 'search_bloc.dart';

@freezed
class SearchEvent with _$SearchEvent {
  const factory SearchEvent.search(String keyword) = _Search;
  const factory SearchEvent.clearSearchResult() = _ClearSearchResult;
}