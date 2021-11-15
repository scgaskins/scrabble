// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Board _$BoardFromJson(Map<String, dynamic> json) => Board()
  ..board = (json['board'] as List<dynamic>)
      .map((e) => (e as List<dynamic>)
          .map((e) =>
              e == null ? null : Tile.fromJson(e as Map<String, dynamic>))
          .toList())
      .toList();

Map<String, dynamic> _$BoardToJson(Board instance) => <String, dynamic>{
      'board': instance.board
          .map((e) => e.map((e) => e?.toJson()).toList())
          .toList(),
    };
