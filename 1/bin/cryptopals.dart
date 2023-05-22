import 'package:cryptopals/cryptopals.dart' as cryptopals;

void main(List<String> arguments) {
  final input = cryptopals.decodeHex(arguments[0]);
  final output = cryptopals.base64Encode(input.toList());
  print(output);
}
