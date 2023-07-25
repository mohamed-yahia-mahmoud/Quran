import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:quran/cores/env.dart';
import 'package:quran/cores/usecase/repository_error_handler.dart';
import 'package:quran/features/quran/data/models/quran_model.dart';
import 'package:quran/features/quran/domain/quran_repository.dart';

@LazySingleton(
  as: QuranRepository,
)
class MusicRepositoryImpl implements QuranRepository {
  final Dio _restApiClient;
  final Env _env;

  MusicRepositoryImpl(
      {@preResolve required Dio restApiClient, @preResolve required Env env})
      : _restApiClient = restApiClient,
        _env = env;
  @override
  Future<List<String>> getRecicter() async {
    return ["1"];
  }

  @override
  Future<List<QuranModel>> getQuranByRecicter(
      {required String processId, required String artistName}) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return [];
    }
    try {
      var response = await _restApiClient.get(
        "${_env.findRecicterEndPoint}$artistName?language=en",
      );

      if (response.data['audio_files'] == null) {
        return [];
      }
      if ((response.data['audio_files'] as List).isEmpty) {
        return [];
      }
      debugPrint(response.data['audio_files'].toString());
      return (response.data['audio_files'] as List)
          .map((e) => QuranModel.fromJson(e))
          .toList();
    } catch (e, trace) {
      throw repositoryErrorHandler(err: e, processId: processId, trace: trace);
    }
  }

  @override
  Future<List<QuranModel>> findQuran(
      {required String keyword, required String processId}) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return [];
    }
    try {
      var response = await _restApiClient.get(
        "${_env.findRecicterEndPoint}$keyword?language=en",
      );

      if (response.data['audio_files'] == null) {
        return [];
      }
      if ((response.data['audio_files'] as List).isEmpty) {
        return [];
      }
      debugPrint(response.data['audio_files'].toString());
      return (response.data['audio_files'] as List)
          .map((e) => QuranModel.fromJson(e))
          .toList();
    } catch (e, trace) {
      throw repositoryErrorHandler(err: e, processId: processId, trace: trace);
    }
  }
}
