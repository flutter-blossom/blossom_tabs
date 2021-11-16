import 'package:blossom_tabs/src/blossom_tab.dart';
import 'package:blossom_tabs/src/blossom_tab_controller.dart';
import 'package:flutter/material.dart';

class BlossomTabView<T> extends StatelessWidget {
  const BlossomTabView({Key? key, required this.buildChildren}) : super(key: key);
  final List<Widget> Function(List<BlossomTab<T>> tabs) buildChildren;

  @override
  Widget build(BuildContext context) {
    return BlossomTabControllerScopeDescendant<T>(
      builder: (context, controller) {
        return PageView(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: buildChildren(controller.tabs)
              .map((e) => _BlossomTabView(child: e))
              .toList(),
          pageSnapping: false,
        );
      },
    );
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
