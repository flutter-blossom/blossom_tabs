Tabs manager for [flutter-blossom](https://github.com/flutter-blossom/) project.

## Features

![](https://github.com/flutter-blossom/blossom_tabs/blob/master/assets/example.png)

 - You can drag and drop tabs and reorder them.
 - dynamically add tabs at runtime.
 - save the current state of tab manger for later use (i.e- at next app restart).
 - customize appearance and behavior.

## Getting started

first add it to your project

```bash
flutter pub add blossom_tabs

```
then import it

```dart
import 'package:blossom_tabs/blossom_tabs.dart';
```

## Usage

You can add in widget tree like this - 

```dart
// configure `controller`
var _controller = BlossomTabController<int>(tabs: []); // infer data type for easy access

return BlossomTabControllerScope(
  controller: _controller,
  child: Scaffold(
    appBar: BlossomTabBar<int>(
      height: 48,
      selectedColor: Colors.blue,
      stickyColor: Colors.white,
      backgroundColor: Colors.blue.withOpacity(0.3),
      dividerColor: Colors.blue,
    ),
    body: BlossomTabView<int>(
      builder: (context, data) {
        return Center(
            child: Text(
          data.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ));
      },
    ),
  ),
);
```

## Additional information

Additionally you can listen to tabs state changes using `BlossomTabControllerScopeDescendant`. like this -

```dart
BlossomTabControllerScopeDescendant<int>(
  builder: (context, controller) {
  return Container(
    color: controller.currentTab == 'd' ? Colors.white : Colors.blue,
  );
});
```
