import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:video_player/video_player.dart';

class OwnMessageCard extends StatefulWidget {
  const OwnMessageCard(
      {Key key, this.message, this.time, this.url, this.sent, this.mediaType})
      : super(key: key);
  final String message;
  final String time;
  final String url;
  final bool sent;
  final String mediaType;

  _OwnMessageCardState createState() => _OwnMessageCardState();

}

class _OwnMessageCardState extends State<OwnMessageCard> with TickerProviderStateMixin{
  AnimationController controller;
  VideoPlayerController _videoController;
  String state;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    super.initState();
    tryToDownload();
  }

  void tryToDownload() {
    if(widget.mediaType == "video") {
      state = "downloading";
      setState(() {});
      Timer(Duration(seconds:12), handleTimeout);
      _videoController = VideoPlayerController.network(widget.url)
        ..initialize().then((_) {
          state = "downloaded";
          setState(() {});
        });
    }
  }

  void handleTimeout() {
    if(state == "downloading") {
      state = "abort";
      controller = null;
      _videoController = null;
      setState((){});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Colors.indigo,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Column(
                  children: [
                    widget.mediaType == "image"? CachedNetworkImage(
                    imageUrl: widget.url,
                    fit: BoxFit.cover,
                    ): Container(),
                    state == "downloaded"?
                        GestureDetector(
                          onTap: () {
                            if (_videoController.value.isPlaying) {
                              _videoController.pause();
                            } else {
                              _videoController.play();
                            }
                          },
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                                width: _videoController.value.size.width,
                                height: _videoController.value.size.height,
                                child: Stack(
                                  children: [
                                    VideoPlayer(_videoController),
                                    Positioned(
                                      left: _videoController.value.size.width/2 - 50,
                                      top: _videoController.value.size.height/2 - 50,
                                      child: CircleAvatar(radius: 50,
                                        backgroundColor: Colors.black12,
                                        child: Icon(Icons.play_arrow, size: 30,
                                          color: Colors.white,
                                        ),),
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ): Container(),
                    (state == "downloading")?
                        Container(
                          height: 150,
                          color: Colors.black12,
                          child: Center(
                            child: Text("Downloading ...", style: TextStyle(fontSize: 15),)
                          )
                        ) : Container(),
                    (state == "abort")?
                        Container(
                          height: 150,
                          color: Colors.black12,
                          child: Center(
                            child: InkWell(
                              onTap: (){
                                tryToDownload();
                              },
                              child: CircleAvatar(radius: 25,
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.download_rounded, size: 30,
                                  color: Colors.white,
                                ),),
                            )
                            ,),)
                        : Container(),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 60, top: 5, bottom: 20),
                      child: Text(widget.message, style: TextStyle(
                        fontSize: 16,
                        color: Colors.white
                      ),),
                    ),
                  ],
                ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(widget.time, style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.done_all, size: 20, color: Colors.white,)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}