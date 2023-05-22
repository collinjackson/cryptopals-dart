import 'dart:typed_data';

import 'package:cryptopals/cryptopals.dart';
import 'package:test/test.dart';

void main() {
  test('guesses ECB mode', () {
    final input = Uint8List.fromList(List<int>.filled(256, 0));
    final output = encryptionOracle(input, mode: EncryptionMode.ecb).list;
    expect(guessMode(output), EncryptionMode.ecb);
  });

  test('guesses CBC mode', () {
    final input = Uint8List.fromList(List<int>.filled(256, 0));
    final output = encryptionOracle(input, mode: EncryptionMode.cbc).list;
    expect(guessMode(output), EncryptionMode.cbc);
  });

  test('guesses random mode', () {
    Uint8List input = Uint8List.fromList(List<int>.filled(256, 0));
    for (int i = 0; i < 10; i++) {
      final output = encryptionOracle(input);
      expect(guessMode(output.list), output.mode);
    }
  });
}
