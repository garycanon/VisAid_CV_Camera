import 'package:flutter/material.dart';
import 'package:visaid_cv_gui/views/camera_viewer.dart';

void main(){
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {

  const MainApp({super.key});

  @override
  Widget build(BuildContext context){

    return MaterialApp(
      title: 'Image Processor',
      theme: ThemeData(
        
          primarySwatch: Colors.amber,
      ),

      home: const CameraView(),
    );
  }
}