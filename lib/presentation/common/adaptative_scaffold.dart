import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pizza_counter/presentation/common/adaptative_bar_action.dart';
import 'package:pizza_counter/presentation/common/adaptative_stateless_widget.dart';

class AdaptiveScaffold extends AdaptiveStatelessWidget {
  const AdaptiveScaffold({
    @required this.body,
    Key key,
    this.title,
    this.action,
    this.backgroundColor,
  })  : assert(body != null),
        super(key: key);

  final String title;
  final AdaptiveAppBarAction action;
  final Widget body;
  final Color backgroundColor;

  @override
  Widget buildCupertinoWidget(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            title,
            maxLines: 1,
          ),
          trailing: action,
        ),
        backgroundColor: backgroundColor,
        child: SafeArea(child: body),
      );

  @override
  Widget buildMaterialWidget(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            maxLines: 1,
          ),
          actions: action != null ? <Widget>[action] : null,
        ),
        body: body,
        backgroundColor: backgroundColor,
      );
}
