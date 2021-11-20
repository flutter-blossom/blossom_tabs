import 'package:blossom_tabs/src/blossom_tab.dart';
import 'package:blossom_tabs/src/blossom_tab_controller.dart';
import 'package:flutter/material.dart';

class BlossomTabView<T> extends StatelessWidget {
  const BlossomTabView({Key? key, required this.builder}) : super(key: key);
  final Widget Function(BlossomTab<T> id) builder;

  @override
  Widget build(BuildContext context) {
    return BlossomTabControllerScopeDescendant<T>(
      builder: (context, controller) {
        return PageView.custom(
          controller: controller.pageController,
          childrenDelegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return _BlossomTabView(
                  key: ValueKey<BlossomTab<T>>(controller.tabs[index]),
                  child: builder(controller.tabs[index]),
                );
              },
              childCount: controller.tabs.length,
              findChildIndexCallback: (Key key) {
                final ValueKey<BlossomTab<T>> valueKey = key as ValueKey<BlossomTab<T>>;
                return controller.tabs.indexOf(valueKey.value);
              }),
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
