import 'package:intl/intl.dart';

/// Extension methods for DateTime
extension DateTimeExtensions on DateTime {
  /// Format date time for chat messages (e.g., "2:30 PM")
  String toChatTime() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(year, month, day);

    if (messageDate == today) {
      // Today - show time only
      return DateFormat.jm().format(this);
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      // Yesterday
      return 'Yesterday';
    } else if (now.difference(this).inDays < 7) {
      // This week - show day name
      return DateFormat.E().format(this);
    } else {
      // Older - show date
      return DateFormat.MMMd().format(this);
    }
  }

  /// Format date time for message timestamps (e.g., "Today 2:30 PM")
  String toMessageTimestamp() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(year, month, day);

    if (messageDate == today) {
      return 'Today ${DateFormat.jm().format(this)}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday ${DateFormat.jm().format(this)}';
    } else {
      return DateFormat.yMMMd().add_jm().format(this);
    }
  }
}

/// Extension methods for String
extension StringExtensions on String {
  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Check if string is a valid phone number
  bool get isValidPhoneNumber {
    final digitsOnly = replaceAll(RegExp(r'\D'), '');
    return digitsOnly.length >= 10 && digitsOnly.length <= 15;
  }

  /// Check if string is a valid OTP
  bool get isValidOTP {
    return length == 6 && RegExp(r'^\d{6}$').hasMatch(this);
  }

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Get initials from name (for avatar)
  String get initials {
    if (isEmpty) return '';

    final words = trim().split(' ');
    if (words.length == 1) {
      return words[0].substring(0, 1).toUpperCase();
    } else {
      return '${words[0].substring(0, 1)}${words[1].substring(0, 1)}'
          .toUpperCase();
    }
  }
}

/// Extension methods for Duration
extension DurationExtensions on Duration {
  /// Format duration as "MM:SS"
  String get formatTime {
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
