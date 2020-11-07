import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraWidget extends StatefulWidget {
  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraController _controller;
  bool _cameraAvailable = true;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  void _initCamera() {
    Future.delayed(Duration(milliseconds: 0), () async {
      var cameras = await availableCameras();

      //front camera is at index 1, so if there is no camera at index 1 it means no front camera is there
      if (cameras.length <= 1) {
        setState(() {
          _cameraAvailable = false;
        });
        return;
      }
      
      _controller = CameraController(cameras[1], ResolutionPreset.medium);
      _controller.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.shortestSide / 2;
    return Container(
      color: Colors.black,
      height: height,
      child: _cameraAvailable
          ? _controller != null
              ? _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: CameraPreview(_controller),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    )
              : Center(
                  child: CircularProgressIndicator(),
                )
          : Center(
              child: Text(
                "No front camera available",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
    );
  }
}
