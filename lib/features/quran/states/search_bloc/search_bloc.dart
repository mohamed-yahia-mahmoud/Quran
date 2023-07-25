import 'package:quran/features/quran/domain/usecases/find_quran_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/quran_model.dart';

part 'search_event.dart';
part 'search_state.dart';
part 'search_bloc.freezed.dart';

@lazySingleton
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final FindQuranUsecase _findQuranUsecase;
  SearchBloc({@preResolve required FindQuranUsecase findQuranUsecase})
      : _findQuranUsecase = findQuranUsecase,
        super(const SearchState.cleared()) {
    on<SearchEvent>((event, emit) {
      return event.maybeMap<void>(
          search: (value) async {
            await _searchSongEventListener(keyword: value.keyword, emit: emit);
            return;
          },
          clearSearchResult: (value) {
            _clearSongEventFilter(emit: emit);
            return;
          },
          orElse: () {});
    });
  }
  Future<void> _searchSongEventListener({
    required String keyword,
    required Emitter<SearchState> emit,
  }) async {
    emit(const SearchState.loading());
    return _findQuranUsecase(keyword).then((result) {
      return result.when<void>(ok: (ok) {
        emit(SearchState.loaded(
          songs: ok,
        ));
        return;
      }, err: (err) {
        emit(SearchState.error(error: err.message));
        return;
      });
    });
  }

  void _clearSongEventFilter({
    required Emitter<SearchState> emit,
  }) {
    emit(const SearchState.cleared());
    return;
  }
}
