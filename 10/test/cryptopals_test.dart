import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptopals/cryptopals.dart' as cryptopals;
import 'package:test/test.dart';

void main() {
  final key = Uint8List.fromList('YELLOW SUBMARINE'.codeUnits);
  test('decrypts what was encrypted', () {
    final input = 'ABCDEFGHIJKLMNOPABCDEFGHIJKLMNOP';
    expect(
      cryptopals
          .aesCbc(
            encrypt: false,
            key: key,
            input: cryptopals.aesCbc(
              encrypt: true,
              key: key,
              input: Uint8List.fromList(input.codeUnits),
            ),
          )
          .map(String.fromCharCode)
          .join(),
      input,
    );
  });

  test('decrypts 10.txt', () {
    final input = base64Decode(File('10.txt').readAsLinesSync().join());
    expect(
        cryptopals
            .aesCbc(
              encrypt: false,
              key: key,
              input: input,
            )
            .map(String.fromCharCode)
            .join(),
        endsWith('Play that funky music \n\x04\x04\x04\x04'));
  });
}
