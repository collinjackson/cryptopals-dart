import 'dart:typed_data';

import 'package:pointycastle/block/aes.dart' as pc;
import 'package:pointycastle/block/modes/ecb.dart' as pc;
import 'package:pointycastle/pointycastle.dart' as pc;

Uint8List xorBuffers(Uint8List left, Uint8List right) {
  assert(left.length == right.length);
  final output = Uint8List(left.length);
  for (int i = 0; i < left.length; i++) {
    output[i] = left[i] ^ right[i];
  }
  return output;
}

Uint8List aesCbc({
  required bool encrypt,
  required Uint8List key,
  required Uint8List input,
}) {
  final cipher = pc.ECBBlockCipher(pc.AESEngine())
    ..init(encrypt, pc.KeyParameter(key));
  final output = Uint8List(input.length), keyLength = key.length;
  assert(input.length % keyLength == 0);
  var right = Uint8List.fromList(List.filled(keyLength, 0));
  for (int offset = 0; offset < output.length; offset += keyLength) {
    if (encrypt) {
      final left = input.sublist(offset, offset + key.length);
      final inputBlock = xorBuffers(left, right);
      cipher.processBlock(inputBlock, 0, output, offset);
      right = output.sublist(offset, offset + keyLength);
    } else {
      // decrypt
      final left = Uint8List(keyLength);
      cipher.processBlock(input, offset, left, 0);
      output.setRange(offset, offset + keyLength, xorBuffers(left, right));
      right = input.sublist(offset, offset + keyLength);
    }
  }
  return output;
}
