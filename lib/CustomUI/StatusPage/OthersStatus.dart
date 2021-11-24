import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/Screens/StoryScreen.dart';
import 'package:flutter_whatsapp/dataStories.dart';
import 'package:social_media_widgets/instagram_story_swipe.dart';
import 'package:social_media_widgets/snapchat_dismissible.dart';
import 'package:flutter_whatsapp/Model/StoryModel.dart';

class OthersStatus extends StatelessWidget {
  const OthersStatus({Key key, this.imageName,this.name, this.time, this.isSeen, this.statusNum, this.index, this.storyScreens}) : super(key: key);
  final String name;
  final String time;
  final String imageName;
  final bool isSeen;
  final int statusNum;
  final int index;
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
                initialPage: index,
                children: stories,
              ),
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            CustomPaint(
              painter: StatusPainter(isSeen: isSeen, statusNum: statusNum),
              child: CircleAvatar(
                radius: 27,
                backgroundImage: imageName != ""? CachedNetworkImageProvider(
                  imageName,
                ) : null,
                backgroundColor: Colors.grey,
              ),
            ),
            SizedBox(height: 5,),
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

degreeToAngle(double degree){
  return degree*pi/180;
}

class StatusPainter extends CustomPainter {
  bool isSeen;
  int statusNum;
  StatusPainter({this.isSeen,this.statusNum});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
    ..isAntiAlias = true
    ..strokeWidth = 6.0
    ..color = isSeen? Colors.grey : Colors.indigo
    ..style = PaintingStyle.stroke;
    drawArc(canvas, size, paint);
  }
  void drawArc(Canvas canvas, Size size, Paint paint) {
    if(statusNum==1) {
      canvas.drawArc(Rect.fromLTWH(0.0, 0.0, size.width, size.height), degreeToAngle(0), degreeToAngle(360), false, paint);
    }
    else {
      double degree = -90;
      double arc = 360/ statusNum;
      for(int i=0; i< statusNum; i++) {
        canvas.drawArc(Rect.fromLTWH(0.0, 0.0, size.width, size.height), degreeToAngle(degree + 4), degreeToAngle(arc - 8), false, paint);
        degree += arc;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
  
}