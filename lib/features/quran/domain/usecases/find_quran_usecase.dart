import 'package:injectable/injectable.dart';
import 'package:quran/cores/usecase/usecase.dart';
import 'package:quran/features/quran/data/models/quran_model.dart';
import 'package:quran/features/quran/domain/quran_repository.dart';

@lazySingleton
class FindQuranUsecase extends Usecase<String, List<QuranModel>> {
  final QuranRepository _musicRepository;
  FindQuranUsecase(
      {required super.uuidGenerator,
      @preResolve required QuranRepository musicRepository})
      : _musicRepository = musicRepository;

  @override
  Future<List<QuranModel>> calling(String params) {
    return _musicRepository.findQuran(keyword: params, processId: processId);
  }
}
