import 'package:cryptopals/cryptopals.dart' as cryptopals;
import 'package:test/test.dart';

void main() {
  test('converts hex to base64', () {
    expect(
      cryptopals.base64Encode(
        cryptopals.decodeHex(
          '49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d',
        ).toList(),
      ),
      'SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t',
    );
  });
}
