import 'dart:io';
import 'package:flutter/services.dart';

void closeApp(){
  if (Platform.isAndroid)
    SystemNavigator.pop();
  else
    exit(0);
}