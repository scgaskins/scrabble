// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TileBag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TileBag _$TileBagFromJson(Map<String, dynamic> json) => TileBag()
  ..lettersRemaining = Map<String, int>.from(json['lettersRemaining'] as Map)
  ..tileCount = json['tileCount'] as int;

Map<String, dynamic> _$TileBagToJson(TileBag instance) => <String, dynamic>{
      'lettersRemaining': instance.lettersRemaining,
      'tileCount': instance.tileCount,
    };
