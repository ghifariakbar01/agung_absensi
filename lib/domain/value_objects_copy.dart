import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/domain/value_objects.dart';

import '../../../utils/value_validators.dart';
import 'failures.dart';

class Email extends ValueObject<String> {
  factory Email(String input) {
    return Email._(
      validateStringNotEmpty(input).flatMap(validateEmail),
    );
  }

  const Email._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}

class UserId extends ValueObject<String> {
  factory UserId(String input) {
    return UserId._(validateStringNotEmpty(input));
  }

  const UserId._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}

class Password extends ValueObject<String> {
  factory Password(String input) {
    return Password._(
      validatePassword(input),
    );
  }

  const Password._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}

class UserToken extends ValueObject<String> {
  factory UserToken(String input) {
    return UserToken._(
      validateStringNotEmpty(input),
    );
  }

  const UserToken._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}
