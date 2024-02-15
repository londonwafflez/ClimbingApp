import 'dart:io';
import 'package:climbingapp/analyzing_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  File? image;

  Future pickImage(ImageSource source) async{ //function that deals with selecting an image
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage ==null) return;
    final imageTemporary = File(pickedImage.path);
    setState(() {
      image = imageTemporary;
      if (image!=null){
        Navigator.push( //switch screens
          context,
          MaterialPageRoute(builder: (context)=> AnalyzingScreen(
            img: image!
            )
          )
        );
      }
    });
    
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     home: Scaffold(
        appBar: AppBar(backgroundColor: Colors.black87, title: const Text("Climb Sorter (or something idk lol)")),
        body: Column(
          children: [
            FloatingActionButton.extended(onPressed: (){ //"From Gallery" button
              pickImage(ImageSource.gallery);
            }, 
            label: const Text("From Gallery"), 
            icon: const Icon(Icons.photo_album_rounded)
            ),
             
            FloatingActionButton.extended(onPressed: (){ //"From Camera" button
              pickImage(ImageSource.camera); // call pickimage method to get image from gallery
            }, label: const Text("From Camera"), 
            icon: const Icon(Icons.camera_alt_rounded)
            ),
          ]
        )
     ),
      );
  }
}