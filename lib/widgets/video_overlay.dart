import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:video_player/video_player.dart';

// Video Overlay is a widget shown on top of video player and controls duration, orientation and volume of video
class VideoOverlay extends StatefulWidget {
  final void Function() _toggleOrientation;
  final VideoPlayerController _controller;
  final void Function() _toggleOverlayVisibility;
  final bool _isPortrait;

  VideoOverlay(
    this._controller,
    this._isPortrait,
    this._toggleOverlayVisibility,
    this._toggleOrientation,
  );

  @override
  _VideoOverlayState createState() => _VideoOverlayState();
}

class _VideoOverlayState extends State<VideoOverlay> {
  double _duration;
  double _volume;

  void _controllerListener() {
    setState(() {
      _duration = widget._controller.value.position.inSeconds.toDouble();
    });
  }

  @override
  void initState() {
    super.initState();
    _duration = widget._controller.value.position.inSeconds.toDouble();
    widget._controller.addListener(_controllerListener);
    _volume = widget._controller.value.volume;
  }

  @override
  void deactivate() {
    super.deactivate();
    if (widget._controller != null)
      widget._controller.removeListener(_controllerListener);
  }

  // method to convert duration to user understandable format like 124 seconds = 2:04
  String _durationToShow(Duration duration) {
    int totalSeconds = duration.inSeconds;
    int hoursToShow = totalSeconds ~/ 3600;
    int minutesToShow = (totalSeconds % 3600) ~/ 60;
    int secondsToShow = (totalSeconds % 3600) % 60;
    String h = hoursToShow == 0
        ? ""
        : hoursToShow <= 9
            ? "0" + hoursToShow.toString()
            : hoursToShow.toString();
    String m = minutesToShow == 0
        ? hoursToShow > 0
            ? "00"
            : "0"
        : minutesToShow <= 9
            ? "0" + minutesToShow.toString()
            : minutesToShow.toString();
    String s = secondsToShow == 0
        ? "00"
        : secondsToShow <= 9
            ? "0" + secondsToShow.toString()
            : secondsToShow.toString();

    return h.isEmpty ? (m + ":" + s) : (h + ":" + m + ":" + s);
  }

  // Shows total duration, current time and orientation icon
  Positioned _videoDuration(Size size) {
    return Positioned(
      bottom: 0,
      child: SizedBox(
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              width: size.width - 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 5),
                    child: Text(
                      _durationToShow(widget._controller.value.position),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      _durationToShow(widget._controller.value.duration),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              child: Icon(
                widget._isPortrait ? Icons.fullscreen : Icons.fullscreen_exit,
                size: 33,
                color: Colors.white,
              ),
              onTap: widget._toggleOrientation,
            ),
          ],
        ),
      ),
    );
  }

  // Controls duration of video using slider
  Positioned _videoDurationControl(Size size) {
    return Positioned(
      bottom: 10,
      child: SizedBox(
        width: size.width - 30,
        child: FlutterSlider(
          onDragCompleted: (handlerIndex, lowerValue, upperValue) {
            setState(() {
              _duration = lowerValue;
              widget._controller.seekTo(Duration(seconds: lowerValue.floor()));
            });
          },
          values: [_duration],
          min: 0.0,
          max: widget._controller.value.duration.inSeconds.toDouble(),
          handlerWidth: 15,
          handlerHeight: 15,
          trackBar: FlutterSliderTrackBar(
            activeTrackBar: BoxDecoration(
              color: Colors.blue,
            ),
            inactiveTrackBar: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
            ),
          ),
          handler: FlutterSliderHandler(
            child: CircleAvatar(
              radius: 5,
              backgroundColor: Colors.blue,
            ),
          ),
          handlerAnimation: FlutterSliderHandlerAnimation(scale: 1),
        ),
      ),
    );
  }

  // Controls volume of video using a slider
  Positioned _videoVolumeControl(double playerHeight) {
    return Positioned(
      right: 10,
      top: playerHeight * 0.15,
      child: SizedBox(
        height: playerHeight * 0.7,
        child: FlutterSlider(
          values: [_volume * 100],
          min: 0,
          max: 100,
          axis: Axis.vertical,
          handlerWidth: 15,
          handlerHeight: 15,
          onDragging: (handlerIndex, lowerValue, upperValue) {
            setState(() {
              widget._controller.setVolume(lowerValue / 100);
              _volume = lowerValue / 100;
            });
          },
          trackBar: FlutterSliderTrackBar(
            activeTrackBar: BoxDecoration(
              color: Colors.blue,
            ),
            inactiveTrackBar: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
            ),
          ),
          rtl: true,
          handler: FlutterSliderHandler(
            child: CircleAvatar(
              radius: 5,
              backgroundColor: Colors.blue,
            ),
          ),
          handlerAnimation: FlutterSliderHandlerAnimation(scale: 1),
        ),
      ),
    );
  }

  // Controls playing and pausing of video using ICONS click
  Widget _videoPlayControl() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            widget._controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              if (widget._controller.value.isPlaying) {
                widget._controller.pause();
              } else {
                widget._controller.play();
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var playerHeight = widget._isPortrait ? (size.height / 3) : size.height;

    return GestureDetector(
      onTap: widget._toggleOverlayVisibility,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Stack(
          children: <Widget>[

            _videoPlayControl(),

            _videoDuration(size),

            _videoDurationControl(size),
            
            _videoVolumeControl(playerHeight),
          ],
        ),
      ),
    );
  }
}
