import 'package:firebase_auth/firebase_auth.dart';
import 'package:firepost/pages/signin_page.dart';
import 'package:firepost/service/auth_service.dart';
import 'package:firepost/service/prefs_service.dart';
import 'package:firepost/service/utils_service.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);
  static final String id = "signup_page";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var isLoading = false;

  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doSignUp(){

    String _name = fullNameController.text.toString().trim();
    String _email = emailController.text.toString().trim();
    String _password = passwordController.text.toString().trim();

    Navigator.pushReplacementNamed(context, HomePage.id);
     setState(() {
       isLoading = true;
     });
    AuthService.SignUpUser(context, _name, _email, _password).then((firebaseUser) => {
      _getFirebaseUser(firebaseUser),
    });
  }

  _getFirebaseUser(FirebaseUser firebaseUser) async{
    setState(() {
      isLoading = false;
    });
    if(firebaseUser != null){
      await Prefs.saveUserId(firebaseUser.uid);
      Navigator.pushReplacementNamed(context, HomePage.id);
    }else{
      Utils.fireToast("Check your information!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(
                  hintText: "FullName"
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  hintText: "Email"
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                  hintText: "Password"
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: 45,
              width: double.infinity,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                onPressed: _doSignUp,
                child: Text("SignUp", style: TextStyle(color: Colors.white),),
              ),
            ),
            Container(
              height: 45,
              width: double.infinity,
              child: TextButton(
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, SignInPage.id);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Already have an account?"),
                      SizedBox(width: 10,),
                      Text("Sign In"),
                    ],
                  )
              ),

            )
          ],
        ),
      ),
    );
  }
}
