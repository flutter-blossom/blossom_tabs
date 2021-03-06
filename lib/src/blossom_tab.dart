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
  BlossomTab({
    required this.id,
    this.data,
    this.title,
    this.icon,
    this.activeIcon,
    this.isSticky = false,
    this.maxSize = 200,
    this.stickySize = 50,
    this.style,
    this.activeStyle,
    this.useRow = true,
    this.actions = const [],
  }) : assert(title != null || icon != null,
            'title and iconData both can\'t be null at the same time');
  final String id;
  @JsonKey(fromJson: _dataFromJson, toJson: _dataToJson)
  final T? data;
  final String? title;
  final bool isSticky;
  final double maxSize;
  final double stickySize;
  final bool useRow;
  @JsonKey(ignore: true)
  TextStyle? style;
  @JsonKey(ignore: true)
  TextStyle? activeStyle;
  @JsonKey(ignore: true)
  Widget? icon;
  @JsonKey(ignore: true)
  Widget? activeIcon;
  @JsonKey(ignore: true)
  List<Widget> actions;

  static BlossomTab<S> fromJson<S>(
          Map<String, dynamic> json, S Function(Map<String, dynamic>) dataFromJson) =>
      _$BlossomTabFromJson<S>(json, dataFromJson);
  Map<String, dynamic> toJson() => _$BlossomTabToJson(this);

  Widget build(BuildContext context, bool isActive) {
    var children = [
      (isActive ? activeIcon ?? icon : icon) ??
          const SizedBox(
            width: 10,
          ),
      if (title != null)
        Flexible(
          child: Text(
            title!,
            softWrap: false,
            overflow: TextOverflow.fade,
            style: isActive ? activeStyle ?? style : style,
          ),
        ),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: useRow
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(children: children),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              ],
            ),
    );
  }
}
