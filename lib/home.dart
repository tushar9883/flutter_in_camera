import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<CameraDescription> cameras;
  CameraController? cameraController;
  int direction = 0;

  @override
  void initState() {
    startCamera(direction);
    super.initState();
  }

  void startCamera(direction) async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras[direction],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await cameraController?.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((e) {
      print("Error $e");
    });
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController?.value.isInitialized == true) {
      return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              CameraPreview(cameraController!),
              GestureDetector(
                onTap: () {
                  setState(() {
                    direction = direction == 0 ? 1 : 0;
                    startCamera(direction);
                  });
                },
                child: buttonWidget(
                  Icons.flip_camera_ios_outlined,
                  Alignment.bottomLeft,
                ),
              ),
              GestureDetector(
                onTap: () {
                  cameraController?.takePicture().then((XFile? file) {
                    if (mounted) {
                      if (file != null) {
                        print("save picture ${file.path}");
                      }
                    }
                  });
                },
                child: buttonWidget(
                  Icons.camera,
                  Alignment.bottomCenter,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget buttonWidget(IconData icon, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 20,
        ),
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
