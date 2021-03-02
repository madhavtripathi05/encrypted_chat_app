import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart' hide Key;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../../../../utils.dart';

class HomeController extends GetxController {
  static final to = Get.find<HomeController>();
  final box = GetStorage();
  var greetings = Map<String, bool>();

  RxString currentUser = ''.obs;

  static final key = Key.fromUtf8('ThisIsATopSecretKeyOfLength32bit');
  final iv = IV.fromUtf8("InitialVector16b");
  final encrypter = Encrypter(AES(key));

  WebSocketChannel channel =
      WebSocketChannel.connect(Uri.parse('ws://192.168.0.103:3000'));

  final TextEditingController msgController = TextEditingController();
  final TextEditingController userController = TextEditingController();

  changeTheme() {
    Get.changeTheme(
        Get.theme.brightness == Brightness.dark ? lightTheme : darkTheme);
  }

  Future<void> checkCurrentUser() async {
    currentUser.value = box.read('user') ?? '';
    if (currentUser.value.isNotEmpty) {
      channel.sink.add(
          jsonEncode({'id': currentUser.value, 'msg': '__new_connection__'}));
    }
    if (currentUser.value.isEmpty) {
      Get.defaultDialog(
          barrierDismissible: false,
          title: 'Enter your username',
          content: Column(
            children: [
              TextField(controller: userController),
              TextButton.icon(
                onPressed: () {
                  currentUser.value = userController.text;
                  box.write('user', currentUser.value);
                  channel.sink.add(jsonEncode(
                      {'id': currentUser.value, 'msg': '__new_connection__'}));
                  Get.back();
                },
                label: Text('Confirm'),
                icon: Icon(Icons.check),
              )
            ],
          ));
    }
  }

  String decryptMessage(String encMsg) {
    String decryptedMessage =
        encrypter.decrypt(Encrypted.fromBase64(encMsg), iv: iv);
    print(decryptedMessage);
    return decryptedMessage;
  }

  @override
  void onInit() {
    super.onInit();
  }

  sendMessage() {
    String encryptedMessage =
        encrypter.encrypt(msgController.text, iv: iv).base64;
    channel.sink
        .add(jsonEncode({'id': currentUser.value, 'msg': encryptedMessage}));
    msgController.clear();
  }

  @override
  void onReady() async {
    await checkCurrentUser();
    super.onReady();
  }

  @override
  void onClose() {
    channel.sink.close(status.goingAway);
  }
}
