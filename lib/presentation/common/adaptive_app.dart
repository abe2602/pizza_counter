import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pizza_counter/presentation/common/adaptative_stateless_widget.dart';

class AdaptiveApp extends AdaptiveStatelessWidget {
  const AdaptiveApp({
    @required this.onGenerateTitle,
    @required this.primaryColor,
    this.localizationsDelegates,
    this.supportedLocales,
    Key key,
  })  :
        assert(onGenerateTitle != null),
        assert(primaryColor != null),
        super(key: key);

  final GenerateAppTitle onGenerateTitle;
  final Color primaryColor;
  final Iterable<Locale> supportedLocales;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;

  @override
  Widget buildCupertinoWidget(BuildContext context) => CupertinoApp(
        onGenerateTitle: onGenerateTitle,
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(primaryColor: primaryColor),
        onGenerateRoute: Provider.of<RouteFactory>(context, listen: false),
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
      );

  @override
  Widget buildMaterialWidget(BuildContext context) => MaterialApp(
        onGenerateTitle: onGenerateTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: primaryColor),
        onGenerateRoute: Provider.of<RouteFactory>(context, listen: false),
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
      );
}
