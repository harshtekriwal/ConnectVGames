import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(PickedFile pickedImage) imagePickFn;
  UserImagePicker(this.imagePickFn);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  PickedFile _pickedImage;
  void _pickImage() async {
    final pickedImageFile = await ImagePicker()
        .getImage(imageQuality: 50, maxWidth: 150, source: ImageSource.camera);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(File(_pickedImage.path)) : null),
      FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: () {
            _pickImage();
          },
          icon: Icon(Icons.image),
          label: Text('Add Image'))
    ]);
  }
}
