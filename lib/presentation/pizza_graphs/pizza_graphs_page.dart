import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pizza_counter/presentation/common/adaptative_scaffold.dart';

class PizzaGraphsPage extends StatelessWidget {
  static Widget create(BuildContext context) => PizzaGraphsPage();

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: SafeArea(
          child: Text('Soy un grafico de pizza!'),
        ),
      );
}
