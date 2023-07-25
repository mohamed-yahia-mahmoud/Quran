// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuranModel _$QuranModelFromJson(Map<String, dynamic> json) => $checkedCreate(
      'QuranModel',
      json,
      ($checkedConvert) {
        final val = QuranModel(
          id: $checkedConvert('id', (v) => v as int? ?? 0),
          audioUrl: $checkedConvert('audio_url', (v) => v as String? ?? ''),
        );
        return val;
      },
      fieldKeyMap: const {'audioUrl': 'audio_url'},
    );

Map<String, dynamic> _$QuranModelToJson(QuranModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'audio_url': instance.audioUrl,
    };
