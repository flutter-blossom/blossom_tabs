import 'package:blossom_tabs/src/blossom_tab_controller.dart';
import 'package:flutter/material.dart';

class BlossomTabView<T> extends StatelessWidget {
  const BlossomTabView({Key? key, required this.builder}) : super(key: key);
  final Widget Function(BuildContext context, T? data) builder;

  @override
  Widget build(BuildContext context) {
    return BlossomTabControllerScopeDescendant<T>(builder: (context, controller) {
      return PageView(
        controller: controller.pageController,
        // itemCount: controller.tabs.length,
        physics: const NeverScrollableScrollPhysics(),
        children: controller.tabs.map((e) {
          return _BlossomTabView(
            key: ValueKey(e.id),
            child: builder(context, e.data),
          );
        }).toList(),
      );
    });
  }
}

class _BlossomTabView extends StatefulWidget {
  const _BlossomTabView({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  _BlossomTabViewState createState() => _BlossomTabViewState();
}

class _BlossomTabViewState extends State<_BlossomTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
