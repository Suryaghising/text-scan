import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageSelector {

  Future<File?> getSelectedImage(ImageSource imageSource) async{
    final status = await Permission.storage.request();
    if (status.isGranted) {
      File? croppedImage = await _imagePickerCallBack(imageSource);
      return croppedImage;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return Future.error('Please enable storage permission.');
    } else {
      print('Permission denied.');
      return Future.error('Permission denied. Please enable storage permission.');
    }

  }

  Future<File?> _imagePickerCallBack(ImageSource imageSource) async {
    try {
      PickedFile? image =
      await ImagePicker().getImage(source: imageSource, imageQuality: 85);
      if (image != null) {
        File? croppedImage = await _cropPickedImage(image.path);
        return croppedImage;
      }
      return Future.error('No image selected.');
    } catch (e) {
      print(e);
      return Future.error(e.toString());
    }
  }

  Future<File?> _cropPickedImage(filePath) async {
    File? croppedImage = await ImageCropper.cropImage(
        sourcePath: filePath,
        androidUiSettings: const AndroidUiSettings(
          toolbarColor: Colors.amber,
          toolbarWidgetColor: Colors.white,
        ),
        maxWidth: 1080,
        maxHeight: 1080,
    );
    return croppedImage;
  }
}