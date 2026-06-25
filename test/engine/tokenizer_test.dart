import 'package:flutter_test/flutter_test.dart';
import 'package:mycalculator/core/engine/token.dart';
import 'package:mycalculator/core/engine/tokenizer.dart';

void main() {
  group('Tokenizer', () {
    test('tokenizes a simple addition', () {
      final tokens = Tokenizer.tokenize('1+2');
      expect(tokens.map((t) => t.type).toList(), [
        TokenType.number,
        TokenType.plus,
        TokenType.number,
      ]);
      expect(tokens[0].value, '1');
      expect(tokens[2].value, '2');
    });

    test('tokenizes decimal numbers', () {
      final tokens = Tokenizer.tokenize('3.14+0.5');
      expect(tokens[0].value, '3.14');
      expect(tokens[2].value, '0.5');
    });

    test('recognises unary minus at expression start', () {
      final tokens = Tokenizer.tokenize('-5');
      expect(tokens[0].type, TokenType.function);
      expect(tokens[0].value, 'neg');
    });

    test('recognises unary minus after left paren', () {
      final tokens = Tokenizer.tokenize('(-5)');
      expect(tokens[1].value, 'neg');
    });

    test('binary minus after a number stays as minus', () {
      final tokens = Tokenizer.tokenize('5-3');
      expect(tokens[1].type, TokenType.minus);
    });

    test('tokenizes function calls', () {
      final tokens = Tokenizer.tokenize('sin(30)');
      expect(tokens[0].type, TokenType.function);
      expect(tokens[0].value, 'sin');
    });

    test('tokenizes constants', () {
      final tokens = Tokenizer.tokenize('pi');
      expect(tokens[0].type, TokenType.constant);
      expect(tokens[0].value, 'pi');
    });

    test('tokenizes unicode pi', () {
      final tokens = Tokenizer.tokenize('π');
      expect(tokens[0].type, TokenType.constant);
      expect(tokens[0].value, 'pi');
    });

    test('tokenizes factorial', () {
      final tokens = Tokenizer.tokenize('5!');
      expect(tokens[1].type, TokenType.factorial);
    });

    test('tokenizes power operator', () {
      final tokens = Tokenizer.tokenize('2^10');
      expect(tokens[1].type, TokenType.power);
    });

    test('tokenizes comma', () {
      final tokens = Tokenizer.tokenize('log(2,8)');
      expect(tokens.where((t) => t.type == TokenType.comma).length, 1);
    });

    test('throws on unknown identifier', () {
      expect(
        () => Tokenizer.tokenize('foo(1)'),
        throwsA(isA<TokenizerException>()),
      );
    });

    test('throws on unexpected character', () {
      expect(
        () => Tokenizer.tokenize('1@2'),
        throwsA(isA<TokenizerException>()),
      );
    });

    test('ignores spaces', () {
      final tokens = Tokenizer.tokenize('1 + 2');
      expect(tokens.length, 3);
    });
  });
}
