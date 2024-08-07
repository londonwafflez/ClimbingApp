import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cyclop/cyclop.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';

class AnalyzingScreen extends StatefulWidget {
  final File imge;

  const AnalyzingScreen({
    super.key,
    required this.imge,
  });

  @override
  State<AnalyzingScreen> createState() => AnalyzingScreenState();
}

class AnalyzingScreenState extends State<AnalyzingScreen> {
  Color backgroundColor = Colors.grey.shade200;

  Set<Color> swatches = Colors.primaries.map((e) => Color(e.value)).toSet();

  final ValueNotifier<Color?> hoveredColor = ValueNotifier<Color?>(null);

  late img.Image image;
  late img.Image maskedImage;

  @override
  void initState() {
    super.initState();
    image = img.decodeImage(File(widget.imge.path).readAsBytesSync())!;
    maskedImage = img.copyResize(image, width: image.width, height: image.height);
  }

  Future<img.Image> createMask(img.Image image, Color clr) async { //reduce lag? idk chatgpt told me to
    return compute(_createMask, [image, clr]);
  }

  Future<img.Image> applyMask(img.Image image, img.Image mask) async { // reduce lag? idk chatgpt told me to
    return compute(_applyMask, [image, mask]);
  }

  static img.Image _createMask(List<dynamic> args) { //create the mask for the image
    img.Image image = args[0]; // honestly i have no clue what chatgpt did with the parameters
    Color clr = args[1];
    img.Image mask = img.copyResize(image, width: image.width, height: image.height); //ensure the mask is the same size as the image
    //mask = img.gaussianBlur(mask, radius: 3); //apply a blur
    for (int y = 0; y < mask.height; y++) { //iterate through every pixel in the image
      for (int x = 0; x < mask.width; x++) {
        final pixelColor = Color.fromARGB( //get the color of the pixel
          255,
          mask.getPixel(x, y).r.toInt(),
          mask.getPixel(x, y).g.toInt(),
          mask.getPixel(x, y).b.toInt(),
        );
        if (_isColorSimilar(pixelColor, clr)) { //if the colors are different, set the pixel of the mask to black
          mask.setPixel(x, y, img.ColorRgb8(255, 255, 255));
        } else {
          mask.setPixel(x, y, img.ColorRgb8(0, 0, 0)); //if the colors are the same, set the pixel of the mask to white
        }
      }
    }
    return mask;
  }

  static bool _isColorSimilar(Color a, Color b, {int tolerance = 10}) {
    return (a.red - b.red).abs() <= tolerance &&
           (a.green - b.green).abs() <= tolerance &&
           (a.blue - b.blue).abs() <= tolerance;
  }

  static img.Image _applyMask(List<dynamic> args) { //PROBLEM HERE
    img.Image image = args[0];
    img.Image mask = args[1];

    img.Image result = img.copyResize(image, width: image.width, height: image.height);
    for (int y = 0; y < result.height; y++) {
      for (int x = 0; x < result.width; x++) {
        final pixelValue = mask.getPixel(x, y);
        if (pixelValue.r == 0 && pixelValue.g == 0 && pixelValue.b == 0) {
          result.setPixelRgba(x, y, 255, 255, 255, 0);
        }
        
      }
    }
    return result;
  }

  void onColorSelected(Color value) async {
    img.Image mask = await createMask(image, value);
    img.Image newMaskedImage = await applyMask(image, mask);
    setState(() {
      maskedImage = newMaskedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final bodyTextColor =
        ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark
            ? Colors.white70
            : Colors.black87;

    return EyeDrop(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Container(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Column(
              children: [
                Text(
                  'Select the background & appbar colors',
                  style: textTheme.titleLarge?.copyWith(color: bodyTextColor),
                ),
                Stack(
                  children: [
                    // Original image
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * .8,
                      width: MediaQuery.sizeOf(context).width * 1,
                      child: Image.file(widget.imge),
                    ),
                    // Masked image
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * .75,
                      width: MediaQuery.sizeOf(context).width * 1,
                      child: Image.memory(img.encodePng(maskedImage)),
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          EyedropperButton(
                            onColor: (value) => onColorSelected(value),
                            onColorChanged: (value) => hoveredColor.value = value,
                          ),
                          ValueListenableBuilder<Color?>(
                            valueListenable: hoveredColor,
                            builder: (context, value, _) => Container(
                              color: value ?? Colors.transparent,
                              width: 24,
                              height: 24,
                            ),
                          ),
                          FloatingActionButton.extended(
                              onPressed: () { //"From Gallery" button
                                Navigator.pop(context);
                              },
                              label: const Text("Back"),
                              icon: const Icon(Icons.arrow_back)
                          ), // Insert button for resetting color
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
