import 'package:cryptopals/cryptopals.dart' as cryptopals;
import 'package:test/test.dart';

void main() {
  test('converts hex to base64', () {
    expect(
      cryptopals.base64Encode(
        cryptopals
            .hexDecode(
              '49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d',
            )
            .toList(),
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

  test('repeating-key XOR', () {
    expect(
      cryptopals.hexEncode(
        cryptopals.xorEncrypt(
          plaintext: '''
Burning 'em, if you ain't quick and nimble
I go crazy when I hear a cymbal''',
          key: 'ICE',
        ),
      ),
      '0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f',
    );
  });
}
