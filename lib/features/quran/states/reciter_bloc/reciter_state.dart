part of 'reciter_bloc.dart';

@freezed
class ReciterState with _$ArtistsState {
  factory ReciterState.loading({
    List<String>? artists,
    @Default(true) bool isLoading,
  }) = _Loading;

  const factory ReciterState.loaded({
    required List<String> artists,
    @Default(false) bool isLoading,
  }) = _Loaded;

  const factory ReciterState.error({
    required String error,
    List<String>? artists,
    @Default(false) bool isLoading,
  }) = _Error;
}
