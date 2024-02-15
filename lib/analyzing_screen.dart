import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cyclop/cyclop.dart';

class AnalyzingScreen extends StatefulWidget {
  final File img;
  const AnalyzingScreen({
    super.key,
    required this.img
  });
  
  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Column(
                children: [
                  Image.file(widget.img),

                  FloatingActionButton.extended(
                      onPressed: () { //"From Gallery" button
                        Navigator.pop(context);
                      },
                      label: const Text("Back"),
                      icon: const Icon(Icons.arrow_back)
                  ),
                ]

            )
        )
    );
    /*@override
  Widget build(BuildContext context) {
    Color backgroundColor = const Color.fromRGBO(66, 165, 245, 1.0);
    Color color1 = const Color.fromRGBO(245, 100, 100, 1.0);
    var swatches = const Color.fromRGBO(245, 100, 100, 1.0);
    return EyeDrop(
      child: Builder(
        builder: (context) =>
            Scaffold(
              backgroundColor: backgroundColor,
              body: Container(
                child: ColorButton(
                  key: Key('c1'),
                  color: color1,
                  config: ColorPickerConfig(),
                  size: 32,
                  elevation: 5,
                  boxShape: BoxShape.rectangle,
                  // default : circle
                  swatches: swatches,
                  onColorChanged: (value) => setState(() => color1 = value),
                ),
              ),
            ),
      ),
    );
  }*/
  }
}