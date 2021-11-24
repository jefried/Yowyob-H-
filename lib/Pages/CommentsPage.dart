import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/Model/CommentModel.dart';

class CommentsPage extends StatefulWidget {
  @override
  createState() => CommentsPageState();
}

class CommentsPageState extends State<CommentsPage> {
  List<CommentModel> _comments = [
    CommentModel(urlPhoto: "https://wallpapercave.com/w/wp5419358.jpg", name: "Ange", texte: "C'est où comme ça hugo?", time: "3m"),
    CommentModel(urlPhoto: "https://wallpapercave.com/w/wp5175876.jpg", name: "Arielle Org", texte: "Hugo tu es déjà en vacances?", time: "1h"),
    CommentModel(urlPhoto: "https://wallpapercave.com/w/wp7221464.jpg", name: "Audrey", texte: "Tu pars en vacances tu ne dis pas aux gens.", time: "1h"),
    CommentModel(urlPhoto: "https://wallpapercave.com/w/wp9103005.jpg", name: "Borex", texte: "C'est où comme ça grand?", time: "2h"),
    CommentModel(urlPhoto: "https://wallpapercave.com/w/wp3835525.jpg", name: "Brice", texte: "Belle plage ! c'est dans quel pays?", time: "2h"),
    CommentModel(urlPhoto: "https://wallpapercave.com/w/wp9103127.jpg", name: "Eken", texte: "Quand tu reviens des vacances tu me fais signe je dois te parler d'un truc intéressant !", time: "2h"),
    CommentModel(urlPhoto: "https://wallpapercave.com/w/wp9103145.jpg", name: "Jordan", texte: "ça fait longtemps tu n'as plus publié, ça fait plaisir de te revoir", time: "3h"),
  ];
  TextEditingController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  void _addComment(CommentModel comment) {
    setState((){
      _comments.add(comment);
    });
  }

  Widget _buildCommentsList() {
    return ListView.builder(
      itemCount: _comments.length,
      itemBuilder: (context, index) {
        return _buildCommentItem(_comments[index]);
      },
    );
  }

  Widget _buildCommentItem(CommentModel comment) {
    return Column(
      children: [
        Divider(height: 4,),
    ListTile(
    leading: CircleAvatar(
    radius: 15,
    backgroundImage: comment.urlPhoto != ""? CachedNetworkImageProvider(
      comment.urlPhoto,
    ) : null,
    backgroundColor: Colors.lightBlue,
    ),
    title: Row(children: [
      Text(
        comment.name + "    ",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(comment.time)
    ],)
    ),
    Padding(
        padding: EdgeInsets.fromLTRB(70, 0, 0, 10),
      child: Text(
        comment.texte,
        textAlign: TextAlign.start,
      ),
    )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Comments"),),
      body: Column(
        children: [
          Expanded(
            child: _buildCommentsList(),
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 50,
                child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20.0),
                      hintText: "Add Comment ...",
                    )
                ),
              ),
              InkWell(
                onTap: (){
                  if(!(_controller.text == "")){
                    _addComment(CommentModel(urlPhoto: "https://wallpapercave.com/wp/AYWg3iu.jpg", name: "Hugo Sondi", texte: _controller.text));
                    _controller.clear();
                  }
                },
                child: Container(width: 50, child: Text("Send", style: TextStyle(color: Colors.blue, fontSize: 15, fontWeight: FontWeight.bold),),)
              )

            ],
          )
        ],
      )
    );
  }
}