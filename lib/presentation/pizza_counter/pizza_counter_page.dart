import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pizza_counter/presentation/common/adaptative_scaffold.dart';

class PizzaCounterPage extends StatelessWidget {
  static Widget create(BuildContext context) => PizzaCounterPage();

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: SafeArea(
          child: Text('Soy una pizza!'),
        ),
      );
}
