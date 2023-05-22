import 'dart:convert' as convert;
import 'dart:math' as math;
import 'dart:typed_data';

String base64Encode(List<int> bytes) => convert.base64Encode(bytes);

Uint8List hexDecode(String input) {
  Iterable<int> _hexDecodeIterable(String input) sync* {
    for (int i = 0; i < input.length; i += 2) {
      yield int.parse(input.substring(i, i + 2), radix: 16);
    }
  }

  return Uint8List.fromList(_hexDecodeIterable(input).toList());
}

String hexEncode(Uint8List input) {
  StringBuffer buffer = StringBuffer();
  for (int char in input) {
    buffer.write(char.toRadixString(16).padLeft(2, '0'));
  }
  return buffer.toString();
}

int hammingDistance(Uint8List left, Uint8List right) {
  assert(left.length == right.length);
  var distance = 0;
  for (int i = 0; i < left.length; i++) {
    var xor = left[i] ^ right[i];
    while (xor > 0) {
      distance += xor & 1;
      xor >>= 1;
    }
  }
  return distance;
}

Uint8List xorBuffers(Uint8List left, Uint8List right) {
  if (left.length != right.length) {
    throw AssertionError('Lengths must be the same');
  }
  Uint8List output = Uint8List(left.length);
  for (int i = 0; i < left.length; i++) {
    output[i] = left[i] ^ right[i];
  }
  return output;
}

Uint8List xorEncrypt({required String key, required String plaintext}) {
  Uint8List output = Uint8List(plaintext.length);
  for (int i = 0; i < output.length; i++) {
    output[i] = plaintext.codeUnitAt(i) ^ key.codeUnits[i % key.length];
  }
  return output;
}

Uint8List xorDecrypt({required Uint8List key, required Uint8List ciphertext}) {
  Uint8List output = Uint8List(ciphertext.length);
  for (int i = 0; i < output.length; i++) {
    output[i] = ciphertext[i] ^ key[i % key.length];
  }
  return output;
}

int scoreText(Uint8List text) {
  var score = 0;
  for (int char in text) {
    final upper = String.fromCharCode(char).toUpperCase();
    score += letterFrequencies[upper] ?? -100;
  }
  return score;
}

int bestSingleByteKey(Uint8List input) {
  final output = Uint8List(input.length);
  var bestScore = 0, bestKey = 0;
  for (int key = 0; key < 256; key++) {
    for (var index = 0; index < output.length; index++) {
      output[index] = input[index] ^ key;
    }
    final score = scoreText(output);
    if (score > bestScore) {
      bestScore = score;
      bestKey = key;
    }
  }
  return bestKey;
}

const Map<String, int> letterFrequencies = {
  ' ': 40000,
  'E': 21912,
  'T': 16587,
  'A': 14810,
  'O': 14003,
  'I': 13318,
  'N': 12666,
  'S': 11450,
  'R': 10977,
  'H': 10795,
  'D': 7874,
  'L': 7253,
  'U': 5246,
  'C': 4943,
  'M': 4761,
  'F': 4200,
  'Y': 3853,
  'W': 3819,
  'G': 3693,
  'P': 3316,
  'B': 2715,
  'V': 2019,
  'K': 1257,
  'X': 315,
  'Q': 205,
  'J': 188,
  'Z': 128,
};
