import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:mime/mime.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openMap(double latitude, double longitude) async {
  String googleUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  if (await canLaunch(googleUrl)) {
    await launch(googleUrl);
  } else {
    throw 'Could not open the map.';
  }
}

Future<void> openUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not open the map.';
  }
}

Future<bool> isConnectedToInternet() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
    return false;
  } on SocketException catch (_) {
    return false;
  }
}

double roundNumbers(double number) {
  return double.parse((number).toStringAsFixed(2));
}

String formatNumbers(double number) {
  List<String> parts =
  (double.parse((number).toStringAsFixed(2))).toString().split('.');
  if (parts.length == 1) {
    parts[0] = '${parts[0]}.00';
    return parts[0];
  } else if (parts.length == 2) {
    if (parts[1].length == 1) {
      parts[1] = '${parts[1]}0';
      return '${parts[0]}.${parts[1]}';
    }
    return roundNumbers(number).toString();
  }
  return roundNumbers(number).toString();
}

String roundNumberAsString(double number) {
  return  number.toStringAsFixed(2);
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}