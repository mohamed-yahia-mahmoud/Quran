import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'quran_model.g.dart';

@JsonSerializable(
  checked: true,
)
class QuranModel extends Equatable {
  @JsonKey(name: 'id', disallowNullValue: false, defaultValue: 0)
  final int id;

  @JsonKey(name: 'audio_url', disallowNullValue: false, defaultValue: "")
  final String audioUrl;

  const QuranModel({
    required this.id,
    required this.audioUrl,
  });

  factory QuranModel.fromJson(Map<String, dynamic> json) =>
      _$QuranModelFromJson(json);
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'audio_url': audioUrl,
    };
  }

  static QuranModel example() {
    return const QuranModel(
      id: 1,
      audioUrl:
          "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/fb/cf/0f/fbcf0ff7-b1cc-d90c-88ae-041b212bbbd8/mzaf_16418641854287890302.plus.aac.p.m4a",
    );
  }

  @override
  List<Object?> get props => [id, audioUrl];
}
