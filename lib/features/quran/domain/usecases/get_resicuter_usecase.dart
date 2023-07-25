import 'package:quran/features/quran/domain/quran_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:quran/cores/usecase/usecase.dart';

@lazySingleton
class GetRecicterUsecase extends Usecase<NoUsecaseParams, List<String>> {
  final QuranRepository _musicRepository;
  GetRecicterUsecase(
      {@preResolve required super.uuidGenerator,
      @preResolve required QuranRepository musicRepository})
      : _musicRepository = musicRepository;

  @override
  Future<List<String>> calling(NoUsecaseParams params) {
    return _musicRepository.getRecicter();
  }
}
