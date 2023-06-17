import 'package:flutter/material.dart';

class TextBoxBorder{
  static OutlineInputBorder txtBorder(){
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(
          color: Color(0xFFa7e1dc),
          width: 3,
        )
    );
  }

  static OutlineInputBorder txtFocus(){
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(
          color:Color(0xFFa7e1dc),
          width: 3,
        )
    );
  }
}