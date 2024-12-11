import 'package:flutter/foundation.dart';

const bool isLogEnabled = false;

//Log function enable
showLog(message) {
  if (isLogEnabled) {
    if (kDebugMode) {
      print("DEBUG: {$message}");
    }
  } else {}
}


//Email Validation
final emailEx = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');






