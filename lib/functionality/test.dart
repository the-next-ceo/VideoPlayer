// ignore_for_file: must_be_immutable, prefer_const_constructors, unnecessary_null_comparison, use_key_in_widget_constructors

import 'dart:io';
import 'dart:ui';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:vid_player/resources/chewie_plyr_layout.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  //String videoURL;

  // VideoWidget({required this.videoURL});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  late Chewie _chewie;
  late ChewieController _chewieController;
  String videoURL =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';
  File file = File('');

  //_VideoWidgetState({required this.videoURL});

  @override
  void initState() {
    super.initState();
    /* _controller = VideoPlayerController.network(
      videoURL,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),

    ); */
    _controller = VideoPlayerController.file(file);

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: false,
      showOptions: false,
      looping: false,
      autoInitialize: true,
      allowFullScreen: true,
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp
      ],
      // allowPlaybackSpeedChanging: true,
    );
    _chewie = Chewie(
      controller: _chewieController,
    );
    _chewieController.addListener(() {
      if (!_chewieController.isFullScreen) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        Container(padding: const EdgeInsets.only(top: 10)),
        /* Padding(padding: EdgeInsets.only(top: 10)),
          Text("Video",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), */
        Center(
          child: Container(
            height: 400,
            padding: const EdgeInsets.all(20),
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Chewie(
                      controller: _chewieController,
                    ),
                  )
                : Center(
                    child: SizedBox(
                        height: 80.0,
                        width: 80.0,
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.blue),
                            strokeWidth: 1.0))),
          ),
        ),
        CupertinoButton(
          child: Text('Browse',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          color: Colors.indigo[700],
          padding: const EdgeInsets.all(18.0),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          onPressed: () async {
            final file = await pickVideoFile();
            if (file == null) return;

            _controller = VideoPlayerController.file(file);
            _controller.addListener(() {
              setState(() {});
            });
            _controller.setLooping(true);
            _controller.initialize();
            _chewieController = ChewieController(
              videoPlayerController: _controller,
              showOptions: true,
              autoInitialize: true,
              autoPlay: false,
              looping: true,
              allowFullScreen: true,
              deviceOrientationsOnEnterFullScreen: [
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
                DeviceOrientation.portraitDown,
                DeviceOrientation.portraitUp
              ],
              allowPlaybackSpeedChanging: true,
            );
            _chewie = Chewie(
              controller: _chewieController,
            );
            _chewieController.addListener(() {
              if (!_chewieController.isFullScreen) {
                SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp]);
                MaterialButton(
                  onPressed: () {
                    MakePaint();
                  },
                  color: Colors.blue[200],
                  textColor: Colors.white,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.draw,
                      size: 8,
                    ),
                  ),
                  padding: EdgeInsets.all(16),
                  shape: CircleBorder(),
                );
              }
            });
          },
        ),
      ]),
    );

    //return _chewie;
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<File> pickVideoFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);

    /* final result =
        (await FilePicker.platform.pickFiles(type: FileType.video)) as File; */
    if (result == null) {
      Fluttertoast.showToast(
          msg: "Please select the valid file",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return File(result!.files.single.path!);
  }
}

class DrawingArea {
  Offset? point;
  Paint? areaPaint;

  DrawingArea({this.point, this.areaPaint});
}

class MakePaint extends StatefulWidget {
  @override
  MakeCanvas createState() => MakeCanvas();
}

class MakeCanvas extends State<MakePaint> {
  List<DrawingArea> points = [];
  Color? selectedColor;
  double? strokeWidth;

  @override
  void initState() {
    super.initState();
    selectedColor = Colors.black;
    strokeWidth = 2.0;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    void selectColor() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Color Chooser'),
              content: SingleChildScrollView(
                child: BlockPicker(
                  pickerColor: selectedColor!,
                  onColorChanged: (color) {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Close"))
              ],
            );
          });
    }

    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: width * 0.80,
                    height: height * 0.80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                          )
                        ]),
                    child: GestureDetector(
                      onPanDown: (details) {
                        setState(() {
                          points.add(DrawingArea(
                              point: details.localPosition,
                              areaPaint: Paint()
                                ..strokeCap = StrokeCap.round
                                ..isAntiAlias = true
                                ..color = selectedColor!
                                ..strokeWidth = strokeWidth!));
                        });
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          points.add(DrawingArea(
                              point: details.localPosition,
                              areaPaint: Paint()
                                ..strokeCap = StrokeCap.round
                                ..isAntiAlias = true
                                ..color = selectedColor!
                                ..strokeWidth = strokeWidth!));
                        });
                      },
                      onPanEnd: (details) {
                        setState(() {
                          points.add(DrawingArea(point: null, areaPaint: null));
                        });
                      },
                      child: SizedBox.expand(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          child: CustomPaint(
                            painter: MyCustomPainter(points: points),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  List<DrawingArea>? points;

  MyCustomPainter({@required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.black26;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
    canvas.clipRect(rect);

    for (int x = 0; x < points!.length - 1; x++) {
      if (points![x] != null && points![x + 1] != null) {
        canvas.drawLine(
            points![x].point!, points![x + 1].point!, points![x].areaPaint!);
      } else if (points![x] != null && points![x + 1] == null) {
        canvas.drawPoints(
            PointMode.points, [points![x].point!], points![x].areaPaint!);
      }
    }
  }

  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
