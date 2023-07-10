import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileWidget extends StatefulWidget {
  final String defaultImagePath;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.defaultImagePath,
    required this.onClicked,
  }) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late ImageProvider<Object> _image;

  @override
  void initState() {
    super.initState();
    _image = AssetImage(widget.defaultImagePath);
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = FileImage(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => _buildBottomSheet(),
        );
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: _image,
            fit: _image != AssetImage(widget.defaultImagePath)
                ? BoxFit.cover
                : BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Choose from Gallery'),
            onTap: () {
              Navigator.of(context).pop();
              _pickImage(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_camera),
            title: Text('Take a Photo'),
            onTap: () {
              Navigator.of(context).pop();
              _pickImage(ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }
}
