// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blossom_tab_controller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlossomTabController<T> _$BlossomTabControllerFromJson<T>(
        Map<String, dynamic> json, T Function(Map<String, dynamic>) dataFromJson) =>
    BlossomTabController<T>(
      currentTab: json['currentTab'] as String?,
      tabs: (json['tabs'] as List<dynamic>)
          .map((e) => BlossomTab.fromJson<T>(e as Map<String, dynamic>, dataFromJson))
          .toList(),
    );

Map<String, dynamic> _$BlossomTabControllerToJson(BlossomTabController instance) =>
    <String, dynamic>{
      'tabs': instance.tabs.map((e) => e.toJson()).toList(),
      'currentTab': instance.currentTab,
    };
