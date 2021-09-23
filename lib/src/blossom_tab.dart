import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blossom_tab.g.dart';

T _dataFromJson<T>(
        Map<String, dynamic> data, T Function(Map<String, dynamic>) dataFromJson) =>
    data.keys.length == 1 && data.keys.first == 'value'
        ? data['value']
        : dataFromJson(data);

Map<String, dynamic>? _dataToJson<T>(T data) =>
    data is String || data is int || data is double || data is bool
        ? {'value': data}
        : (data as dynamic)?.toJson();

@JsonSerializable()
class BlossomTab<T> {
  const BlossomTab({
    required this.id,
    this.data,
    this.title,
    this.icon,
    this.activeIcon,
    this.isSticky = false,
    this.maxWidth = 200,
    this.stickyWidth = 50,
    this.style,
    this.activeStyle,
    this.actions = const [],
  }) : assert(title != null || icon != null,
            'title and iconData both can\'t be null at the same time');
  final String id;
  @JsonKey(fromJson: _dataFromJson, toJson: _dataToJson)
  final T? data;
  final String? title;
  final bool isSticky;
  final double maxWidth;
  final double stickyWidth;
  @JsonKey(ignore: true)
  final TextStyle? style;
  @JsonKey(ignore: true)
  final TextStyle? activeStyle;
  @JsonKey(ignore: true)
  final Widget? icon;
  @JsonKey(ignore: true)
  final Widget? activeIcon;
  @JsonKey(ignore: true)
  final List<Widget> actions;

  static BlossomTab<S> fromJson<S>(
          Map<String, dynamic> json, S Function(Map<String, dynamic>) dataFromJson) =>
      _$BlossomTabFromJson<S>(json, dataFromJson);
  Map<String, dynamic> toJson() => _$BlossomTabToJson(this);

  Widget build(BuildContext context, bool isActive) {
    return isSticky
        ? Center(
            child: (isActive ? activeIcon ?? icon : icon) ??
                Text(title ?? '', style: isActive ? activeStyle ?? style : style))
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              children: [
                (isActive ? activeIcon ?? icon : icon) ??
                    const SizedBox(
                      width: 10,
                    ),
                Text(title ?? '', style: isActive ? activeStyle ?? style : style),
              ],
            ),
          );
  }
}
