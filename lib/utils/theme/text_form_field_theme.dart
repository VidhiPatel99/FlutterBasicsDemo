import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

mixin TextFromFieldTheme {
  static final textFieldBorder =
      OutlineInputBorder(borderRadius: BorderRadius.circular(8.0));
  static final textFieldContentPadding =
      EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0);
  static final textFieldTextStyle =
      TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  static final textFieldInputDecoration = InputDecoration(
      contentPadding: TextFromFieldTheme.textFieldContentPadding,
      border: TextFromFieldTheme.textFieldBorder);
}
