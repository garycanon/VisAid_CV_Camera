import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController{

  @override
  void onInit() {
    initCamera();
    super.onInit();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
  
  late CameraController cameraController;
  late List<CameraDescription> cameras;

  var isCameraInit = false.obs;

  initCamera() async{

    if(await Permission.camera.request().isGranted){

      cameras = await availableCameras();

      cameraController = CameraController(
        cameras[0], //rear = 0 front = 1
        ResolutionPreset.max,
      );

      await cameraController.initialize();
      isCameraInit(true);
      update();
    }

    else{

      print("Permission denied! Closing app now.");
    }

  }
}