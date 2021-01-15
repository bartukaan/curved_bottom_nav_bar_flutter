import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FlushbarHelper {
  static FlushbarHelper _singleton = FlushbarHelper._internal();
  FlushbarHelper._internal();

  factory FlushbarHelper() {
    return _singleton;
  }

  static getFlushBar(String title, String message, BuildContext context) {
    return Flushbar(
      title: '',
      message: '',
      icon: Icon(
        Icons.info_outline,
        color: Colors.white,
        size: 40.0,
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      //leftBarIndicatorColor: Colors.white,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.white,
      titleText: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.white,
            fontFamily: "Helvetica"),
      ),
      messageText: Text(
        message, // sayacList.length.toString() + " sayaç bulundu",
        style: TextStyle(
            fontSize: 18.0, color: Colors.white70, fontFamily: "Helvetica"),
      ),
    ).show(context);
  }

  static getFlushBarWithButton(
      String title, String message, BuildContext context) {
    return Flushbar(
      title: '',
      message: '',
      icon: Icon(
        Icons.info_outline,
        color: Colors.white,
        size: 40.0,
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 5),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      mainButton: FlatButton(
        onPressed: () {},
        child: Text(
          "İşlemi İptal Et",
          style: TextStyle(color: Colors.red),
        ),
      ),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.red,
      titleText: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.white,
            fontFamily: "Helvetica"),
      ),
      messageText: Text(
        message,
        style: TextStyle(
            fontSize: 18.0, color: Colors.white70, fontFamily: "Helvetica"),
      ),
    ).show(context);
  }
}
