import 'dart:typed_data';
import 'package:cryptopals/cryptopals.dart' as cryptopals;

void main(List<String> arguments) {
  final input = cryptopals.hexDecode(arguments[0]);
  final output = Uint8List(input.length);
  var bestScore = 0, bestKey = 0, bestMessage = '';
  for (int key = 0; key < 256; key++) {
    for (var index = 0; index < output.length; index++) {
      output[index] = input[index] ^ key;
    }
    final score = cryptopals.scoreText(output);
    if (score > bestScore) {
      bestScore = score;
      bestKey = key;
      bestMessage = output.map(String.fromCharCode).join();
    }
  }
  print('Key: $bestKey');
  print('Message: $bestMessage');
}
