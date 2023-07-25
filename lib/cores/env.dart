import 'package:equatable/equatable.dart';

/// env class
///
/// inherit this class to create new environment
abstract class Env extends Equatable {
  String get name;
  String get findRecicterEndPoint;

  factory Env.create({String envName = "DEV"}) {
    if (envName == "DEV") {
      return DevEnv();
    }
    return ProdEnv();
  }
}

class DevEnv implements Env {
  @override
  String get findRecicterEndPoint =>
      "https://api.Quran.com/api/v4/chapter_recitations/";

  @override
  String get name => "DEV";

  @override
  List<Object?> get props => [
        name,
        findRecicterEndPoint,
      ];

  @override
  bool? get stringify => true;
}

class ProdEnv implements Env {
  @override
  String get findRecicterEndPoint =>
      "https://api.Quran.com/api/v4/chapter_recitations/";

  @override
  String get name => "PROD";

  @override
  List<Object?> get props => [
        name,
        findRecicterEndPoint,
      ];

  @override
  bool? get stringify => true;
}
