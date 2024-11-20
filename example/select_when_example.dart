import 'package:flutter/material.dart';
import 'package:select_when/select_when.dart';

class SelectWhenExample extends StatelessWidget {
  const SelectWhenExample({super.key});

  @override
  Widget build(BuildContext context) {
    final name = context.selectWhen(
      (Person person) => person.name,
      when: (Person person) => !person.isLoading,
    );

    return Text(name);
  }
}

class Person with ChangeNotifier {
  String name = 'Skull Kid';

  bool isLoading = false;
}
