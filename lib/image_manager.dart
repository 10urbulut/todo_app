import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImageManager {
  List<XFile>? imageFileList;
  XFile? imageFile;
  String? _retrieveDataError;
  BuildContext context;

  set _imageFile(XFile? value) {
    imageFileList = value == null ? null : [value];
  }

  late ImagePicker picker;

  ImageManager(this.context) {
    picker = ImagePicker();
  }

  Future<XFile?> pickSelectedImage(
      {double maxWidth = 1080,
      double maxHeight = 1920,
      int quality = 90}) async {
    var pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: quality,
    );
    imageFile = pickedFile;

    return pickedFile;
  }

  // Future<XFile?> takePhoto(
  //     {double maxWidth = 1080,
  //     double maxHeight = 1920,
  //     int quality = 90}) async {
  //   var pickedFile = await picker.pickImage(
  //     source: ImageSource.camera,
  //     maxWidth: maxWidth,
  //     maxHeight: maxHeight,
  //     imageQuality: quality,
  //   );
  //   imageFile = pickedFile;

  //   return pickedFile;
  // }

  Future<XFile?> takePhoto2({int quality = 90}) async {
    var pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: quality,
    );
    imageFile = pickedFile;

    return pickedFile;
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
      } else {
        imageFile = response.file;
        _imageFile = response.file;
        imageFileList = response.files;
      }
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  String? getRetrieveError() {
    if (_retrieveDataError != null) {
      _retrieveDataError = null;
      return _retrieveDataError;
    }
    return null;
  }
}
