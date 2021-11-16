import 'package:blossom_tabs/src/blossom_tab.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:scoped_model/scoped_model.dart';

part 'blossom_tab_controller.g.dart';

///  set initial [currentTab] by passing [_currentTab], afterward change happen automatically.
///
/// To keep track of state change use [BlossomTabControllerScopeDescendant] as parent
@JsonSerializable(explicitToJson: true)
class BlossomTabController<T> extends Model {
  BlossomTabController({String? currentTab, required this.tabs})
      : _currentTab = currentTab {
    tabs.sort((a, b) => b.isSticky ? 1 : -1);
  }

  String? _currentTab;

  final List<BlossomTab<T>> tabs;

  @JsonKey(ignore: true)
  PageController pageController = PageController();

  String? get currentTab => _currentTab;

  static BlossomTabController<S> fromJson<S>(
      Map<String, dynamic> json, S Function(Map<String, dynamic>) dataFromJson) {
    final _c = _$BlossomTabControllerFromJson<S>(json, dataFromJson);
    _c.pageController =
        PageController(initialPage: _c.tabs.indexWhere((e) => e.id == _c.currentTab));
    return _c;
  }

  Map<String, dynamic> toJson() => _$BlossomTabControllerToJson(this);

  set currentTab(String? tab) {
    _currentTab = tab;
    try {
      pageController.jumpToPage(tabs.indexWhere((e) => e.id == tab));
    } catch (e) {}
    notifyListeners();
  }

  void removeTabById(String id) {
    final i = tabs.indexWhere((e) => e.id == id);
    tabs.removeWhere((e) => e.id == id);
    if (currentTab == id) {
      currentTab = tabs.isEmpty
          ? null
          : tabs.length == i
              ? tabs.last.id
              : tabs[i].id;
    }
    notifyListeners();
  }

  void addTab(BlossomTab<T> tab) {
    tabs.add(tab);
    notifyListeners();
  }
}

class BlossomTabControllerScope<T> extends StatelessWidget {
  const BlossomTabControllerScope(
      {Key? key, required this.child, required this.controller})
      : super(key: key);
  final Widget child;
  final BlossomTabController<T> controller;
  @override
  Widget build(BuildContext context) {
    return ScopedModel<BlossomTabController<T>>(
      model: controller,
      child: child,
    );
  }
}

class BlossomTabControllerScopeDescendant<T> extends StatelessWidget {
  final Widget Function(BuildContext context, BlossomTabController<T>) builder;

  final bool rebuildOnChange;

  const BlossomTabControllerScopeDescendant({
    Key? key,
    required this.builder,
    this.rebuildOnChange = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      ScopedModel.of<BlossomTabController<T>>(context, rebuildOnChange: rebuildOnChange);
    } catch (e) {
      throw '''Error: Could not find any "BlossomTabControllerScope<$T>" ancestor.

To fix:
  Try adding "BlossomTabControllerScope" with "<$T>" as parent of the widgets.

  ** see if data type match with controller, model and view. it needs to be same in all the places
  or you can leave it empty. but we recommend you always provide a data type.

      ''';
    }
    return builder(
      context,
      ScopedModel.of<BlossomTabController<T>>(context, rebuildOnChange: rebuildOnChange),
    );
  }
}
