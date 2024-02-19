import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visimp_cv/controller/scan.dart';

class CameraView extends StatelessWidget{

  const CameraView({super.key});

  @override
  Widget build(BuildContext context){

    return Scaffold(
      body: GetBuilder<ScanController>(
        init: ScanController(),
        builder: (controller){
          return controller.isCameraInit.value ?
          Stack(
            children: [
              CameraPreview(controller.cameraController),
              Positioned(
                top: controller.y != null ? controller.y * 700 : 0,
                right: controller.x != null ? controller.x * 500 : 0,
                child: Container(
                  width: controller.w != null ? controller.w * 100 * context.width / 100 : 0,
                  height: controller.h != null ? controller.h * 100 * context.height / 100 : 0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green, width: 4.0)
                  ),
                  child:Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        color: Colors.white,
                        child: Text("${controller.label}"),)
                  ],)
                
                ),
              )

            ],
          ) 
          : const Center(child: Text("Loading Preview..."));
        }),
      );
  }
}