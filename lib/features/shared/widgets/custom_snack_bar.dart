import 'package:flutter/material.dart';

class CustomSnackBar {
  static SnackBar success(String mensaje) {
    return SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Expanded(child: Text(mensaje, style: TextStyle(color: Colors.white))),
        ],
      ),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(12),
      duration: Duration(seconds: 3),
    );
  }

  static SnackBar error(String mensaje) {
    return SnackBar(
      content: Row(
        children: [
          Icon(Icons.error, color: Colors.white),
          SizedBox(width: 8),
          Expanded(child: Text(mensaje, style: TextStyle(color: Colors.white))),
        ],
      ),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(12),
      duration: Duration(seconds: 4),
    );
  }
}