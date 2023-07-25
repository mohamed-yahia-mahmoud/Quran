part of 'search_bloc.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState.loading(
      {List<QuranModel>? songs, @Default(true) bool isLoading}) = _Loading;

  const factory SearchState.loaded(
      {required List<QuranModel> songs,
      @Default(false) bool isLoading}) = _Loaded;

  const factory SearchState.error(
      {required String error,
      List<QuranModel>? songs,
      @Default(false) bool isLoading}) = _Error;

  const factory SearchState.cleared(
      {@Default(<QuranModel>[]) List<QuranModel> songs,
      @Default(false) bool isLoading,
      @Default(true) bool isCleared}) = _Cleared;
}
