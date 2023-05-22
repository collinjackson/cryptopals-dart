import 'dart:convert' as convert;
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
    buffer.write(char.toRadixString(16));
  }
  return buffer.toString();
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