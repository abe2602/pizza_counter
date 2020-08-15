import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PizzaChartsPage extends StatelessWidget {
  static Widget create(BuildContext context) => PizzaChartsPage();

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: SafeArea(
          child: Text('Soy un grafico de pizza!'),
        ),
      );
}
