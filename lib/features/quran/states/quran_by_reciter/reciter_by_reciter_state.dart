part of 'quran_by_reciter_bloc.dart';

@freezed
class QuranByReciterState with _$SongsByArtistState {
  const factory QuranByReciterState.loading(List<QuranModel> quran) = _Loading;
  const factory QuranByReciterState.loaded(List<QuranModel> quran) = _Loaded;
  const factory QuranByReciterState.error(
      String error, List<QuranModel> songs) = _Error;
}
