import 'dart:io';

import '../../export.dart';

Future<dynamic>? customImagePicker({bool selfie = false}) {
  if (selfie) {
    return ImagePicker()
        .pickImage(
            source: ImageSource.camera,
            preferredCameraDevice: CameraDevice.front,
            imageQuality: 10)
        .then((value) async {
      if (value != null) {
        return File(value.path);
      }
      return null;
    });
  } else {
    return customBottomSheet(options: [
      BottomSheetOptionModel(
        name: "Camera",
        onTap: () {
          Get.back(result: ImageSource.camera);
        },
      ),
      BottomSheetOptionModel(
        name: "Gallery",
        onTap: () => Get.back(result: ImageSource.gallery),
      ),
    ]).then((source) async {
      if (source != null) {
        return ImagePicker().pickImage(source: source, imageQuality: 10).then(
              (value) async {
            if (value != null) {
              return File(value.path);
            }
            return null;
          },
        );
      }
      return null;
    });
  }
}

Future<dynamic>? customImagePickerInWeb() {
  return ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 10).then(
        (value) async {
      if (value != null) {
        return File(value.path);
      }
      return null;
    },
  );
}

Future<List<File>?>? customMultipleImagePicker() {
  return customBottomSheet(options: [
    BottomSheetOptionModel(
      name: "Camera",
      onTap: () async {
        final image = await ImagePicker().pickImage(source: ImageSource.camera);
        if (image != null) {
          Get.back(result: [File(image.path)]);
        }
      },
    ),
    BottomSheetOptionModel(
      name: "Gallery",
      onTap: () async {
        final images = await ImagePicker().pickMultiImage();
        if (images.isNotEmpty) {
          Get.back(result: images.map((image) => File(image.path)).toList());
        }
      },
    ),
  ]).then((dynamic result) {
    if (result != null) {
      return Future.value(result.cast<File>());
    }
    return null;
  });
}

Future customBottomSheet({required List<BottomSheetOptionModel> options}) {
  return Get.bottomSheet(
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 14),
        Container(
          width: 24.96,
          height: 2.33,
          decoration: ShapeDecoration(
            color: AppColors.kPrimary,
            shape: const StadiumBorder(),
          ),
        ),
        const SizedBox(height: 30),
        ...options.map((e) {
          return ListTile(
            onTap: e.onTap,
            leading: e.icon != null
                ? Icon(e.icon)
                : Text(e.name,
                    style: const TextStyle(color: Colors.black, fontSize: 16)),
            title: (e.icon != null)
                ? Text(e.name,
                    style: const TextStyle(color: Colors.black, fontSize: 16))
                : null,
          );
        }),
        const SizedBox(height: 30),
      ],
    ),
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      ),
    ),
  );
}

class BottomSheetOptionModel {
  String name;
  IconData? icon;
  void Function()? onTap;

  BottomSheetOptionModel({required this.name, this.icon, required this.onTap});
}
