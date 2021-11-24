import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/NewScreen/NumberPage.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                "Welcome to App Chat",
                style: TextStyle(
                  color:  Colors.black,
                  fontSize: 29,
                  fontWeight: FontWeight.w600
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height/9,
              ),
              Image.asset(
                "assets/logo.PNG",
                height: 200,
                width: 340,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height/10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                      children: [
                        TextSpan(
                            text: "Agree and continue to accept the ",
                            style: TextStyle(
                              color: Colors.grey[600],
                            )
                        ),
                        TextSpan(
                            text: "Yowyob H! Terms of Service and Privacy Policy",
                            style: TextStyle(
                                color: Colors.indigo
                            )
                        ),
                      ]
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>NumberPage()), (route) => false);
                },
                child: Container(
                    width: MediaQuery.of(context).size.width-110,
                    height: 50,
                    child: Card(
                      margin: EdgeInsets.all(0),
                      elevation: 8,
                      color:  Color.fromRGBO(143, 148, 251, 1),
                      child: Center(
                        child: Text(
                          "AGREE AND CONTINUE",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}