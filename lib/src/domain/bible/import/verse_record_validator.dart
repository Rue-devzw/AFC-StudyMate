class VerseRecordValidator {
  static List<String> validate(Map<String, dynamic> json) {
    final errors = <String>[];

    if (json['bookId'] == null || json['bookId'] is! int) {
      errors.add('`bookId` must be an integer between 1 and 66.');
    } else {
      final value = json['bookId'] as int;
      if (value < 1 || value > 66) {
        errors.add('`bookId` must be between 1 and 66.');
      }
    }

    if (json['chapter'] == null || json['chapter'] is! int) {
      errors.add('`chapter` must be a positive integer.');
    } else if ((json['chapter'] as int) < 1) {
      errors.add('`chapter` must be greater than 0.');
    }

    if (json['verse'] == null || json['verse'] is! int) {
      errors.add('`verse` must be a positive integer.');
    } else if ((json['verse'] as int) < 1) {
      errors.add('`verse` must be greater than 0.');
    }

    if (json['text'] == null || json['text'] is! String) {
      errors.add('`text` must be a string.');
    }

    return errors;
  }
}
