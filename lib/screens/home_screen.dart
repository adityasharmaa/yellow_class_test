import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../helpers/firebase_auth.dart';
import '../widgets/camera_widget.dart';
import '../widgets/video_overlay.dart';

import 'authenticate_screen.dart';

class HomeScreen extends StatefulWidget {
  static final route = "/home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  VideoPlayerController _controller;
  bool _isPortrait         = true;  //controls orientation of video
  bool _showOverlay        = false; //controls whether to show VideoOverlay
  bool _isPlaying          = false; //controls play and pause of video
  double _leftCamera       = 20;    //left coordinate of camera widget
  double _topCamera        = 0;     //top coordinate of camera widget
  Widget _cameraWidget;             //holds camera widget value

  //when dragging of camera widget ends new coordinates of camera widget must be updated
  void _updateCameraPositions(Offset offset) {
    var size = MediaQuery.of(context).size;
    _leftCamera = offset.dx;
    _topCamera = offset.dy;
    if (_leftCamera < 20) _leftCamera = 20;
    if (_leftCamera > size.longestSide - size.shortestSide / 2 - 20)
      _leftCamera = size.longestSide - size.shortestSide / 2 - 20;
    if (_topCamera < 0) _topCamera = 0;
    if (_topCamera > size.shortestSide - size.shortestSide / 2 - 20)
      _topCamera = size.shortestSide - size.shortestSide / 2 - 20;
    setState(() {});
  }

  Positioned get _videoPlayer {
    return Positioned.fill(
      child: InkWell(
          child: AspectRatio(
            aspectRatio:
                _controller != null ? _controller.value.aspectRatio : 1,
            child: _controller != null
                ? VideoPlayer(
                    _controller,
                  )
                : Center(
                    child: Text(
                      "Press play to start video",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),
          onTap: _controller != null ? _toggleOverlay : null,
          onDoubleTap: () {
            if (_controller == null) return;
            if (_isPlaying) {
              _controller.pause();
              _isPlaying = false;
            } else {
              _controller.play();
              _isPlaying = true;
            }
          }),
    );
  }

  Positioned get _draggableCameraWidget {
    return Positioned(
      left: _leftCamera,
      top: _topCamera,
      child: Draggable(
        childWhenDragging: SizedBox(),
        feedback: _cameraWidget,
        child: _cameraWidget,
        onDragEnd: (data) {
          _updateCameraPositions(data.offset);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    //when video is played in landscape mode camera widget is initialized
    if (!_isPortrait)
      _cameraWidget = Transform.rotate(
        angle: -math.pi / 2,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: CameraWidget(),
          elevation: 5,
        ),
      );

    return Scaffold(
      //appbar is shown only in portrait mode
      appBar: _isPortrait
          ? AppBar(
              title: Text("Home"),
              elevation: 1,
              actions: [
                IconButton(
                  icon: Icon(Icons.power_settings_new),
                  onPressed: () async {
                    await Auth().signOut();
                    Navigator.of(context)
                        .pushReplacementNamed(Authenticate.route);
                  },
                ),
              ],
            )
          : null,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Container(
              width: size.width,
              height: _isPortrait ? size.height / 3 : size.shortestSide,
              color: Colors.black,
              child: Stack(
                children: [

                  _videoPlayer,

                  if (_showOverlay)
                    VideoOverlay(
                      _controller,
                      _isPortrait,
                      _toggleOverlay,
                      _toggleOrientation,
                    ),

                  if (!_isPortrait)
                    _draggableCameraWidget,
                ],
              ),
            ),

            if (_isPortrait) SizedBox(height: 50),

            // START button is shown in portrait mode to start playing video
            if (_isPortrait)
              FlatButton(
                child: Text(
                  "START",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
                onPressed: () {
                  _controller =
                      VideoPlayerController.asset("assets/videos/song.mp4")
                        ..initialize().then((_) {
                          setState(() {
                            _isPlaying = true;
                          });
                          _controller.play();
                        });
                },
              ),

            if (_isPortrait) SizedBox(height: 50),

            if (_isPortrait)
              Text("Swith to landscape mode to\nSTART CAMERA FEED after starting video."),
          ],
        ),
      ),
    );
  }

  //video controller is disposed to avoid memory leakage
  @override
  void dispose() {
    super.dispose();
    if (_controller != null) _controller.dispose();
  }

  //toggles visibility of VideoOverlay layer which controls video
  void _toggleOverlay() {
    setState(() {
      _showOverlay = !_showOverlay;
    });
  }

  //toggles orientation of video
  void _toggleOrientation() {
    SystemChrome.setPreferredOrientations([
      _isPortrait
          ? DeviceOrientation.landscapeLeft
          : DeviceOrientation.portraitUp,
    ]);
    setState(() {
      _isPortrait = !_isPortrait;
    });
  }
}
