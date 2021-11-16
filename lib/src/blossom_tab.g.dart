// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blossom_tab.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlossomTab<T> _$BlossomTabFromJson<T>(
        Map<String, dynamic> json, T Function(Map<String, dynamic>) dataFromJson) =>
    BlossomTab<T>(
      id: json['id'] as String,
      data: _dataFromJson<T>(json['data'] as Map<String, dynamic>, dataFromJson),
      title: json['title'] as String?,
      isSticky: json['isSticky'] as bool? ?? false,
      maxSize: (json['maxSize'] as num?)?.toDouble() ?? 200,
      stickySize: (json['stickySize'] as num?)?.toDouble() ?? 50,
      useRow: json['useRow'] as bool? ?? true,
    );

Map<String, dynamic> _$BlossomTabToJson<T>(BlossomTab<T> instance) => <String, dynamic>{
      'id': instance.id,
      'data': _dataToJson(instance.data),
      'title': instance.title,
      'isSticky': instance.isSticky,
      'maxSize': instance.maxSize,
      'stickySize': instance.stickySize,
      'useRow': instance.useRow,
    };
