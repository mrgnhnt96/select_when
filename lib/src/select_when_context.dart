import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Adds a `selectWhen` method on [BuildContext].
extension SelectWhenContext on BuildContext {
  /// Watches a value of type [T] exposed from a provider and marks this widget for rebuild
  /// based on the result of [selector] applied to the value, conditional on the [when] predicate.
  ///
  /// This function is an extension of [select], allowing additional control by specifying
  /// a [when] condition to determine when [selector] should be invoked and when to use
  /// the previously computed value. If [when] returns `false`, the function retains the
  /// previously computed value from [selector], avoiding unnecessary rebuilds.
  ///
  /// Example:
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   final name = context.selectWhen<Person, String>(
  ///     (person) => person.name,
  ///     when: (person) => !person.isLoading,
  ///   );
  ///
  ///   return Text(name);
  /// }
  /// ```
  ///
  /// This example will update the widget only when the person's `isLoading` property is `false`.
  ///
  /// Similar to [select], this must be used only inside the `build` method of a widget.
  /// It will not work inside other lifecycle methods, such as [State.didChangeDependencies].
  ///
  /// By using [selectWhen], you can optimize rebuilds by controlling when a selector
  /// should compute a new value and when the previous value should be reused.
  ///
  /// When a provider emits an update, it evaluates the [when] predicate synchronously.
  /// If [when] returns `true`, the [selector] function is invoked, and if the result
  /// differs from the previous value, the dependent widget is marked for rebuild.
  /// If [when] returns `false`, the previously computed value from [selector] is retained.
  ///
  /// This pattern is particularly useful for reducing rebuilds when working with
  /// frequently updating providers or when specific conditions must be met before
  /// recomputation.
  ///
  /// For example, given a [Person] class:
  /// ```dart
  /// class Person with ChangeNotifier {
  ///   String name;
  ///   bool isLoading;
  ///
  ///   // Add logic that updates `name` and `isLoading`
  /// }
  /// ```
  ///
  /// A widget can use [selectWhen] to rebuild only when a person's `name` changes
  /// and their `isLoading` property is `false`:
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   final name = context.selectWhen<Person, String>(
  ///     (person) => person.name,
  ///     when: (person) => !person.isLoading,
  ///   );
  ///
  ///   return Text(name);
  /// }
  /// ```
  ///
  /// Like [select], [selectWhen] optimizes performance by preventing unnecessary rebuilds.

  R selectWhen<T, R>(
    R Function(T value) selector, {
    required bool Function(T value) when,
  }) {
    R? previousValue;

    return select((T value) {
      if (!when(value)) return previousValue ??= selector(value);

      return previousValue = selector(value);
    });
  }
}
