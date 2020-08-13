import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pizza_counter/presentation/common/adaptative_stateless_widget.dart';

class AdaptiveAppBarAction extends AdaptiveStatelessWidget {
  const AdaptiveAppBarAction({
    @required this.child,
    Key key,
    this.onPressed,
  })  : assert(child != null),
        super(key: key);

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget buildCupertinoWidget(BuildContext context) => CupertinoButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        child: child,
      );

  @override
  Widget buildMaterialWidget(BuildContext context) => IconButton(
        icon: Icon(Icons.person_add),
        onPressed: onPressed,
      );
}
