import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypted_chat_app/utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

final hc = HomeController.to;

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: hc.msgController,
                      decoration: kTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: hc.sendMessage,
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: hc.channel.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final json = snapshot.data;

        final messages = jsonDecode(json);

        List<MessageBubble> messageBubbles = [];

        for (var messageObj in messages['messages']) {
          final message = jsonDecode(messageObj);

          final messageText = message['msg'];
          final messageSender = message['id'];

          final messageBubble = MessageBubble(
            text: messageText,
            sender: messageSender,
            isMe: true, //currentUser == messageSender
          );
          messageBubbles.add(messageBubble);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            children: messageBubbles.reversed.toList(),
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.sender, this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(fontSize: 10.0, color: Colors.blue),
          ),
          Material(
              borderRadius: BorderRadius.only(
                topLeft: isMe ? Radius.circular(30) : Radius.zero,
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
                topRight: !(isMe) ? Radius.circular(30) : Radius.zero,
              ),
              elevation: 5.0,
              color: isMe ? Colors.blue : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: isMe ? Colors.white : Colors.blue,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
