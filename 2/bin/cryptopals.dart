import 'package:cryptopals/cryptopals.dart' as cryptopals;

void main(List<String> arguments) {
  final left = cryptopals.hexDecode(arguments[0]);
  final right = cryptopals.hexDecode(arguments[1]);
  final output = cryptopals.hexEncode(cryptopals.xorBuffers(left, right));
  print(output);
}
