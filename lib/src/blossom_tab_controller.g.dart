// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blossom_tab_controller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlossomTabController _$BlossomTabControllerFromJson(
        Map<String, dynamic> json) =>
    BlossomTabController(
      currentTab: json['currentTab'] as String?,
      tabs: (json['tabs'] as List<dynamic>)
          .map((e) => BlossomTab.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BlossomTabControllerToJson(
        BlossomTabController instance) =>
    <String, dynamic>{
      'tabs': instance.tabs.map((e) => e.toJson()).toList(),
      'currentTab': instance.currentTab,
    };
