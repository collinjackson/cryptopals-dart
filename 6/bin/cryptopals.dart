import 'dart:typed_data';
import 'dart:math' as math;
import 'dart:convert';
import 'dart:io';
import 'package:cryptopals/cryptopals.dart' as cryptopals;

void main(List<String> arguments) {
  final filename = arguments[0];
  final file = File(filename);
  final encodedContents = file.readAsLinesSync().join('');
  final contents = base64Decode(encodedContents);
  final Map<int, double> distances = {};
  for (int keySize = 2; keySize <= 40; keySize++) {
    final first = contents.sublist(0, keySize);
    final second = contents.sublist(keySize, keySize * 2);
    distances[keySize] = cryptopals.hammingDistance(first, second) / keySize;
  }
  final sortedDistances = Map.fromEntries(
    distances.entries.toList()..sort((e1, e2) => e1.value.compareTo(e2.value)),
  );
  print('Best candidates: $sortedDistances');
  for (final keySize in sortedDistances.keys) {
    final blocks = <Uint8List>[];
    for (int i = 0; i + keySize <= contents.length; i += keySize) {
      blocks.add(contents.sublist(i, i + keySize));
    }
    final bestBytes = Uint8List(keySize);
    for (int keyByte = 0; keyByte < keySize; keyByte++) {
      final transposedBlock = Uint8List(blocks.length);
      for (int j = 0; j < blocks.length; j++) {
        transposedBlock[j] = blocks[j][math.min(keyByte, blocks[j].length)];
      }
      final bestByte = cryptopals.bestSingleByteKey(transposedBlock);
      bestBytes[keyByte] = bestByte;
    }
    print('$keySize-byte key: ${bestBytes.map(String.fromCharCode).join()}');
    final message = cryptopals.xorDecrypt(key: bestBytes, ciphertext: contents);
    // Only accept key if score is good
    if (cryptopals.scoreText(message) / message.length > 10000) {
      print('Message: ${message.map(String.fromCharCode).join()}');
    }
  }
}
