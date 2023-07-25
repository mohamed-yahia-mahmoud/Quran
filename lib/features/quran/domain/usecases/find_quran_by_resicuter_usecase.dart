import 'package:injectable/injectable.dart';
import 'package:quran/cores/usecase/failure.dart';
import 'package:quran/cores/usecase/usecase.dart';
import 'package:quran/features/quran/data/models/quran_model.dart';
import 'package:quran/features/quran/domain/quran_repository.dart';

@lazySingleton
class FindQuranByRecicterUsecase extends Usecase<String, List<QuranModel>> {
  final QuranRepository _musicRepository;
  FindQuranByRecicterUsecase(
      {@preResolve required super.uuidGenerator,
      @preResolve required QuranRepository musicRepository})
      : _musicRepository = musicRepository;

  @override
  Future<List<QuranModel>> calling(String params) {
    if (params.isEmpty) {
      throw Failure(
          message: "error", trace: StackTrace.current, processId: processId);
    }
    return _musicRepository.getQuranByRecicter(
        artistName: params, processId: processId);
  }
}
