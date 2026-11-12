import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/logging/secret_redactor.dart';

void main() {
  test('redacts tokens, passwords, bearer, and URI userInfo', () {
    expect(
      SecretRedactor.redact('access_token=abc123 refresh_token=xyz'),
      contains('***'),
    );
    expect(
      SecretRedactor.redact('password=hunter2'),
      isNot(contains('hunter2')),
    );
    expect(
      SecretRedactor.redact('Authorization: Bearer eyJhbGciOi.payload'),
      isNot(contains('eyJhbGciOi')),
    );
    expect(
      SecretRedactor.redact('https://user:secret@host.example/path'),
      allOf(contains('https://user:***@host.example/path'), isNot(contains(':secret@'))),
    );
  });
}
