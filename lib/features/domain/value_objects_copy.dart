import 'package:dartz/dartz.dart';

import '../../../utils/value_validators.dart';
import 'failures.dart';
import 'value_objects.dart';

class PTName extends ValueObject<String> {
  factory PTName(String input) {
    return PTName._(
      validateStringNotEmpty(input).flatMap(validatePTName),
    );
  }

  const PTName._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}

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

class IdKaryawan extends ValueObject<String> {
  factory IdKaryawan(String input) {
    return IdKaryawan._(
      validateStringNotEmpty(input).flatMap(validateIdKaryawan),
    );
  }

  const IdKaryawan._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}

class NoHP extends ValueObject<String> {
  factory NoHP(String input) {
    return NoHP._(
      validateStringNotEmpty(input).flatMap(validateNoHP),
    );
  }

  const NoHP._(this.value);

  @override
  final Either<ValueFailure<String>, String> value;
}

class Nama extends ValueObject<String> {
  factory Nama(String input) {
    return Nama._(
      validateStringNotEmpty(input).flatMap(validateNama),
    );
  }

  const Nama._(this.value);

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
      validateStringNotEmpty(input),
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
