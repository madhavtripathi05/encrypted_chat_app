import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class HomeController extends GetxController {
  static final to = Get.find<HomeController>();
  var channel = WebSocketChannel.connect(Uri.parse('ws://192.168.0.103:3000'));

  final TextEditingController msgController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  sendMessage() {
    channel.sink.add(jsonEncode({'id': 'someone', 'msg': msgController.text}));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    channel.sink.close(status.goingAway);
  }
}

class UserProvider extends GetConnect {
  GetSocket userMessages() {
    return socket('ws://192.168.0.103:3000');
  }
}
