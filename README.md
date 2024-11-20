# SelectWhenContext Extension for Flutter

`select_when_context` is a Flutter extension that enhances the functionality of the `Provider` package by adding a `selectWhen` method to `BuildContext`. This new method offers greater control over widget rebuilds by allowing you to specify conditions that dictate when a particular selector should be invoked, helping you avoid unnecessary UI updates.

## Features

- **Conditional Rebuilds**: `selectWhen` enables widgets to rebuild only under specific conditions, helping you optimize performance by reducing unnecessary updates.
- **Improved Control**: By specifying a `when` predicate, you can control when the selector should be used to compute a value, preventing unwanted recomputation.
- **Similar API to `select`**: The extension builds on the familiar `select` method from the `Provider` package, making it easy to integrate into your existing codebase.

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  select_when_context: ^1.0.0
```

Then run:

```sh
flutter pub get
```

## Usage

The `selectWhen` extension adds a method to `BuildContext` that allows for efficient state management in your widgets. It is particularly useful for widgets that rely on frequently updating values but only need to rebuild under certain conditions.

### Example

Suppose you have a `Person` model with a `name` and an `isLoading` flag:

```dart
class Person with ChangeNotifier {
  String name;
  bool isLoading;

  Person({required this.name, this.isLoading = false});

  // Add logic to update `name` and `isLoading`
}
```

You can use `selectWhen` in the `build` method of a widget to rebuild it only when the `name` changes and `isLoading` is `false`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:select_when_context/select_when_context.dart';

class PersonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = context.selectWhen<Person, String>(
      (person) => person.name,
      when: (person) => !person.isLoading,
    );

    return Text(name);
  }
}
```

In this example, the widget rebuilds only if the `Person`'s `name` changes **and** `isLoading` is `false`. This provides an efficient way to control when a widget should update, reducing unnecessary rebuilds.

### Key Benefits

- **Performance Optimization**: By controlling when the selector function is executed, you can prevent excessive and unnecessary widget rebuilds.
- **Easier State Management**: `selectWhen` is intuitive to use, similar to the standard `select` method, but with added flexibility via conditional rebuilds.

## API Reference

### `selectWhen<T, R>`

`selectWhen` is an extension method on `BuildContext`:

```dart
R selectWhen<T, R>(
  R Function(T value) selector, {
  required bool Function(T value) when,
})
```

- **selector**: A function that extracts a value of type `R` from the provider of type `T`.
- **when**: A predicate function that returns `true` or `false` depending on whether the selector should be invoked.

### Important Notes

- **Use Only in `build` Method**: `selectWhen` should only be used inside the `build` method of a widget. It will not work in other lifecycle methods like `State.didChangeDependencies`.
- **Efficient Predicate Evaluation**: The `when` predicate is evaluated synchronously when a provider emits an update. If it returns `true`, the `selector` is invoked and the result is compared to the previous value to determine if a rebuild is needed.

### Full Example

Consider the following scenario for efficient widget updates:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:select_when_context/select_when_context.dart';

class Person with ChangeNotifier {
  String name;
  bool isLoading;

  Person({required this.name, this.isLoading = false});

  void updateName(String newName) {
    name = newName;
    notifyListeners();
  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }
}

class ExampleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = context.selectWhen<Person, String>(
      (person) => person.name,
      when: (person) => !person.isLoading,
    );

    return Text(name);
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Person(name: 'John Doe'),
      child: MaterialApp(
        home: Scaffold(
          body: ExampleWidget(),
        ),
      ),
    ),
  );
}
```

## Contributions

Contributions are welcome! If you encounter any bugs or have feature requests, please open an issue or submit a pull request on the [GitHub repository](https://github.com/your-username/select_when_context).

## License

This project is licensed under the MIT License. See the LICENSE file for more details.

---

### Additional Resources

- [Provider Package Documentation](https://pub.dev/packages/provider)
- [Flutter Official Documentation](https://flutter.dev/docs)

With `selectWhen`, you can gain fine-grained control over your widgets' rebuild logic, leading to better app performance and more responsive UIs. Give it a try and see how it can optimize your Flutter applications!
