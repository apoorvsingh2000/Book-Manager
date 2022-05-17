import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:book_management/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatefulWidget {
  static const String id = 'splash`_screen';

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  bool showSpinner = false;
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SplashScreen(
            useLoader: false,
            seconds: 6,
            navigateAfterSeconds: HomeScreen(),
          ),
          ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Hero(
                        tag: 'logo',
                        child: Container(
                          child: Image.asset('images/logo.png'),
                          height: controller.value * 70,
                        ),
                      ),
                      TypewriterAnimatedTextKit(
                        speed: const Duration(milliseconds: 500),
                        text: const [' Book Manager'],
                        textStyle: const TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
