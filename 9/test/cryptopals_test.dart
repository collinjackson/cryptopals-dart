import 'dart:typed_data';

import 'package:cryptopals/cryptopals.dart' as cryptopals;
import 'package:test/test.dart';

void main() {
  test('pads blocks', () {
    expect(
      cryptopals.padBlock(
        Uint8List.fromList('YELLOW SUBMARINE'.codeUnits),
        length: 20,
      ),
      'YELLOW SUBMARINE\x04\x04\x04\x04'.codeUnits,
    );
  });
}