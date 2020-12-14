import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Key key;
  UserImagePicker({this.key});
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImageFile;
  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery); 
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImageFile = pickedImageFile;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _pickedImageFile != null ? FileImage(_pickedImageFile) : null,
        ),
        FlatButton.icon(
          icon: Icon(Icons.image),
          label: Text('Add image'),
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
        ),
      ],
    );
  }
}
