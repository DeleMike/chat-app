import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Future<void> Function(
          String email, String password, String username, bool isLoginMode,)
      onSubmitFn;
  AuthForm(this.onSubmitFn);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLoginMode = true;
  var _userEmail;
  var _userName;
  var _userPassword;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      widget.onSubmitFn(_userEmail, _userName, _userPassword, _isLoginMode,);
      //send auth request to Firebase
    }
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
                  RaisedButton(
                    child: Text(_isLoginMode ? 'Login' : 'Signup'),
                    onPressed: _trySubmit,
                  ),
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
