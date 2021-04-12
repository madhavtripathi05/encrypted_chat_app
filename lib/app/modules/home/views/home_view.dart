import 'dart:convert';

import 'package:encrypted_chat_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../controllers/home_controller.dart';

final hc = HomeController.to;

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
        centerTitle: true,
        backgroundColor: Color(0xff5bc084),
        actions: [
          IconButton(
              icon: Icon(FlutterIcons.theme_light_dark_mco),
              onPressed: hc.changeTheme),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: hc.msgController,
                        decoration: kTextFieldDecoration,
                      ),
                    ),
                    IconButton(
                      onPressed: hc.sendMessage,
                      icon: Icon(
                        FlutterIcons.send_mdi,
                        color: Color(0xff5bc084),
                      ),
                    ),
                  ],
                ),
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
        if (!snapshot.hasData)
          return Center(child: Text('Start typing something...'));

        final json = snapshot.data;

        final messages = jsonDecode(json);

        List<MessageBubble> messageBubbles = [];

        for (var messageObj in messages['messages']) {
          final message = jsonDecode(messageObj);
          if (message['msg'] == '__new_connection__') {
            print('${message['id']} just joined the chat!');
          } else {
            final messageText =
                hc.decryptMessage(message['msg'], message['timestamp']);
            final messageSender = message['id'];
            final timestamp = message['timestamp'];
            final parsedDateTime =
                DateTime.fromMicrosecondsSinceEpoch(int.tryParse(timestamp));

            final timeLeftInSeconds =
                DateTime.now().difference(parsedDateTime).inSeconds;
            final time =
                DateTime.now().subtract(Duration(seconds: timeLeftInSeconds));

            final messageBubble = MessageBubble(
              text: messageText,
              sender: messageSender,
              time: time,
              isMe: hc.currentUser.value == messageSender,
            );
            messageBubbles.add(messageBubble);
          }
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
  MessageBubble({this.text, this.sender, this.time, this.isMe});

  final String text;
  final String sender;
  final DateTime time;
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
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff5bc084),
            ),
          ).marginOnly(bottom: 5),
          Material(
            borderRadius: BorderRadius.only(
              topLeft: isMe ? Radius.circular(30) : Radius.zero,
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
              topRight: !(isMe) ? Radius.circular(30) : Radius.zero,
            ),
            elevation: 5.0,
            color: isMe ? Color(0xff5bc084) : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14.0,
                  color: isMe ? Colors.white : Color(0xff5bc084),
                ),
              ),
            ),
          ),
          Text(
            '${timeago.format(time)}',
            style: TextStyle(
              fontSize: 8.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ).marginOnly(right: 3, top: 5),
        ],
      ),
    );
  }
}
