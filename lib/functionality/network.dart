import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import '../resources/action_btn.dart';

class NetworkPlayerWidget extends StatefulWidget {
  @override
  _NetworkPlayerWidgetState createState() => _NetworkPlayerWidgetState();
}

class _NetworkPlayerWidgetState extends State<NetworkPlayerWidget> {
  File file = File('');

  ChewieController? _chewieController;

  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();

    videoPlayerController = VideoPlayerController.file(file);

    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      showControls: true,
    );
    if (file.existsSync()) {
      videoPlayerController = VideoPlayerController.file(file)
        ..addListener(() => setState(() {}))
        ..setLooping(true)
        ..initialize().then((_) => videoPlayerController.play());
      setState(() {});
    }
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [Chewie(controller: _chewieController!)],
        ),
      );

  Widget buildAddButton() => Container(
        padding: const EdgeInsets.all(32),
        child: FloatingActionButtonWidget(
          onPressed: () async {
            final file = await pickVideoFile();
            if (file == null) return;

            videoPlayerController = VideoPlayerController.file(file)
              ..addListener(() => setState(() {}))
              ..setLooping(true)
              ..initialize().then((_) {
                videoPlayerController.play();
                setState(() {});
              });
          },
        ),
      );

  Future<File> pickVideoFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);

    /* final result =
        (await FilePicker.platform.pickFiles(type: FileType.video)) as File; */
    if (result == null) return throw Exception('no files');
    return File(result.files.single.path!);
  }
}


/* static var url = 'https://youtu.be/_WH6cbwZ5m8';

  final textController = TextEditingController(text: url);
  VideoPlayerController ?controller;


  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.network(textController.text)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => controller?.play());
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            VideoPlayerWidget(controller: controller),
            buildTextField(),
          ],
        ),
      );

  Widget buildTextField() => Container(
        padding: EdgeInsets.all(32),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: "Paste the Url",
                  hintStyle: TextStyle(color: Colors.black)
              
                ),
                
              ),
            ),
            const SizedBox(width: 12),
            FloatingActionButtonWidget(
              onPressed: () {
                if (textController.text.trim().isEmpty) return;
              },
            ),
          ],
        ),
      ); */