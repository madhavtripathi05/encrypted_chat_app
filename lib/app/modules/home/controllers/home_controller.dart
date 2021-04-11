import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart' hide Key;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../../../../utils.dart';

/*
 * The Advanced Encryption Standard (AES) is a symmetric encryption algorithm. 
 * As a symmetric algorithm, the same secret key is used to encrypt and decrypt. 
 * It is also a block cipher algorithm, 
 * which means the algorithm processes the data in fixed-size blocks.

  * Cipher Block Chaining (CBC) is a mode of operation where,
  * each block is combined with the previous block before it is encrypted. 
  * Since the first block doesn't have a previous block, 
  * it is combined with an Initialization Vector (IV).

  * The CBC (Cipher Block Chaining) mode provides this by using an initialization vector – IV. 
  * The IV has the same size as the block that is encrypted.
 */

/// * the plaintext is divided into blocks and needs to add padding data.
/// * First, we will use the plaintext block xor with the IV.
/// * Then CBC will encrypt the result to the cipher-text block.
/// * In the next block, we will use the encryption result to xor with plaintext block until the last block.
/// * In this mode, even if we encrypt the same plaintext block, we will get a different cipher-text block.
/// * We can decrypt the data in parallel, but it is not possible when encrypting data.
/// * If a plaintext or cipher-text block is broken, it will affect all following block.
class HomeController extends GetxController {
  static final to = Get.find<HomeController>();
  final box = GetStorage();
  var greetings = Map<String, bool>();
  File image;

  RxString currentUser = ''.obs;

  /// * The key must be exactly 128-bits, 192-bits or 256-bits (i.e. 16, 24 or 32 Bytes).
  /// * 10, 12 or 14 rounds are performed depending upon key size
  /// * This is what determines whether AES-128, AES-192 or AES-256 is being performed.
  static final key = Key.fromUtf8(
      'ThisIsTopSecretKeyOfLength32Byte'); // * AES-256 because length is 32 Bytes

  /// * The iv must be exactly 128-bits (16 Bytes) long, which is the AES block size.
  final iv = IV.fromUtf8("InitialVector16B");
  var encrypter = Encrypter(AES(key));

  WebSocketChannel channel =
      WebSocketChannel.connect(Uri.parse('ws://192.168.0.101:3210'));

  final TextEditingController msgController = TextEditingController();
  final TextEditingController userController = TextEditingController();

  changeTheme() => Get.changeTheme(
      Get.theme.brightness == Brightness.dark ? lightTheme : darkTheme);

  Future<void> checkCurrentUser() async {
    print('checkCurrentUser');
    currentUser.value = box.read('user') ?? '';
    if (currentUser.value.isNotEmpty) {
      print(currentUser.value);
      channel.sink.add(jsonEncode({
        'id': currentUser.value,
        'msg': '__new_connection__',
        'timestamp': '${DateTime.now().microsecondsSinceEpoch}'
      }));
    }
    if (currentUser.value.isEmpty) {
      print('new user');
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
                  channel.sink.add(jsonEncode({
                    'id': currentUser.value,
                    'msg': '__new_connection__',
                    'timestamp': '${DateTime.now().microsecondsSinceEpoch}',
                  }));
                  Get.back();
                },
                label: Text('Confirm'),
                icon: Icon(Icons.check),
              )
            ],
          ));
    }
  }

  String decryptMessage(String encMsg, String timestamp) {
    encrypter = Encrypter(AES(Key.fromUtf8(timestamp + timestamp)));
    String decryptedMessage =
        encrypter.decrypt(Encrypted.fromBase64(encMsg), iv: iv);
    print(decryptedMessage);
    return decryptedMessage;
  }

  @override
  void onInit() {
    super.onInit();
  }

  void sendMessage([Uint8List _image]) {
    final now = DateTime.now().microsecondsSinceEpoch.toString();
    encrypter = Encrypter(AES(Key.fromUtf8(now + now)));
    String encryptedMessage =
        encrypter.encrypt(msgController.text, iv: iv).base64;

    print(encryptedMessage);
    channel.sink.add(jsonEncode({
      'id': currentUser.value,
      'msg': encryptedMessage,
      'timestamp': now,
    }));
    msgController.clear();

    image = null;
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
