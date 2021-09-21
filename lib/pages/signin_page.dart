import 'package:firebase_auth/firebase_auth.dart';
import 'package:firepost/pages/signup_page.dart';
import 'package:firepost/service/auth_service.dart';
import 'package:firepost/service/prefs_service.dart';
import 'package:firepost/service/utils_service.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key key}) : super(key: key);
  static final String id = "signin_page";

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  var isLoading = false;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doSignIn(){

    String _email = emailController.text.toString().trim();
    String _password = emailController.text.toString().trim();

    if(_email.isEmpty || _password.isEmpty) return;

     setState(() {
       isLoading = true;
     });
    AuthService.SignInUser(context, _email, _password).then((firebaseUser) => {
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
      Utils.fireToast("Check your email or password!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                      hintText: "Password",
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
                    onPressed: _doSignIn,
                    child: Text("SignIn", style: TextStyle(color: Colors.white),),
                  ),
                ),
                Container(
                  height: 45,
                  width: double.infinity,
                  child: TextButton(
                      onPressed: (){
                        Navigator.pushReplacementNamed(context, SignUpPage.id);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Don't have an account?"),
                          SizedBox(width: 10,),
                          Text("Sign Up"),
                        ],
                      )
                  ),

                )
              ],
            ),
          ),
          isLoading ? CircularProgressIndicator()
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
