import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cryptopals/cryptopals.dart' as cryptopals;

void main(List<String> arguments) {
  final file = File(arguments[1]);
  final output = cryptopals.decryptAESECB128(
    key: Uint8List.fromList(arguments[0].codeUnits),
    input: base64Decode(file.readAsLinesSync().join('')),
  );
  print(output.map(String.fromCharCode).join());
}
