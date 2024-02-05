import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visaid_cv_gui/controller/scanner.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: GetBuilder<ScanController>(
    
        init: ScanController(),
        builder: (controller){

          return controller.isCameraInit.value 
          ? CameraPreview(controller.cameraController)
          : const Center(child: Text("Loading Camera..."));

        },)
    );
  }
}