import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/register.dart';

import 'home.dart';

class OtpScreen extends StatefulWidget {
  String otp;
  OtpScreen({super.key, required this.otp});

  @override
  State<OtpScreen> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<OtpScreen> {
  var otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: otpController,
              decoration: InputDecoration(
                labelText: 'enter otp',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 35,),
            ElevatedButton(onPressed: () async {
              String OTP = otpController.text.trim();

              if (OTP.isEmpty ) {
                ScaffoldMessenger.of(context).showSnackBar((SnackBar(content : Text("enter otp"))));
              } else {

                try{
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.otp, smsCode: OTP);
                  await FirebaseAuth.instance.signInWithCredential(credential).then((value){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
                  });

                }on FirebaseAuth catch(err){
                  print(err);
                }
              }
            }, child: Text("verify otp", style: TextStyle(fontSize: 18, color: Colors.white),), style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),),

          ],
        ),
      ),
    );
  }
}
