import 'dart:convert' as convert;

String base64Encode(List<int> bytes) {
  return convert.base64Encode(bytes);
}

Iterable<int> decodeHex(String input) sync* {
  for(int i = 0; i < input.length; i += 2) {
    // If we wanted to be more low level, we could do
    // `input.codeUnitAt(index) - '0'.codeUnitAt(0)`
    yield int.parse(input.substring(i, i + 2), radix: 16);
  }
}