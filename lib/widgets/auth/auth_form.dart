import 'dart:io';

import 'package:flutter/material.dart';

import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    File imageFile,
    bool isLoginMode,
    BuildContext context,
  ) onSubmitFn;
  final bool isLoading;
  AuthForm(this.onSubmitFn, this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLoginMode = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File _userImageFile;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !_isLoginMode) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState.save();
      print('email = $_userEmail, password = $_userPassword, name= $_userName');
      widget.onSubmitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName == null ? null : _userName.trim(),
        _userImageFile,
        _isLoginMode,
        context,
      );
      //widget.onSubmitFn(_userEmail.trim(), _userPassword.trim(), _userName == null ? null: _userName.trim(),_isLoginMode, context);
      //send auth request to Firebase
    }
  }

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLoginMode)
                    UserImagePicker(
                      _pickedImage,
                      key: ValueKey('user_image'),
                    ),
                  TextFormField(
                    key: ValueKey('email'),
                    onSaved: (val) {
                      _userEmail = val;
                    },
                    validator: (val) {
                      if (val.isEmpty || !val.contains('@')) {
                        return 'Please enter a valid email';
                      }

                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                    ),
                  ),
                  if (!_isLoginMode)
                    TextFormField(
                      key: ValueKey('name'),
                      onSaved: (val) {
                        _userName = val;
                      },
                      validator: (val) {
                        if (val.isEmpty || val.length < 4) {
                          return 'Please enter atleast 4 characters';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'username',
                      ),
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    onSaved: (val) {
                      _userPassword = val;
                    },
                    validator: (val) {
                      if (val.isEmpty || val.length < 7) {
                        return 'Password must be atleast 7 characters long';
                      }

                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: 'password',
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 12),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      child: Text(_isLoginMode ? 'Login' : 'Signup'),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      child: Text(_isLoginMode
                          ? 'Create new account'
                          : 'I already have an account?'),
                      onPressed: () {
                        setState(() {
                          _isLoginMode = !_isLoginMode;
                        });
                      },
                      textColor: Theme.of(context).primaryColor,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
