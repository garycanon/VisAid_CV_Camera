import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController {

  @override
  void onInit(){

    super.onInit();
    initCamera();
    initTfLite();
  }

  @override
  void dispose(){

    super.dispose();
    cameraController.dispose();
  }
  
  late CameraController cameraController;
  late List<CameraDescription> cameras;

  var isCameraInit = false.obs;
  var cameraCount = 0;

  dynamic x, y, w, h = 0.0;
  dynamic label = "";

  initCamera() async{

    if(await Permission.camera.request().isGranted){

      cameras = await availableCameras();

      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.max,
        //imageFormatGroup:       
      );
      
      await cameraController.initialize().then((value){

        cameraController.startImageStream((image){
          cameraCount++;
          if(cameraCount % 10 == 0){
          objectDetector(image);

          }
          update();
        });
        
      });
      isCameraInit(true);

      update();
    }

    else{
      log("Permission denied");
    }
  }

  initTfLite() async {

    await Tflite.loadModel(
      //model: "assets/test.tflite",
      //labels: "assets/test.txt",
      model: "assets/mymodel.tflite",
      labels: "asset/mylabel.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false

      );
  }

  objectDetector(CameraImage image) async {
  var detector = await Tflite.runModelOnFrame(
    bytesList: image.planes.map((plane) {
      return plane.bytes;
    }).toList(),
    imageHeight: image.height,
    imageWidth: image.width,
    imageMean: 127.5,
    imageStd: 127.5,
    rotation: 90,
    numResults: 1,
    threshold: 0.4,
    asynch: true,
  );

  if (detector != null && detector.isNotEmpty) {
    var detectedObj = detector.first;
    var confidence = detectedObj['confidenceInClass'];

    if (confidence != null && confidence * 100 > 45) {
      label = detectedObj['detectedClass'].toString();
      h = detectedObj['rect']['h'];
      w = detectedObj['rect']['w'];
      x = detectedObj['rect']['x'];
      y = detectedObj['rect']['y'];
    } else {
      // Object detection confidence is below threshold
      label = "No object detected";
      h = w = x = y = 0;
    }
  } else {
    // No objects detected
    label = "No object detected";
    h = w = x = y = 0;
  }

  update();
}
}