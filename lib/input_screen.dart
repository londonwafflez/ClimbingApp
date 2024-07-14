// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:camera/camera.dart';
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
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  @override
  void initState(){
    super.initState();
    _setupCameraController();
  }
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
  Future<void> _setupCameraController() async{ // setup the camera controller (code from https://youtu.be/TrmoRtn5MZA?si=_5XDCKkRsONxJQTu)
    List <CameraDescription> _cameras = await availableCameras(); //see if there are any cameras on the device
    if(_cameras.isNotEmpty){
      setState(() {
        cameras = _cameras;
        cameraController=CameraController(_cameras.last, ResolutionPreset.high);
      });
      cameraController?.initialize().then((_){
        setState(() {});
      });
    }
  }

  Widget _buildUI(){
    if (cameraController == null || cameraController?.value.isInitialized == false){
      return const Center(child: CircularProgressIndicator(),);
    }
    return SafeArea(child: SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          SizedBox( // show the camera feed!
            height: MediaQuery.sizeOf(context).height * 0.80, //resize the feed  to fit on the page
            width: MediaQuery.sizeOf(context).width * 0.80,
            child: CameraPreview(
              cameraController!, //this is the camera preview
            ),
          ),
          Row(children: [
            FloatingActionButton.extended(onPressed: (){ //"From Gallery" button
                pickImage(ImageSource.gallery);
              }, 
              label: const Text("From Gallery"), 
              icon: const Icon(Icons.photo_album_rounded)
            ),

            FloatingActionButton(onPressed: () async{ //"From Camera" button
              XFile picture = await cameraController!.takePicture();
              Navigator.push( //switch screens
                context,
                MaterialPageRoute(builder: (context)=> AnalyzingScreen(
                  img: File(picture.path)
                  )
                )
              );
              },
              child: const Icon(Icons.camera_alt_rounded)
              ),
            ],
          )
        ]
      ),
    ),);
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     home: Scaffold(
        body: _buildUI() // using a function because its easier to edit
     ),
      );
  }
}