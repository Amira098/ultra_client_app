import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

Future<File?> pickImage({required ImageSource source}) async {
  final picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 50);
  if(pickedFile != null)
  return File(pickedFile.path);
  return null;
}

String? getImageName({required File? image}) {
  if(image != null)
  return image.path.split('/').last;
  return null;
}
String getImageMimeType({required File image}){
  final mimeTypeData =
  lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])!.split('/');
  return mimeTypeData[1];
}

Future<String> encodeImage(File imageFile) async {
  List<String> items = [];
  final mimeTypeData =
  lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8])!.split('/');
  late List<int> imageBytes;
  if (imageFile != null) {
    imageBytes = await imageFile.readAsBytes();
  }
  print(imageBytes);
  //String base64Image = base64.encode(imageBytes);
String base64Image = 'data:image/${mimeTypeData[1]};base64,' +'${base64.encode(imageBytes)}';
  return base64Image;
}
