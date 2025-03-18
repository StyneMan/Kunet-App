import 'package:kunet_app/components/text/textComponents.dart';
import 'package:kunet_app/helper/constants/constants.dart';
import 'package:kunet_app/helper/state/state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

typedef InitCallback(params);

class ImgPicker extends StatefulWidget {
  final InitCallback onCropped;
  const ImgPicker({
    Key? key,
    required this.onCropped,
  }) : super(key: key);

  @override
  State<ImgPicker> createState() => _ImgPickerState();
}

class _ImgPickerState extends State<ImgPicker> {
  // File? _photo;

  final ImagePicker _picker = ImagePicker();
  final _controller = Get.find<StateController>();

  Future imgFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      // setState(() {
      if (pickedFile != null) {
        //Now crop image
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Image Cropper',
              toolbarColor: Constants.primaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ],
            ),
            IOSUiSettings(
              title: 'Image Cropper',
            ),
            WebUiSettings(
              context: context,
            ),
          ],
        );

        // croppedFile.path

        widget.onCropped(croppedFile?.path);
        _controller.croppedPic.value = "${croppedFile?.path}";

        Future.delayed(const Duration(milliseconds: 200), () {
          Navigator.of(context).pop();
        });
      } else {
        debugPrint('No image selected.');
      }
    } catch (e) {
      debugPrint("IMAGE CROP ERR: ${e.toString()}");
    }
    // });
  }

  Future imgFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      // setState(() {
      if (pickedFile != null) {
        //Now crop image
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Image Cropper',
              toolbarColor: Constants.primaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ],
            ),
            IOSUiSettings(
              title: 'Image Cropper',
            ),
            WebUiSettings(
              context: context,
            ),
          ],
        );

        widget.onCropped(croppedFile?.path);
        _controller.croppedPic.value = "${croppedFile?.path}";

        Future.delayed(const Duration(milliseconds: 200), () {
          Navigator.of(context).pop();
        });
      } else {
        debugPrint('No image selected.');
      }
    } catch (e) {
      debugPrint("IMAGE CROP ERR: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16.0),
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // Navigator.of(context).pop();
            imgFromCamera();
          },
          icon: const Icon(CupertinoIcons.camera),
          label: TextBody2(text: "Camera", color: Colors.white),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10.0),
            backgroundColor: Constants.accentColor,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        ElevatedButton.icon(
          onPressed: () {
            imgFromGallery();
          },
          icon: const Icon(CupertinoIcons.folder),
          label: TextBody2(text: "Gallery", color: Colors.white),
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10.0),
              backgroundColor: Constants.secondaryColor),
        ),
      ],
    );
  }
}
