import 'dart:typed_data';

import 'package:pointycastle/block/aes.dart' as pointycastle;
import 'package:pointycastle/block/modes/ecb.dart' as pointycastle;
import 'package:pointycastle/pointycastle.dart' as pointycastle;

Uint8List decryptAESECB128({
  required Uint8List key,
  required Uint8List input,
}) {
  final cipher = pointycastle.ECBBlockCipher(pointycastle.AESEngine())
    ..init(false, pointycastle.KeyParameter(key));
  final output = Uint8List(input.length);
  for (var offset = 0; offset < output.length;) {
    offset += cipher.processBlock(input, offset, output, offset);
  }
  return output;
}