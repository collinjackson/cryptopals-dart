import 'dart:typed_data';

Uint8List padBlock(Uint8List block, {
  required int length,
  String padding = '\x04',
}) {
  assert(length >= block.length);
  return Uint8List.fromList(List<int>.generate(length, (index) {
    if (index < block.length) return block[index];
    return padding.codeUnitAt(0);
  }));
}