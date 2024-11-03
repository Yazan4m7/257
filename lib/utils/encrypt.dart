import 'package:encrypt/encrypt.dart';

String encrypt(String text){
  final key = Key.fromUtf8("SIGMA_Encryption_5ng853ld9f531g4");
  final iv = IV.fromUtf8("gm5kmd9ek3mz9dmg");
  final encrypter = Encrypter(AES(key,mode:AESMode.cbc));
  final encrypted = encrypter.encrypt(text,iv: iv);
  return encrypted.base64;
}