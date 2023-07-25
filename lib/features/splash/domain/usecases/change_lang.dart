import 'package:quran/features/splash/domain/repositories/lang_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:quran/cores/error/failures.dart';
import 'package:quran/cores/usecase/usecas_lang.dart';

class ChangeLangUseCase implements UseCase<bool, String> {
  final LangRepository langRepository;

  ChangeLangUseCase({required this.langRepository});

  @override
  Future<Either<Failure, bool>> call(String langCode) async =>
      await langRepository.changeLang(langCode: langCode);
}
