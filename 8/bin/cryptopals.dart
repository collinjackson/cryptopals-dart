import 'dart:io';
import 'dart:typed_data';

const keySizeBytes = 16;

void main(List<String> arguments) {
  final file = File(arguments[0]);
  final lines = file.readAsLinesSync();
  for (int i = 0; i < lines.length; i++) {
    final line = Uint8List.fromList(lines[i].codeUnits);
    final blocks = <Uint8List>[];
    for (int offset = 0; offset < line.length; offset += keySizeBytes) {
      final block = line.sublist(offset, offset + keySizeBytes);
      for (final previousBlock in blocks) {
        int count = 0;
        for (int blockOffset = 0; blockOffset < keySizeBytes; blockOffset++) {
          count += previousBlock[blockOffset] ^ block[blockOffset];
        }
        if (count == 0) {
          print('Match found: $i');
        }
      }
      blocks.add(block);
    }
  }
}
