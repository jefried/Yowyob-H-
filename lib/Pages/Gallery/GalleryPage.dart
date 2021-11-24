import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_whatsapp/Screens/PostOrStory.dart';

class Gallery extends StatefulWidget {
  Gallery ({Key key, this.from}): super();
  final String from;
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  // This will hold all the assets we fetched
  List<AssetEntity> assets = [];

  _fetchAssets() async {
    // Set onlyAll to true, to fetch only the 'Recent' album
    // which contains all the photos/videos in the storage
    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    final recentAlbum = albums.first;

    // Now that we got the album, fetch all the assets it contains
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0,
      end: 100000,
    );

    // Update the state and notify UI
    setState(() => assets = recentAssets);
  }

  @override
  void initState() {
    // TODO: implement initState
    _fetchAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          // A grid view with 3 items per row
          crossAxisCount: 3,
        ),
        itemCount: assets.length,
        itemBuilder: (_, index) {
          return AssetThumbnail(asset: assets[index], from: widget.from);
        },
      ),
    );
  }
}

class AssetThumbnail extends StatelessWidget {
  const AssetThumbnail({
    Key key,
    @required this.asset,
    this.from,
  }) : super(key: key);

  final AssetEntity asset;
  final String from;

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<Uint8List>(
      future: asset.thumbData,
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        // If we have no data, display a spinner
        if (bytes == null) return CircularProgressIndicator();
        // If there's data, display it as an image
        return Padding(
          padding: EdgeInsets.all(2),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    if (asset.type == AssetType.image) {
                      // If this is an image, navigate to ImageScreen
                      return ImageScreen(imageFile: asset.file, from: from);
                    } else {
                      // if it's not, navigate to VideoScreen
                      return VideoScreen(videoFile: asset.file, from: from);
                    }
                  },
                ),
              );
            },
            child: Stack(
              children: [
                // Wrap the image in a Positioned.fill to fill the space
                Positioned.fill(
                  child: Image.memory(bytes, fit: BoxFit.cover),
                ),
                // Display a Play icon if the asset is a video
                if (asset.type == AssetType.video)
                  Center(
                    child: Container(
                      color: Colors.black38,
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ImageScreen extends StatefulWidget {
  const ImageScreen({
    Key key,
    @required this.imageFile,
    this.from,
  }) : super(key: key);

  final Future<File> imageFile;
  final String from;


  _ImageScreenState createState() => _ImageScreenState();

}

class _ImageScreenState extends State<ImageScreen> {
  String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<File>(
        future: widget.imageFile,
        builder: (_, snapshot) {
          final imageFile = snapshot.data;
          if (imageFile == null) return Container();
          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.black,
                body: FittedBox(
                  child: Image.file(imageFile),
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                  bottom: 7,
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 90,
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
                          onChanged: (string) {
                            setState(() {
                              message = string;
                            });
                          },
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
                          Navigator.push(context, MaterialPageRoute(builder: (builder) => PostOrStory(from: widget.from, media: imageFile, mediaType: "image", texte: message)));
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
            ],
          );
        },
      ),
    );
  }
}


class VideoScreen extends StatefulWidget {
  const VideoScreen({
    Key key,
    @required this.videoFile,
    this.from,
  }) : super(key: key);

  final Future<File> videoFile;
  final String from;

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController _controller;
  bool initialized = false;
  String message = "";
  File videoFile;

  @override
  void initState() {
    _initVideo();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _initVideo() async {
    final video = await widget.videoFile;
    _controller = VideoPlayerController.file(video)
    // Play the video again when it ends
      ..setLooping(true)
    // initialize the controller and notify UI when done
      ..initialize().then((_) => setState(() => initialized = true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: initialized
      // If the video is initialized, display it
          ? Stack(
        children: [
      Scaffold(
      backgroundColor: Colors.black,
      body: Center(
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        // Use the VideoPlayer widget to display the video.
        child: VideoPlayer(_controller),
      ),
    ),),
    Center(child: InkWell(
      onTap: () {
        // Wrap the play or pause in a call to `setState`. This ensures the
        // correct icon is shown.
        setState(() {
          // If the video is playing, pause it.
          if (_controller.value.isPlaying) {
            _controller.pause();
          } else {
            // If the video is paused, play it.
            _controller.play();
          }
        });
      },
      child: CircleAvatar(
        backgroundColor: Colors.black,
        radius: 30,
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
        ),
      ),
    ),),
          Positioned(
              bottom: 7,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 90,
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
                      onChanged: (string) {
                        setState(() {
                          message = string;
                        });
                      },
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
                      : InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (builder) => PostOrStory(from: widget.from, media: videoFile, mediaType: "video", texte: message)));
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
        ],
      )
      // If the video is not yet initialized, display a spinner
          : Center(child: CircularProgressIndicator()),
    );
  }
}