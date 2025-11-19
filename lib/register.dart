import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class RegisterPage extends StatelessWidget {
           var emailController = TextEditingController();
           var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 25,),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "enter password",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 35,),
            ElevatedButton(onPressed: () async {
           String mail = emailController.text.trim();
           String pass = passwordController.text.trim();
           if (mail.isEmpty || pass.isEmpty) {
             ScaffoldMessenger.of(context).showSnackBar((SnackBar(content : Text("enter all fields"))));
           } else {
             try{
               FirebaseAuth.instance.createUserWithEmailAndPassword(email: mail, password: pass).then((value){
                 ScaffoldMessenger.of(context).showSnackBar((SnackBar(content : Text("Registered Successfully"))));
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
               });
             } catch(err){
              print(err);
             }
           }
            }, child: Text("register", style: TextStyle(fontSize: 18, color: Colors.white),), style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),),
            SizedBox(height: 25,),

            InkWell(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
              },
              child: Text("Already have an Account? click here", style: TextStyle(color: Colors.blueAccent),),
            ),
            ],
        ),
      ),
    );
  }
}
