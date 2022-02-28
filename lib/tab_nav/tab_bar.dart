// ignore_for_file: unnecessary_const, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:vid_player/functionality/network.dart';
import 'package:vid_player/functionality/watch.dart';

// ignore: use_key_in_widget_constructors
class Tabs extends StatelessWidget {
  var tab1 = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 22, 20, 22),
                    Color.fromARGB(255, 2, 56, 100)
                  ],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
            ),
            toolbarHeight: 30,
            bottom: TabBar(
              tabs: [
               // Tab(icon: Icon(Icons.tv), text: 'Watch'),
                Tab(icon: Icon(Icons.stream), text: 'Online Videos'),
                //Tab(icon: Icon(Icons.browse_gallery), text: 'Annotated Pics'),
              ],
              /* onTap: (tab1) {
                if (tab1 == 0) {
                   Watch();
                } else {}
              }, */
              indicatorColor: Colors.white,
              indicatorWeight: 5,
            ),
            elevation: 20,
            titleSpacing: 20,
          ),
          body: TabBarView(children: [
            //Watch(),
            NetworkPlayerWidget(),
          ]),
        ),
      ),
    );
  }
}


/* tabs: const [
          Tab(icon: Icon(Icons.tv), text: 'Watch'),
          Tab(icon: Icon(Icons.stream), text: 'Online Videos'),
          Tab(icon: Icon(Icons.browse_gallery), text: 'Annotated Pics'),
        ],
        onTap: (int value) {},
        children: [
          buildWatch(),
          /* buildOnlineVids(),
          buildDrawing(), */
        ],
      );

  Widget buildWatch() => Watch(); */