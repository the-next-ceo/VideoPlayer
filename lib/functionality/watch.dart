// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:vid_player/resources/video_plyr.dart';
import 'package:video_player/video_player.dart';

import '../resources/action_btn.dart';

// ignore: use_key_in_widget_constructors
class Watch extends StatefulWidget {
  @override
  _WatchLocally createState() => _WatchLocally();
}

class _WatchLocally extends State<Watch> {
  File file = File('');
  VideoPlayerController? controller;

  @override
  void initState() {
    super.initState();
    //controller.initialize();
    if (file.existsSync()) {
      controller = VideoPlayerController.file(file)
        ..addListener(() => setState(() {}))
        ..setLooping(true)
        ..initialize().then((_) => controller?.play());
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Column(
        children: [
          VideoPlayerWidget(controller: controller),
          buildAddButton(),
          
        ],
      ));

  Widget buildAddButton() => Container(
        padding: const EdgeInsets.all(32),
        child: FloatingActionButtonWidget(
          onPressed: () async {
            final file = await pickVideoFile();
            if (file == null) return;

            controller = VideoPlayerController.file(file)
              ..addListener(() => setState(() {}))
              ..setLooping(true)
              ..initialize().then((_) {
                controller?.play();
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



/* return Fluttertoast.showToast(
          msg: "Please select the valid file",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0); */

/*pickVideoFile() async {
  FilePickerResult? result =
      await FilePicker.platform.pickFiles(type: FileType.video);
  if (result == null) {
    return Fluttertoast.showToast(
        msg: "Please select the valid file",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  } else {
    PlatformFile? res = result.files.first;
    return res;
  }
} */