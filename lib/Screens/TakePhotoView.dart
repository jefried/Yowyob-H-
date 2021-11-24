import 'dart:math';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_whatsapp/Screens/CameraView.dart';
import 'package:flutter_whatsapp/Screens/VideoView.dart';

List<CameraDescription> cameras;

class TakePhotoView extends StatefulWidget {
  TakePhotoView ({Key key}): super(key: key);

  _TakePhotoViewState createState() => _TakePhotoViewState();
}

class _TakePhotoViewState extends State<TakePhotoView> {

  CameraController _cameraController;
  Future<void> cameraValue;
  bool isRecoring = false;
  bool flash = false;
  bool iscamerafront = true;
  double transform=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    cameraValue = _cameraController.initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Stack(
          children: [
            FutureBuilder(
                future: cameraValue,
                builder: (context, snapshot) {
                  if(snapshot.connectionState==ConnectionState.done) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: CameraPreview(_cameraController)
                    );
                  }
                  else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            Positioned(
                bottom: 0.0,
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.only(top:5, bottom:5),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(
                              flash? Icons.flash_on : Icons.flash_off, color: Colors.white, size: 28,),
                            onPressed: () {
                              setState(() {
                                flash = !flash;
                              });
                              flash
                                  ?_cameraController.setFlashMode(FlashMode.torch)
                                  : _cameraController.setFlashMode(FlashMode.off);
                            },),
                          GestureDetector(
                            onLongPress: () async{
                              await _cameraController.startVideoRecording();
                              setState(() {
                                isRecoring = true;
                              });
                            },
                            onLongPressUp: () async{
                              XFile videopath = await _cameraController.stopVideoRecording();
                              setState(() {
                                isRecoring = false;
                              });
                              Navigator.push(context,MaterialPageRoute(builder: (builder) => VideoViewPage(path: videopath.path,)));
                            },
                            onTap: () {
                              if(!isRecoring)
                                takePhoto(context);
                            },
                            child: isRecoring ? Icon(Icons.radio_button_on,color: Colors.red, size: 80,)
                                : Icon(Icons.panorama_fish_eye, color: Colors.white,size: 70,),
                          ),
                          IconButton(
                            icon: Transform.rotate(
                              angle: transform,
                              child: Icon(Icons.flip_camera_ios, color: Colors.white,size: 28,),
                            ),
                            onPressed: () async{
                              setState(() {
                                iscamerafront = !iscamerafront;
                                transform = transform + pi;
                              });
                              int cameraPos = iscamerafront ? 0 : 1;
                              _cameraController = CameraController(cameras[cameraPos], ResolutionPreset.high);
                              cameraValue = _cameraController.initialize();
                            },)
                        ],),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Hold for video, tap for photo",
                        style: TextStyle(
                          color: Colors.white,

                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                )
            )
          ],
        )
    );
  }
  void takePhoto(BuildContext context) async{
    //final path = join((await getTemporaryDirectory()).path, "${DateTime.now()}.png");
    XFile path = await _cameraController.takePicture();
    Navigator.push(context, MaterialPageRoute(builder: (builder) => CameraViewPage(path: path.path,)));
  }
}