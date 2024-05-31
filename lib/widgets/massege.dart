// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// void showToast({required String message}) {
//   Fluttertoast.showToast(
//       msg: message,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.red,
//       fontSize: 16);
// }
import 'package:flutter/material.dart';

void ShowSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
