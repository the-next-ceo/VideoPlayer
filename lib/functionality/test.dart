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
  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  late Chewie _chewie;
  late ChewieController _chewieController;
  File file = File('');
  final MakeCanvas paintWidget = new MakeCanvas();
  OverlayEntry? entry;
  Offset offset = Offset(20, 40);

  @override
  void initState() {
    super.initState();
    /* _controller = VideoPlayerController.network(
      videoURL,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),

    ); */

    WidgetsBinding.instance!.addPostFrameCallback((_) => showOverlay());

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
    /* _chewieController.addListener(() {
      if (!_chewieController.isFullScreen) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }
    }); */
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
              if (_chewieController.isFullScreen) {
                // MakePaint();
                WidgetsBinding.instance!
                    .addPostFrameCallback((_) => showOverlay());
              } else {
                hideOverlay();
              }
            });
          },
        ),
        /* CupertinoButton(
            child: Text('press'),
            onPressed: () {
              // showOverlay();
              selectColor();
            }) */
      ]),
    );

    //return
    // _chewie;
  }

  void selectColor() {
   Color selectedColor = Colors.black;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Color Chooser'),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: selectedColor,
                onColorChanged: (color) {
                  setState(() {
                    color = selectedColor;
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

  void showOverlay() {
    entry = OverlayEntry(
        builder: (context) => Positioned(
              left: offset.dx,
              top: offset.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  offset += details.delta;
                  entry!.markNeedsBuild();
                },
                child: MaterialButton(
                    onPressed: () async {
                      selectColor();
                    },
                    color: Colors.blue[800],
                    textColor: Colors.white,
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.draw,
                        size: 20,
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                    shape: CircleBorder()
                    /* ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.stop_circle_rounded),
                  label: Text('Record')), */
                    ),
              ),
            ));
    final overlay = Overlay.of(context)!;
    overlay.insert(entry!);
  }

  void hideOverlay() {
    entry?.remove();
    entry = null;
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    hideOverlay();
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

  /* @override
  void initState() {
    super.initState();
    selectedColor = Colors.black;
    strokeWidth = 2.0;
  } */

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

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
