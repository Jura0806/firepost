
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firepost/pages/signin_page.dart';
import 'package:firepost/service/prefs_service.dart';
import 'package:flutter/cupertino.dart';

class AuthService{

  static final _auth = FirebaseAuth.instance;

  static Future<FirebaseUser> SignInUser(BuildContext context, String _email, String _password) async{
    try{
      _auth.signInWithEmailAndPassword(email: _email, password: _password);
      final FirebaseUser user = await _auth.currentUser();
      print(user.toString());
      return user;
    } catch(e){
      print(e);
    }
    return null;
  }

  static Future<FirebaseUser> SignUpUser(BuildContext context,String name, String _email, String _password) async{
    try{
     var authResult = await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
     FirebaseUser user = authResult.user;
     print(user.toString());
     return user;
    } catch(e){
      print(e);
    }
    return null;
  }

  static void SignOutUser(BuildContext context){
    _auth.signOut();
    Prefs.removeUserId().then((value){
      Navigator.pushReplacementNamed(context, SignInPage.id);
    });
  }

}