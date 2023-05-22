import 'dart:typed_data';

import 'package:pointycastle/block/aes.dart' as pc;
import 'package:pointycastle/block/modes/ecb.dart' as pc;
import 'package:pointycastle/pointycastle.dart' as pc;

// seeded deterministically to make the tests deterministic
final random = pc.SecureRandom('Fortuna')..seed(pc.KeyParameter(Uint8List(32)));

Uint8List xorBuffers(Uint8List left, Uint8List right) {
  assert(left.length == right.length);
  final output = Uint8List(left.length);
  for (int i = 0; i < left.length; i++) {
    output[i] = left[i] ^ right[i];
  }
  return output;
}

enum EncryptionMode {
  cbc,
  ecb,
  ;
}

class OracleOutput {
  OracleOutput(this.list, this.mode);
  final Uint8List list;
  final EncryptionMode mode;
}

final _key = randomKey();

OracleOutput encryptionOracle(Uint8List input, { EncryptionMode? mode }) {
  final startBytes = 5 + random.nextUint8() % 6;
  final endBytes = 5 + random.nextUint8() % 6;
  final baseLength = startBytes + input.length + endBytes;
  final finalPadding = 16 - baseLength % 16;
  mode ??=
      (random.nextUint8() % 2 == 0) ? EncryptionMode.cbc : EncryptionMode.ecb;
  final paddedInput = Uint8List.fromList(
    List<int>.generate(
      baseLength + finalPadding,
      (index) {
        if (index >= startBytes && index < startBytes + input.length) {
          return input[index - startBytes];
        } else {
          return 0; // should the bytes be random?
        }
      },
    ),
  );

  Uint8List output;
  switch (mode) {
    case EncryptionMode.ecb:
      output = aesEcb(encrypt: true, key: _key, input: paddedInput);
      break;
    case EncryptionMode.cbc:
      final iv = randomKey();
      output = aesCbc(encrypt: true, key: _key, input: paddedInput, iv: iv);
      break;
  }
  assert(output.length > _key.length);
  return OracleOutput(output, mode);
}

/// Guess whether ecb or cbc were used to generate output.
///
/// The output must be at least 48 bytes.
EncryptionMode guessMode(Uint8List output) {
  assert(output.length > 48);
  for (int offset = 16; offset < 32; offset++) {
    if (output[offset] != output[offset + 16]) {
      return EncryptionMode.cbc;
    }
  }
  return EncryptionMode.ecb;
}

Uint8List randomKey() {
  return Uint8List.fromList(
    List<int>.generate(16, (_) => random.nextUint8()),
  );
}

Uint8List aesEcb(
    {required bool encrypt, required Uint8List key, required Uint8List input}) {
  final Uint8List output = Uint8List(input.length);
  final cipher = pc.ECBBlockCipher(pc.AESEngine())
    ..init(true /* encrypt */, pc.KeyParameter(key));
  for (int offset = 0; offset < input.length; offset += key.length) {
    cipher.processBlock(input, offset, output, offset);
  }
  return output;
}

Uint8List aesCbc({
  required bool encrypt,
  required Uint8List key,
  required Uint8List input,
  Uint8List? iv,
}) {
  final cipher = pc.ECBBlockCipher(pc.AESEngine())
    ..init(encrypt, pc.KeyParameter(key));
  final keyLength = key.length;
  final output = Uint8List(input.length);
  var right = iv ?? Uint8List.fromList(List.filled(keyLength, 0));
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
