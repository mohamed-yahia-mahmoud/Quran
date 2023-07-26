import 'dart:convert';

import 'package:quran/features/quran/domain/usecases/find_quran_by_resicuter_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:quran/features/quran/data/models/quran_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'quran_by_reciter_event.dart';
part 'reciter_by_reciter_state.dart';
part 'quran_by_reciter_bloc.freezed.dart';

@lazySingleton
class QuranByReciterBloc
    extends Bloc<QuranByReciter, Map<String, QuranByReciterState>> {
  List<QuranModel> savedQuranList = [];
  final FindQuranByRecicterUsecase _findQuranByRecicterUsecase;
  QuranByReciterBloc(
      {@preResolve
      required FindQuranByRecicterUsecase findQuranByRecicterUsecase})
      : _findQuranByRecicterUsecase = findQuranByRecicterUsecase,
        super(<String, QuranByReciterState>{}) {
    on<QuranByReciter>((event, emit) {
      return event.maybeMap<void>(loadSongs: (value) async {
        await loadQuranByReciterEventListener(
            reciter: value.artistName, emit: emit);
        return;
      }, orElse: () {
        return;
      });
    });
  }
  Future<void> loadQuranByReciterEventListener(
      {required String reciter,
      required Emitter<Map<String, QuranByReciterState>> emit}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    emit({
      ...state,
      reciter:
          state[reciter.toLowerCase()] ?? const QuranByReciterState.loading([])
    });
    return _findQuranByRecicterUsecase(reciter).then((result) {
      return result.when<void>(ok: (ok) {
        if (ok.isNotEmpty) {
          savedQuranList = ok;
          pref.clear();
          pref.setString('savedQuranList', jsonEncode(ok));
        }
        return emit(
            {...state, reciter.toLowerCase(): QuranByReciterState.loaded(ok)});
      }, err: (err) {
        return emit({
          ...state,
          reciter.toLowerCase(): QuranByReciterState.error(
            err.message,
            state[reciter.toLowerCase()] == null
                ? []
                : (state[reciter.toLowerCase()])!.quran,
          )
        });
      });
    });
  }
}
