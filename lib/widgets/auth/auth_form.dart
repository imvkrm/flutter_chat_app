import 'package:chat_app/widgets/picker/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  final isLoading;
  final void Function(String email, String username, String password,File? imagePath,
      bool isLogin, BuildContext context) submitFm;

  AuthForm(this.submitFm, this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userUsername = '';
  var _userPassword = '';
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    FocusScope.of(context).unfocus();
    final _isValid = _formKey.currentState!.validate();
    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).errorColor,
            content: Text('Please add a profile picture')));
      return;
    }

    if (_isValid) {
      _formKey.currentState!.save();

      widget.submitFm(
        _userEmail.trim(),
        _userUsername.trim(),
        _userPassword.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email Address'),
                    onSaved: (newValue) {
                      _userEmail = newValue!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                    autocorrect: true,
                    enableSuggestions: true,
                    textCapitalization: TextCapitalization.words,
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 4) {
                          return 'Please enter a username with atleast 4 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Username'),
                      onSaved: (newValue) {
                        _userUsername = newValue!;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 7) {
                        return 'Please enter a password with atleast 7 characters';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                    onSaved: (newValue) {
                      _userPassword = newValue!;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  widget.isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _trySubmit,
                          child: Text(_isLogin ? ' Login ' : ' SignUp '),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                  if (!widget.isLoading)
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? 'Create an account!'
                            : 'I alrady have an account'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
