import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MainApp(camera: firstCamera));
}

class MainApp extends StatelessWidget {
  final CameraDescription camera;

  const MainApp({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraScreen(camera: camera),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late FlutterTts flutterTts;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

    flutterTts = FlutterTts();
    _speakText("Camera Start");
  }

  @override
  void dispose() {
    _controller.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('VisAid CV App')),
      body: Center(
        child: CameraPreview(_controller),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About Us',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // Open camera
            _openCamera();
          } else if (index == 1) {
            // Open about us page
            _openAboutUsPage(context);
          }
        },
      ),
    );
  }

  void _openAboutUsPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AboutUsPage(),
      ),
    );
  }

  void _openCamera() {
    _speakText("Camera open");
    // TODO: Implement camera opening logic here
  }

  Future<void> _speakText(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.speak(text);
  }
}

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: Center(
        child: Text(
          'VisAid_CV App\n\nDeveloped by:\n\nCANON\n\nPABABERO\n\nPASTRANA\n\nFor research and development only.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
