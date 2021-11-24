import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/Screens/StoryScreen.dart';
import 'package:flutter_whatsapp/dataStories.dart';
import 'package:social_media_widgets/instagram_story_swipe.dart';
import 'package:social_media_widgets/snapchat_dismissible.dart';
import 'package:flutter_whatsapp/Model/StoryModel.dart';


class HeadOwnStatus extends StatelessWidget {
  const HeadOwnStatus({Key key, this.storyScreens}) : super(key: key);

  final List<List<StoryModel>> storyScreens;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: (){
        List<Widget> stories = [];
        storyScreens.forEach((element) {
          stories.add(StoryScreen(stories: element));
        });
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => SnapchatDismiss(
              child: InstagramStorySwipe(
                initialPage: 0,
                children: stories
              ),
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 29,
                  backgroundImage: CachedNetworkImageProvider(
                      'https://wallpapercave.com/wp/AYWg3iu.jpg'
                  ),
                  backgroundColor: Colors.grey,
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.indigo,
                      radius: 10,
                      child: Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.white,
                      ),
                    )
                )
              ],
            ),
            Text("Your Story", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)
          ],
        ),
      ),
    );
  }
}