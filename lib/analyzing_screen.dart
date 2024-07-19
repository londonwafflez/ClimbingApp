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
  State<AnalyzingScreen> createState() => AnalyzingScreenState();
}

class AnalyzingScreenState extends State<AnalyzingScreen> {
  Color appbarColor = Colors.blueGrey;

  Color backgroundColor = Colors.grey.shade200;

  Set<Color> swatches = Colors.primaries.map((e) => Color(e.value)).toSet();

  final ValueNotifier<Color?> hoveredColor = ValueNotifier<Color?>(null);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final bodyTextColor =
    ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark
        ? Colors.white70
        : Colors.black87;

    final appbarTextColor =
    ThemeData.estimateBrightnessForColor(appbarColor) == Brightness.dark
        ? Colors.white70
        : Colors.black87;

    Color color;

    return EyeDrop(child:
        Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text('Climb Filter',
              style: textTheme.titleLarge?.copyWith(color: appbarTextColor)),
          backgroundColor: appbarColor,
        ),
        body: Container(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Column(
              children: [
                Text(
                  'Select the background & appbar colors',
                  style: textTheme.titleLarge?.copyWith(color: bodyTextColor),
                ),
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    backgroundColor,
                    BlendMode.modulate,
                  ),
                  child: Image.file(widget.img),
                ),
                // Center(child: Image.file(widget.img)),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          EyedropperButton(
                            onColor: (value) =>
                                setState(() => backgroundColor = value),
                            onColorChanged: (value) => hoveredColor.value = value,
                          ),
                          ValueListenableBuilder<Color?>(
                            valueListenable: hoveredColor,
                            builder: (context, value, _) => Container(
                              color: value ?? Colors.transparent,
                              width: 24,
                              height: 24,
                            ),
                          )
                          // Insert button for resetting color
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}