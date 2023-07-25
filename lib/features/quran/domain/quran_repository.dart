import 'package:quran/features/quran/data/models/quran_model.dart';

/// Music Repository
///
/// Music Repository data from remote datasource or local data
abstract class QuranRepository {
  Future<List<String>> getRecicter();

  /// get music by artist name
  ///
  /// will return List of Music filtered by artistName
  Future<List<QuranModel>> getQuranByRecicter(
      {required String artistName, required String processId});

  Future<List<QuranModel>> findQuran(
      {required String keyword, required String processId});
}
