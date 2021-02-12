import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.blue,
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
    top: BorderSide(color: Colors.blue, width: 2.0),
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
  hintText: 'something',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
