import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  Future<void> _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLoginMode,
  ) async {
    UserCredential authResult;

    try {
      if (isLoginMode) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on PlatformException catch (error) {
        var msg = 'An error occured, please check your credentials';
        if(error.message != null) {
          msg = error.message;
        } 

        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).errorColor,
        ),);
    }catch (err){
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      //appBar: AppBar(title: Text('')),
      body: AuthForm(_submitAuthForm),
    );
  }
}
