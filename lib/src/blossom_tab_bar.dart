// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:blossom_tabs/src/blossom_tab.dart';
import 'package:blossom_tabs/src/blossom_tab_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';

class BlossomTabBar<T> extends StatefulWidget {
  const BlossomTabBar({
    Key? key,
    required this.selectedColor,
    this.dragColor,
    this.stickyColor,
    this.backgroundColor,
    this.bottomColor,
    this.dividerColor,
    this.shadowColor,
    this.dragShadowColor,
    this.height = 42,
    this.tabBarMargin = 4,
    this.margin = EdgeInsets.zero,
    this.bottomBarHeight = 0,
    this.bottomBar,
    this.showBottomBarOnOppositeSide = false,
    this.shiftOnDrag = false,
    this.borderRadius = const Radius.circular(8.0),
    this.showIndicator = false,
    this.showIndicatorOnOppositeSide = false,
    this.applyIndicatorIndent = true,
    this.indicatorThickness = 4.0,
    this.indicatorColor,
    this.actions = const [],
    this.onSecondaryTap,
  }) : super(key: key);
  final Color selectedColor;
  final Color? dragColor;
  final Color? stickyColor;
  final Color? backgroundColor;
  final Color? bottomColor;
  final Color? dividerColor;
  final Color? shadowColor;
  final Color? dragShadowColor;
  final double height;
  final double tabBarMargin;
  final EdgeInsets margin;
  final Radius borderRadius;
  final double bottomBarHeight;
  final Widget? bottomBar;
  final bool showBottomBarOnOppositeSide;
  final bool shiftOnDrag;
  final bool showIndicator;
  final bool showIndicatorOnOppositeSide;
  final bool applyIndicatorIndent;
  final double indicatorThickness;
  final Color? indicatorColor;
  final List<Widget> actions;
  final void Function(T)? onSecondaryTap;

  @override
  State<BlossomTabBar> createState() => _BlossomTabBarState<T>();
}

class _BlossomTabBarState<K> extends State<BlossomTabBar> {
  String? dragId;
  String? hoverId;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.bottomBarHeight != 0 && widget.showBottomBarOnOppositeSide)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (_) {},
            onTap: () {},
            onDoubleTap: () {},
            child: Container(
              color: widget.bottomColor,
              height: widget.bottomBarHeight,
              child: widget.bottomBar,
            ),
          ),
        Container(
          color: widget.backgroundColor,
          height: widget.height - widget.bottomBarHeight,
          child: Padding(
            padding: widget.margin,
            child: BlossomTabControllerScopeDescendant<K>(builder: (context, controller) {
              final index = controller.currentTab == null
                  ? 0
                  : controller.tabs.indexWhere((e) => e.id == controller.currentTab);
              final hoverIndex = hoverId == null
                  ? 0
                  : controller.tabs.indexWhere((e) => e.id == hoverId);
              return Row(
                children: [
                  ...controller.tabs.map((e) {
                    final showDivider = ((e.id != controller.currentTab &&
                        e.id != hoverId &&
                        (controller.currentTab == null ||
                            index == -1 ||
                            controller.tabs[index == 0 ? 0 : index - 1].id != e.id) &&
                        (hoverId == null ||
                            !controller.tabs.any((el) => el.id == hoverId) ||
                            (hoverIndex >= 0 &&
                                hoverIndex - 1 < controller.tabs.length - 1 &&
                                controller
                                        .tabs[hoverIndex == 0 ? 0 : hoverIndex - 1].id !=
                                    e.id))));
                    return Flexible(
                      flex: e.isSticky ? 0 : 1,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: e.isSticky ? e.stickySize : e.maxSize,
                          minWidth: e.stickySize,
                        ),
                        child: MouseRegion(
                          onEnter: (_) {
                            if (dragId == null) setState(() => hoverId = e.id);
                          },
                          onExit: (_) => setState(() => hoverId = null),
                          child: GestureDetector(
                            onTap: dragId == null ? () {} : null,
                            onDoubleTap: () {},
                            onSecondaryTap: () => widget.onSecondaryTap?.call(e),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Draggable<BlossomTab<K>>(
                                  data: e,
                                  axis: Axis.horizontal,
                                  maxSimultaneousDrags: e.isSticky ? 0 : 1,
                                  onDragStarted: () {
                                    setState(() => dragId = e.id);
                                  },
                                  onDragCompleted: () => setState(() {
                                    hoverId = null;
                                    dragId = null;
                                    // just to notify the change in order of tabs
                                    controller.currentTab = controller.currentTab;
                                  }),
                                  onDraggableCanceled: (_, __) => setState(() {
                                    hoverId = null;
                                    dragId = null;
                                    // just to notify the change in order of tabs
                                    controller.currentTab = controller.currentTab;
                                  }),
                                  onDragEnd: (_) => setState(() {
                                    hoverId = null;
                                    dragId = null;
                                    // just to notify the change in order of tabs
                                    controller.currentTab = controller.currentTab;
                                  }),
                                  feedback: ScopedModel(
                                    model: controller,
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: Transform.translate(
                                        offset: Offset(0, widget.tabBarMargin / 2),
                                        child: Container(
                                          height: widget.height -
                                              widget.bottomBarHeight -
                                              widget.margin.top -
                                              widget.margin.bottom,
                                          width: constraints.maxWidth,
                                          decoration: BoxDecoration(
                                            color:
                                                widget.dragColor ?? widget.selectedColor,
                                            borderRadius: widget.shiftOnDrag
                                                ? BorderRadius.all(
                                                    widget.borderRadius,
                                                  )
                                                : widget.tabBarMargin == 0
                                                    ? BorderRadius.all(
                                                        widget.borderRadius,
                                                      )
                                                    : BorderRadius.vertical(
                                                        top: widget.borderRadius),
                                            boxShadow: [
                                              if (widget.shiftOnDrag &&
                                                  widget.selectedColor.opacity == 1.0)
                                                BoxShadow(
                                                  color: widget.dragShadowColor ??
                                                      const Color(0xff4444444),
                                                  offset: const Offset(0, 0),
                                                  blurRadius: 4.0,
                                                  spreadRadius: 0.0,
                                                )
                                            ],
                                          ),
                                          child: e.build(
                                            context,
                                            e.id == controller.currentTab ||
                                                e.id == hoverId,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: DragTarget<BlossomTab<K>>(
                                    onWillAccept: (t) {
                                      final result = t != null &&
                                          controller.tabs.contains(t) &&
                                          !e.isSticky;
                                      if (result) {
                                        setState(() {
                                          final i = controller.tabs.indexOf(e);
                                          controller.tabs.remove(t);
                                          controller.tabs.insert(i, t!);
                                        });
                                      }
                                      return result;
                                    },
                                    builder: (_, tbs, ___) {
                                      return Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: VerticalDivider(
                                              color: dragId != null || showDivider
                                                  ? widget.dividerColor
                                                  : Colors.transparent,
                                              width: 1,
                                              indent: 8 + widget.tabBarMargin,
                                              endIndent: 8,
                                            ),
                                          ),
                                          Listener(
                                            onPointerDown: (_) {
                                              dragId == null
                                                  ? controller.currentTab = e.id
                                                  : null;
                                            },
                                            child: Opacity(
                                              opacity: dragId == e.id ? 0 : 1,
                                              child: Container(
                                                height: double.infinity,
                                                margin: EdgeInsets.only(
                                                    top: e.id == hoverId
                                                        ? widget.tabBarMargin / 2
                                                        : widget.tabBarMargin),
                                                decoration: e.id ==
                                                            controller.currentTab ||
                                                        e.id == hoverId && dragId == null
                                                    ? BoxDecoration(
                                                        color: e.isSticky
                                                            ? widget.stickyColor ??
                                                                widget.selectedColor
                                                            : widget.selectedColor,
                                                        borderRadius: widget
                                                                    .tabBarMargin ==
                                                                0
                                                            ? BorderRadius.all(
                                                                widget.borderRadius,
                                                              )
                                                            : BorderRadius.vertical(
                                                                top: widget.borderRadius),
                                                        boxShadow: [
                                                            if (!e.isSticky &&
                                                                widget.selectedColor
                                                                        .opacity ==
                                                                    1.0)
                                                              BoxShadow(
                                                                color: widget
                                                                        .shadowColor ??
                                                                    const Color(
                                                                            0xff4444444)
                                                                        .withOpacity(0.4),
                                                                offset:
                                                                    const Offset(0, 0),
                                                                blurRadius: 4.0,
                                                                spreadRadius: 0.0,
                                                              )
                                                          ])
                                                    : null,
                                                child: e.build(
                                                    context,
                                                    e.id == controller.currentTab ||
                                                        e.id == hoverId),
                                              ),
                                            ),
                                          ),
                                          if (widget.showIndicator &&
                                              e.id == controller.currentTab)
                                            Align(
                                              alignment:
                                                  widget.showIndicatorOnOppositeSide
                                                      ? Alignment.topCenter
                                                      : Alignment.bottomCenter,
                                              child: Divider(
                                                thickness: widget.indicatorThickness,
                                                color: widget.indicatorColor,
                                                height: widget.indicatorThickness,
                                                indent: widget.applyIndicatorIndent
                                                    ? widget.borderRadius.y / 2
                                                    : null,
                                                endIndent: widget.applyIndicatorIndent
                                                    ? widget.borderRadius.y / 2
                                                    : null,
                                              ),
                                            ),
                                          if (e.id == hoverId && dragId == null)
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 4.0,
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: e.actions,
                                                ),
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  ...widget.actions
                ],
              );
            }),
          ),
        ),
        if (widget.bottomBarHeight != 0 && !widget.showBottomBarOnOppositeSide)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (_) {},
            onTap: () {},
            onDoubleTap: () {},
            child: Container(
              color: widget.bottomColor,
              height: widget.bottomBarHeight,
              child: widget.bottomBar,
            ),
          )
      ],
    );
  }
}
