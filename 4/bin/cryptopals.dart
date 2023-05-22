import 'dart:typed_data';
import 'dart:io';
import 'package:cryptopals/cryptopals.dart' as cryptopals;

void main(List<String> arguments) {
  final filename = arguments[0];
  final file = File(filename);
  final contents = file.readAsLinesSync();
  var bestScore = 0, bestKey = 0, bestMessage = '';
  for (final line in contents) {
    final input = cryptopals.hexDecode(line);
    for (int key = 0; key < 256; key++) {
      final output = Uint8List(line.length);
      for (int index = 0; index < input.length; index++) {
        output[index] = input[index] ^ key;
      }
      final score = cryptopals.scoreText(output);
      if (score > bestScore) {
        bestScore = score;
        bestKey = key;
        bestMessage = output.map(String.fromCharCode).join();
      }
    }
  }
  print('Key: $bestKey');
  print('Message: $bestMessage');
}
