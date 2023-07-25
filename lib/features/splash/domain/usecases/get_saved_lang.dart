import 'package:dartz/dartz.dart';
import 'package:quran/cores/error/failures.dart';
import 'package:quran/cores/usecase/usecas_lang.dart';
import '../repositories/lang_repository.dart';

class GetSavedLangUseCase implements UseCase<String, NoParams> {
  final LangRepository langRepository;

  GetSavedLangUseCase({required this.langRepository});

  @override
  Future<Either<Failure, String>> call(NoParams params) async =>
      await langRepository.getSavedLang();
}
