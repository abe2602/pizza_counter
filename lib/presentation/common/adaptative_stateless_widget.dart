import 'dart:io';

import 'package:flutter/widgets.dart';

abstract class AdaptiveStatelessWidget extends StatelessWidget {
  const AdaptiveStatelessWidget({
    Key key,
  }) : super(key: key);

  Widget buildCupertinoWidget(BuildContext context);

  Widget buildMaterialWidget(BuildContext context);

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? buildCupertinoWidget(context)
      : buildMaterialWidget(context);
}
