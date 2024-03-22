import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

void main() => runApp(const ConfettiSample());

class ConfettiSample extends StatelessWidget {
  const ConfettiSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Confetti',
        home: Scaffold(
          backgroundColor: Colors.grey[900],
          body: MyApp(),
        ));
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ConfettiController _controllerCenterLeft;
  List<ui.Image> images = [];
  List<String> imageUrls = [
    'https://storage.googleapis.com/cahoapp/d3273e51-c79a-433b-88cf-72a5017eec0a-1709534449870-ClownEmoji.png',
    'https://storage.googleapis.com/cahoapp/438050b7-68d4-48d0-8bdf-b1434cf0faec-1709534450997-HeartEmoji.png',
    'https://storage.googleapis.com/cahoapp/27095fd7-afb2-4fc0-b725-c571a0a4a3bd-1709534451495-NerdEmoji.png',
    'https://storage.googleapis.com/cahoapp/c694f220-fb59-421d-a50c-1002fc263325-1709534452017-PoopEmoji.png',
    'https://storage.googleapis.com/cahoapp/2b54d077-1c81-43d1-b2e9-46f7d04d33fe-1709534452522-PopcornEmoji.png',
  ];

  @override
  void initState() {
    super.initState();
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 1));
    _loadAllImages();
  }

  // void _loadImage() async {
  //   final image = await NetworkImage();
  //convert image to ui.Image
  // }

  // void _loadImage() async {
  //   final imageUrl =
  //       'https://storage.googleapis.com/cahoapp/27095fd7-afb2-4fc0-b725-c571a0a4a3bd-1709534451495-NerdEmoji.png';
  //   final response = await http.get(Uri.parse(imageUrl));
  //   final bytes = response.bodyBytes;
  //   final completer = Completer<ui.Image>();
  //   ui.decodeImageFromList(bytes, completer.complete);
  //   final image = await completer.future;
  //   setState(() {
  //     confettiImage = image;
  //   });
  // }

  void _loadAllImages() async {
    for (var imageUrl in imageUrls) {
      final response = await http.get(Uri.parse(imageUrl));
      final bytes = response.bodyBytes;
      final completer = Completer<ui.Image>();
      ui.decodeImageFromList(bytes, completer.complete);
      final image = await completer.future;
      images.add(image);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controllerCenterLeft.dispose();
    super.dispose();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          if (images.isNotEmpty)
            Align(
              alignment: Alignment.bottomLeft,
              child: ConfettiWidget(
                //  confettiImage: Image.network(
                //   "https://storage.googleapis.com/cahoapp/27095fd7-afb2-4fc0-b725-c571a0a4a3bd-1709534451495-NerdEmoji.png")
                // ,
                confettiImages: images!,
                confettiController: _controllerCenterLeft,
                blastDirection: -pi / 4, // radial value - RIGHT
                emissionFrequency: 0.6,
                blastDirectionality: BlastDirectionality.explosive,
                gravity: 0.1,
                numberOfParticles: 10,
                minBlastForce: 20,
                maxBlastForce: 40,
              ),
            ),
          Align(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton(
              onPressed: () {
                _controllerCenterLeft.play();
              },
              child: const Text('play'),
            ),
          )
        ],
      ),
    );
  }
}
