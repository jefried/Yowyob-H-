import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/Model/CountryModel.dart';

import 'CountryPage.dart';
import 'OtpScreen.dart';

class NumberPage extends StatefulWidget {
  NumberPage({Key key}) : super(key: key);

  @override
  _NumberPageState createState() => _NumberPageState();
}

class _NumberPageState extends State<NumberPage> {
  String countryname = "Cameroon";
  String countrycode = "+237";
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Enter your phone number",
          style: TextStyle(
          color:  Color.fromRGBO(143, 148, 251, 1),
            fontWeight: FontWeight.w700,
            fontSize: 18,
            wordSpacing: 1,
        ),),
        centerTitle: true,
        actions: [
          Icon(Icons.more_vert,color: Colors.black,)
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding:EdgeInsets.all(16.0) ,
              child: Text(
                "Yowyob H! will send you an sms message to verify your number.",
                style: TextStyle(
                  fontSize: 13.5,
                ),
              ),
            ),
            SizedBox(height: 5,),
            Text(
              "What's my number?",
              style: TextStyle(
                fontSize: 12.8,
                color:  Colors.black
              ),
            ),
            SizedBox(height: 15,),
            countryCard(),
            SizedBox(height: 5,),
            number(),
            Expanded(child: Container()),
            InkWell(
              onTap: (){
                if(_controller.text.length<7) {
                  showMydilogue1();
                }
                else{
                  showMydilogue();
                }
              },
              child: Container(
                color:  Color.fromRGBO(143, 148, 251, 1),
                height: 40,
                width: 70,
                child: Center(
                  child: Text(
                    "NEXT",
                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                  ),),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }

  Widget countryCard() {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (builder) => CountryPage(setCountryData: setCountryData,)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width/1.5,
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                  color:  Color.fromRGBO(143, 148, 251, 1),
                  width: 1.8,
                )
            )
        ),
        child: Row(
          children: [
            Expanded(
                child: Container(
                  child: Center(
                    child: Text(
                      countryname,
                      style: TextStyle(
                          fontSize: 16
                      ),
                    ),
                  ),
                )
            ),
            Icon(Icons.arrow_drop_down, color:  Color.fromRGBO(143, 148, 251, 1), size: 28,)
          ],
        ),
      ),
    );
  }

  Widget number(){
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      height: 38,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 70,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                      color:  Color.fromRGBO(143, 148, 251, 1),
                      width: 1.8,
                    )
                )
            ),
            child: Row(
              children: [
                SizedBox(width: 10,),
                Text("+", style: TextStyle(fontSize: 18)),
                SizedBox(width: 20,),
                Text(
                    countrycode.substring(1),
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                      color:  Color.fromRGBO(143, 148, 251, 1),
                      width: 1.8,
                    )
                )
            ),
            width: MediaQuery.of(context).size.width/1.5 - 100,
            child: TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(8),
                hintText: "phone number"
              )
            ),
          )
        ],
      ),
    );
  }

  void setCountryData(CountryModel countryModel) {
    setState(() {
      countryname = countryModel.name;
      countrycode = countryModel.code;
    });
    Navigator.pop(context);
  }

  Future<void> showMydilogue() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "We will be verifying your phone number",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10,),
                Text(countrycode + " " + _controller.text),
                SizedBox(height: 10,),
                Text(
                    "Is this OK, or would you like to edit the number?",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
              Navigator.pop(context);
            },
              child: Text("Edit"),
            ),
            TextButton(
                onPressed: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                    builder: (builder)=>OtpScreen(
                      countryCode: countrycode,
                      number: _controller.text,
                    )));
                },
                child: Text("OK")),
          ],
        );
      }
    );
  }
  Future<void> showMydilogue1() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "It's not a phone number you entered. Please enter your number",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("OK")),
            ],
          );
        }
    );
  }
}