import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/Pages/CommentsPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

class PostCard extends StatefulWidget {
  PostCard({Key key, this.urlPhoto, this.name, this.urlMedia, this.typeMedia, this.texte, this.date, this.likes}): super(key: key);
  String urlPhoto;
  String name;
  String urlMedia;
  String typeMedia;
  String texte;
  String date;
  int likes;

  @override
  PostCardState createState() => PostCardState();
}

class PostCardState extends State<PostCard> {

  VideoPlayerController _videoController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoController = VideoPlayerController.network(widget.urlMedia)
      ..initialize().then((_) {
        setState(() {});
        if (_videoController.value.initialized) {
          _videoController.play();
        }
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoController?.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          child: Row(
            children: [
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width/10 * 2,
                color: Colors.grey,
              ),
              Container(
                height: 2,
                width: MediaQuery.of(context).size.width/10 * 6,
                color: Colors.indigo,
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width/10 * 2,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        Padding(padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            new Container(
              height: 40.0,
              width: 40.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage(widget.urlPhoto)
                  )
              ),
            ),
            SizedBox(width: 10.0,),
            Text(widget.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
        IconButton(icon: Icon(Icons.more_vert), onPressed: null)
      ],
    ),
        ),
        GestureDetector(
        onTapDown: (details) => _onTapDown(details),
        child: Flexible(child:
        widget.typeMedia == "image"?
        CachedNetworkImage(
          imageUrl: widget.urlMedia,
          fit: BoxFit.cover,
        ) : widget.typeMedia == "video" ?
        (_videoController != null &&
            _videoController.value.initialized)? FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _videoController.value.size.width,
            height: _videoController.value.size.height,
            child: VideoPlayer(_videoController),
          ),
        ): SizedBox(height: 1,) : SizedBox(height: 1,)
        ),
        ),
        Container(
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width/11 * 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(""),
                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 15, 0), child: Text(widget.likes.toString()))
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width/11 * 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Icon(FontAwesomeIcons.heart, color: Colors.indigo, size: 30,),
                    SizedBox(width: 16.0,),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CommentsPage()));
                      },
                      child: Icon(FontAwesomeIcons.comment, color: Colors.indigo, size: 30,)
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CommentsPage()));
                },
                child: Container(
                    width: MediaQuery.of(context).size.width/11 * 4,
                    child: Padding(padding: EdgeInsets.fromLTRB(15, 0, 0, 0), child: Text("2"),)
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 15,20, 10),
            child: Text(widget.texte)
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 25.0,
                width: 25.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(widget.urlPhoto)
                  )
                ),
              ),
              SizedBox(width: 10.0,),
              Expanded(
                child: TextField(
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText: "Add a comment ...",
                  )
                ),
              )
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Text(widget.date, style: TextStyle(color: Colors.grey)),
        ),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey,
        ),
      ],
    );
  }

  void _onTapDown(TapDownDetails details) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (widget.typeMedia == "video") {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
    }
  }
}