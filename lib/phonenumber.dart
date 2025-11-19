import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/register.dart';

import 'home.dart';
import 'otp.dart';

class PhoneNumber extends StatelessWidget {
  var numberController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: numberController,
              decoration: InputDecoration(
                labelText: 'enter number',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 35,),
            ElevatedButton(onPressed: (){
              String number = numberController.text.trim();

              if (number.isEmpty ) {
                ScaffoldMessenger.of(context).showSnackBar((SnackBar(content : Text("enter your number"))));
              }

              else {

                try{
                  FirebaseAuth.instance.verifyPhoneNumber(verificationCompleted: (credential){}, verificationFailed: (error){}, codeSent: (otp, token){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OtpScreen(otp: otp,)));
                  }, codeAutoRetrievalTimeout: (otp){},phoneNumber: number);


                }on FirebaseAuth catch(err){
                  print(err);
                }
              }
            }, child: Text("get otp", style: TextStyle(fontSize: 18, color: Colors.white),), style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),),

          ],
        ),
      ),
    );
  }
}
