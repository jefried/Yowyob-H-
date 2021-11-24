import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp/flutter_otp.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_whatsapp/Screens/LoginScreen.dart';
import 'package:flutter_whatsapp/my_widgets/alert_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({Key key,this.number,this.countryCode}) : super(key: key);
  final String number;
  final String countryCode;

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _verificationCode;
  String phoneNumber;
  String countryCode = "+237";
  int minNumber = 100000;
  int maxNumber = 999999;
  String code;
  FlutterOtp otp = FlutterOtp();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
    //_sendSMS();
  }

  void _sendSMS() async{
    code = "";
    int i = 1;
    var rng = new Random();
    while(i<7){
      code += rng.nextInt(9).toString();
      i++;
    }

    otp.sendOtp(phoneNumber,"Your authentification number for Yowyob H! is : $code", minNumber,maxNumber,countryCode);

  }

  _verifyPhone() async{
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${widget.countryCode}${widget.number}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
                if(value.user != null) {
                  print('user logged in');
                }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {

            print("code was sent to ${widget.countryCode}${widget.number}");
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 60));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Verification of your number",
          style: TextStyle(
            color: Colors.indigoAccent,
            fontSize: 16.5,
          ),
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert), color: Colors.black,)
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            RichText(
              textAlign: TextAlign.center,
                text: TextSpan(
              children: [
                TextSpan(
                    text:"We have sent an SMS with a code to ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.5,
                  )
                ),
                TextSpan(
                    text: widget.countryCode + " " + widget.number +".",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                    )
                ),
                TextSpan(
                    text:" Please enter the code.",
                    style: TextStyle(
                      color: Colors.indigoAccent,
                      fontSize: 14.5,
                    )
                )
              ]
            )),
            SizedBox(
              height: 5,
            ),
            OTPTextField(
              onCompleted: (pin) async{
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                      verificationId: _verificationCode, smsCode: pin))
                      .then((value) async {
                    if (value.user != null) {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (builder)=> LoginScreen(numCurrent: widget.number)));
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  AlertHelper().error(context, "Code invalide !");
                }
              },
              length: 6,
              width: MediaQuery.of(context).size.width,
              fieldWidth: 30,
              style: TextStyle(
                fontSize: 17
              ),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.underline,
            ),
            SizedBox(height: 20,),
            Text("Enter 6-digit code",style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            )),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: (){
                _sendSMS();
                setState(() {});
              },
              child: bottomButton("Resend SMS", FontAwesomeIcons.comment,),
            ),
            SizedBox(height: 12,),
          ],
        ),
      ),
    );
  }

  Widget bottomButton(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon,color: Colors.indigoAccent,size: 24,),
        SizedBox(
          width: 25,
        ),
        Text(
          text,
          style: TextStyle(
            color: Colors.indigoAccent,
            fontSize: 14.5,
          ),
        )
      ],
    );
  }
}