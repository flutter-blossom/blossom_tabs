import 'dart:convert';
import 'dart:math';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:blossom_tabs/blossom_tabs.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
  doWhenWindowReady(() {
    const initialSize = Size(800, 450);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _controller = BlossomTabController<int>(tabs: []);
  var _tabs = <BlossomTab<int>>[];

  BlossomTab<int> _getTab(String e) => BlossomTab<int>(
          id: e,
          data: int.parse(e.codeUnits.join()),
          title: e.toUpperCase(),
          isSticky: e == 'd',
          stickyWidth: 80,
          activeStyle: e == 'd' ? null : const TextStyle(color: Colors.white),
          icon: e == 'd'
              ? null
              : const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.ac_unit,
                    size: 14,
                    color: Colors.black26,
                  ),
                ),
          activeIcon: e == 'd'
              ? null
              : const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.ac_unit,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
          actions: [
            if (e != 'd')
              Listener(
                onPointerDown: (_) {
                  _controller.removeTabById(e);
                },
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.close,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
          ]);

  @override
  void initState() {
    _tabs = ['a', 'b', 'c', 'd', 'e']
        .map(
          (e) => _getTab(e),
          //     BlossomTab.fromJson<int>(
          //   {
          //     "id": e,
          //     "data": {"value": int.parse(e.codeUnits.join())},
          //     "title": e.toUpperCase(),
          //     "isSticky": e == 'd' ? true : false,
          //     "maxWidth": 200.0,
          //     "stickyWidth": 50.0
          //   },
          //   (map) => map['value'],
          // ),
        )
        .toList();
    _controller = BlossomTabController<int>(currentTab: 'b', tabs: _tabs);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlossomTabControllerScope(
      controller: _controller,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(85),
          child: Stack(
            children: [
              MoveWindow(
                child: BlossomTabBar<int>(
                  height: 85,
                  bottomHeight: 40,
                  selectedColor: Colors.blue,
                  dragColor: Colors.blue.withOpacity(0.6),
                  stickyColor: Colors.white,
                  backgroundColor: Colors.blue.withOpacity(0.3),
                  dividerColor: Colors.blue,
                  bottomColor: Colors.blue,
                  margin: const EdgeInsets.only(left: 4, top: 4, right: 140),
                  marginTop: 4,
                  bottomBar: BlossomTabControllerScopeDescendant<int>(
                      builder: (context, controller) {
                    // Future.delayed(Duration.zero)
                    //     .then((_) => print(jsonEncode(controller.toJson())));
                    return Container(
                      color: controller.currentTab == 'd' ? Colors.white : null,
                    );
                  }),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: NewTabBtn(
                        onTap: () {
                          final z = _controller.tabs.map((e) => e.id).toList()..sort();
                          var c = z.isEmpty ? 'a' : z.last;
                          final lastCharacter =
                              String.fromCharCode(c.codeUnitAt(c.length - 1) + 1);
                          c = c.substring(0, c.length - 1) + lastCharacter;
                          _controller.addTab(_getTab(c));
                        },
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                right: 0,
                child: WindowButtons(),
              ),
            ],
          ),
        ),
        body: BlossomTabView<int>(
          builder: (context, data) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ColorBox(
                  child: Center(
                      child: Text(
                    data.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  )),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class NewTabBtn extends StatefulWidget {
  const NewTabBtn({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final void Function() onTap;

  @override
  State<NewTabBtn> createState() => _NewTabBtnState();
}

class _NewTabBtnState extends State<NewTabBtn> {
  var _opacity = 0.1;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (h) => setState(() => _opacity = h ? 0.3 : 0.1),
      child: Container(
        padding: const EdgeInsets.all(2.0),
        color: Colors.blue.withOpacity(_opacity),
        child: const Icon(
          Icons.add,
          size: 22,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ColorBox extends StatefulWidget {
  const ColorBox({Key? key, this.child}) : super(key: key);

  final Widget? child;

  @override
  _ColorBoxState createState() => _ColorBoxState();
}

class _ColorBoxState extends State<ColorBox> {
  Color? _color;

  _randomColor() => Color(0xFF000000 + Random().nextInt(0x00FFFFFF));

  @override
  void initState() {
    _color = _randomColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _color = _randomColor();
        });
      },
      child: Container(width: 150, height: 150, color: _color, child: widget.child),
    );
  }
}

final buttonColors = WindowButtonColors(
  iconNormal: Colors.blue,
  mouseOver: Colors.blue.withOpacity(0.2),
  mouseDown: Colors.blue,
);

final closeButtonColors = WindowButtonColors(
  mouseOver: Colors.red.withOpacity(0.9),
  mouseDown: Colors.red,
  iconNormal: Colors.blue,
);

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
