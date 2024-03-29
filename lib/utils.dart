import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData(fontFamily: GoogleFonts.nunito().fontFamily);
final darkTheme = ThemeData(
    fontFamily: GoogleFonts.nunito().fontFamily, brightness: Brightness.dark);

const kSendButtonTextStyle = TextStyle(
  color: Color(0xff5bc084),
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Color(0xff5bc084), width: 2.0),
  ),
);

const kTextStyleForJson = TextStyle(
  fontSize: 14.0,
  fontWeight: FontWeight.w600,
);

const kTextStyleForJson1 = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w700,
);
const kTextFieldDecoration = InputDecoration(
  hintText: 'start typing something',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff5bc084), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff5bc084), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
