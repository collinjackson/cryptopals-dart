import 'package:cryptopals/cryptopals.dart' as cryptopals;
import 'package:test/test.dart';

void main() {
  test('converts hex to base64', () {
    expect(
      cryptopals.base64Encode(
        cryptopals.hexDecode(
          '49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d',
        ).toList(),
      ),
      'SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t',
    );
  });

  test('XORs two equal length buffers', () {
    expect(
      cryptopals.hexEncode(
        cryptopals.xorBuffers(
          cryptopals.hexDecode('1c0111001f010100061a024b53535009181c'),
          cryptopals.hexDecode('686974207468652062756c6c277320657965'),
        ),
      ),
      '746865206b696420646f6e277420706c6179',
    );
  });
}
