import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraApp extends StatefulWidget {
  /// A Camera Widget that can be reused for different components
  ///
  /// To add more features for a component, inherit and override this class
  @override
  CameraAppState createState() => CameraAppState();
}

class CameraAppState extends State<CameraApp> with WidgetsBindingObserver {
  CameraController _controller;
  Future<void> initController;
  var isCameraReady = false;

  @override
  void initState() {
    super.initState();
    this.initCamera();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed)
      initController = _controller != null ? _controller.initialize() : null;
    if (!mounted) return;
    setState(() {
      isCameraReady = true;
    });
  }

  Widget cameraWidget(context) {
    var camera = _controller.value;
    final size = MediaQuery.of(context).size;

    /// scale to fit the device size
    var scale = size.width /
        (size.height + MediaQuery.of(context).padding.top) *
        camera.aspectRatio;
    if (scale < 1) scale = 1 / scale;
    return Align(
        alignment: Alignment.center,
        child: Transform.scale(
          scale: scale,
          child: CameraPreview(_controller),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initController,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return cameraWidget(context);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future<void> initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    // get the back camera
    final firstCamera = cameras.first;
    _controller = CameraController(firstCamera, ResolutionPreset.high);
    initController = _controller.initialize().then((value) {
      if (!mounted) return;
      setState(() {
        try {
          _controller.setFlashMode(FlashMode.off);
        } catch (e) {
          print(e);
        }
        isCameraReady = true;
      });
    });
  }

  Future<String> captureImage() async {
    /// Capture an image and return its stored path
    XFile file = await _controller.takePicture();
    return file.path;
  }
}
