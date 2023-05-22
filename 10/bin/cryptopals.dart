import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cryptopals/cryptopals.dart' as cryptopals;

void main(List<String> arguments) {
  final file = File(arguments[1]);
  final input = base64Decode(file.readAsLinesSync().join());
  final key = Uint8List.fromList(arguments[0].codeUnits);
  print(cryptopals
      .aesCbc(
        encrypt: false,
        key: key,
        input: input,
      )
      .map(String.fromCharCode)
      .join());
}
