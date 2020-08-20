import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pizza_counter/generated/l10n.dart';

class PizzaChartsPage extends StatelessWidget {
  static Widget create(BuildContext context) => PizzaChartsPage();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).pizzaChartsTabLabel,
            maxLines: 1,
          ),
        ),
        body: NoUsersEmptyState(),
//        Stack(
//          children: [
//            Container(
//              transform: Matrix4.translationValues(
//                  0, -MediaQuery.of(context).size.height / 3.5, 0),
//              color: Colors.red,
//              alignment: Alignment.topCenter,
//              child: const AnimationBody(
//                animationFile: 'images/PodiumAnimation.flr',
//                animationName: 'PodiumAnimation',
//              ),
//            ),
//            Positioned(
//              top: MediaQuery.of(context).size.height / 5,
//              child: Column(
//                children: [
//                  Text('Bruno'),
//                  Text('Bacelar'),
//                  Text('Ane'),
//                ],
//              ),
//            ),
//          ],
//        ),
      );
}

class AnimationBody extends StatefulWidget {
  const AnimationBody({
    @required this.animationFile,
    @required this.animationName,
  })  : assert(animationFile != null),
        assert(animationFile != null);
  final String animationName;
  final String animationFile;

  @override
  _AnimationBodyState createState() => _AnimationBodyState();
}

class _AnimationBodyState extends State<AnimationBody> with FlareController {
  final _rockAmount = 0.5;
  final double _speed = 2;
  double _rockTime = 0;

  ActorAnimation _rock;

  @override
  void initialize(FlutterActorArtboard artboard) {
    _rock = artboard.getAnimation(widget.animationName);
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    _rockTime += elapsed * _speed;
    _rock.apply(_rockTime % _rock.duration, artboard, _rockAmount);
    return true;
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          child: FlareActor(widget.animationFile,
              alignment: Alignment.center,
              isPaused: false,
              fit: BoxFit.cover,
              animation: widget.animationName,
              controller: this),
        ),
      );
}

class NoUsersEmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text('Na vida todos somos campeões, comece a comer!'),
      Image.asset('images/podium.png'),
    ],
  );

}
