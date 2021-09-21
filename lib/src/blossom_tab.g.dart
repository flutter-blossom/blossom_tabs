// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blossom_tab.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlossomTab<T> _$BlossomTabFromJson<T>(Map<String, dynamic> json) =>
    BlossomTab<T>(
      id: json['id'] as String,
      data: _dataFromJson(json['data'] as Map<String, dynamic>),
      title: json['title'] as String?,
      isSticky: json['isSticky'] as bool? ?? false,
      maxWidth: (json['maxWidth'] as num?)?.toDouble() ?? 200,
      stickyWidth: (json['stickyWidth'] as num?)?.toDouble() ?? 50,
    );

Map<String, dynamic> _$BlossomTabToJson<T>(BlossomTab<T> instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data': _dataToJson(instance.data),
      'title': instance.title,
      'isSticky': instance.isSticky,
      'maxWidth': instance.maxWidth,
      'stickyWidth': instance.stickyWidth,
    };
