import 'dart:io';
import 'package:flutter/material.dart';

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
    return  MaterialApp(
      home: Scaffold(
        body: Column(
          children:[
            Image.file(widget.img),
          ]
          
        )
      )
    );
  }
}