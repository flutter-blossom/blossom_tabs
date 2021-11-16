// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:blossom_tabs/src/blossom_tab.dart';
import 'package:blossom_tabs/src/blossom_tab_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';

class BlossomVerticalTabBar<T> extends StatefulWidget {
  const BlossomVerticalTabBar({
    Key? key,
    required this.selectedColor,
    this.dragColor,
    this.stickyColor,
    this.backgroundColor,
    this.dividerColor,
    this.shadowColor,
    this.dragShadowColor,
    this.width = 42,
    this.sideBarWidth = 0,
    this.tabBarMargin = 4,
    this.margin = EdgeInsets.zero,
    this.sideBar,
    this.sideBarColor,
    this.showSideBarOnOppositeSide = false,
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
  final Color? sideBarColor;
  final Color? dividerColor;

  final Color? shadowColor;
  final Color? dragShadowColor;
  final double width;
  final double tabBarMargin;
  final EdgeInsets margin;
  final Radius borderRadius;
  final double sideBarWidth;
  final Widget? sideBar;
  final bool showSideBarOnOppositeSide;
  final bool shiftOnDrag;
  final bool showIndicator;
  final bool showIndicatorOnOppositeSide;
  final bool applyIndicatorIndent;
  final double indicatorThickness;
  final Color? indicatorColor;
  final List<Widget> actions;
  final void Function(T)? onSecondaryTap;
  @override
  State<BlossomVerticalTabBar> createState() => _BlossomVerticalTabBarState<T>();
}

class _BlossomVerticalTabBarState<K> extends State<BlossomVerticalTabBar> {
  String? dragId;
  String? hoverId;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.sideBarWidth != 0 && widget.showSideBarOnOppositeSide)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (_) {},
            onTap: () {},
            onDoubleTap: () {},
            child: Container(
              color: widget.sideBarColor,
              width: widget.sideBarWidth,
              child: widget.sideBar,
            ),
          ),
        Container(
          color: widget.backgroundColor,
          width: widget.width - widget.sideBarWidth,
          child: Padding(
            padding: widget.margin,
            child: BlossomTabControllerScopeDescendant<K>(builder: (context, controller) {
              final index = controller.currentTab == null
                  ? 0
                  : controller.tabs.indexWhere((e) => e.id == controller.currentTab);
              final hoverIndex = hoverId == null
                  ? 0
                  : controller.tabs.indexWhere((e) => e.id == hoverId);
              return Column(
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
                          maxHeight: e.isSticky ? e.stickySize : e.maxSize,
                          minHeight: e.stickySize,
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
                                  axis: Axis.vertical,
                                  maxSimultaneousDrags: e.isSticky ? 0 : 1,
                                  onDragStarted: () {
                                    setState(() => dragId = e.id);
                                  },
                                  onDragCompleted: () => setState(() {
                                    hoverId = null;
                                    dragId = null;
                                    controller.currentTab = controller.currentTab;
                                  }),
                                  onDraggableCanceled: (_, __) => setState(() {
                                    hoverId = null;
                                    dragId = null;
                                    controller.currentTab = controller.currentTab;
                                  }),
                                  onDragEnd: (_) => setState(() {
                                    hoverId = null;
                                    dragId = null;
                                    controller.currentTab = controller.currentTab;
                                  }),
                                  feedback: ScopedModel(
                                    model: controller,
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: Transform.translate(
                                        offset: Offset(widget.tabBarMargin / 2, 0),
                                        child: Container(
                                          width: widget.width -
                                              widget.sideBarWidth -
                                              widget.margin.right -
                                              widget.margin.left,
                                          height: constraints.maxHeight,
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
                                                    : BorderRadius.horizontal(
                                                        left: widget.borderRadius),
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
                                            alignment: Alignment.bottomCenter,
                                            child: Divider(
                                              color: dragId != null || showDivider
                                                  ? widget.dividerColor
                                                  : Colors.transparent,
                                              height: 1,
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
                                                width: double.infinity,
                                                margin: EdgeInsets.only(
                                                    left: e.id == hoverId
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
                                                            : BorderRadius.horizontal(
                                                                left:
                                                                    widget.borderRadius),
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
                                                      ? Alignment.centerLeft
                                                      : Alignment.centerRight,
                                              child: VerticalDivider(
                                                thickness: widget.indicatorThickness,
                                                color: widget.indicatorColor,
                                                width: widget.indicatorThickness,
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
        if (widget.sideBarWidth != 0 && !widget.showSideBarOnOppositeSide)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (_) {},
            onTap: () {},
            onDoubleTap: () {},
            child: Container(
              color: widget.sideBarColor,
              width: widget.sideBarWidth,
              child: widget.sideBar,
            ),
          )
      ],
    );
  }
}
