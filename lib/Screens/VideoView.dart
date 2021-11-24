import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/Screens/PostOrStory.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class VideoViewPage extends StatefulWidget {
  const VideoViewPage({Key key, this.path, this.from}): super(key: key);
  final String path;
  final String from;

  @override
  _VideoViewPageState createState() => _VideoViewPageState();
}

class _VideoViewPageState extends State<VideoViewPage> {
  VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
    ..initialize().then((_) {
      // ensure the first frame is shown after the video is initialized, event before the play:
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: Icon(Icons.crop_rotate, size: 27,),
            onPressed: () {},),
          IconButton(icon: Icon(Icons.emoji_emotions_outlined, size: 27,),
            onPressed: () {},),
          IconButton(icon: Icon(Icons.title, size: 27,),
            onPressed: () {},),
          IconButton(icon: Icon(Icons.edit, size: 27,),
            onPressed: () {},)
        ],
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 150,
                child: _controller.value.initialized
                  ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
                    : Container(),
              ),
              Positioned(
                  bottom: 7,
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 50,
                        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white)
                        ),
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.white,
                              backgroundColor: Colors.transparent,
                              fontSize: 17
                          ),
                          maxLines: 6,
                          minLines: 1,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Type a message",
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 17
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5,),
                      widget.from == "IndividualPage"?
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.paperPlane,
                          color: Colors.indigo,),
                        onPressed: () {},
                      )
                          :widget.from == "GroupPage"?
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.paperPlane,
                          color: Colors.indigo,),
                        onPressed: () {},
                      )
                          :InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (builder) => PostOrStory(from: widget.from, media: File(widget.path), mediaType: "video")));
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.indigo,
                          child: Icon(Icons.check, color: Colors.white, size: 27,),
                        ),
                      )
                    ],
                  )
              ),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying
                          ?_controller.pause()
                          : _controller.play();
                    });
                  },
                  child: CircleAvatar(
                    radius: 33,
                    backgroundColor: Colors.black38,
                    child: Icon(
                    _controller.value.isPlaying? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 50,),
              )
                ),
              )
            ],
          )
      ),
    );
  }
}