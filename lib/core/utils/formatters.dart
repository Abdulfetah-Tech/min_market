// Common formatters and validators

import 'dart:async';
import 'dart:ui';

import 'package:intl/intl.dart';

/// Currency formatter
class CurrencyFormatter {
  static final NumberFormat _usdFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  static final NumberFormat _compactFormat = NumberFormat.compactCurrency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 0,
  );

  static String format(double amount, {bool compact = false}) {
    if (compact && amount >= 1000) {
      return _compactFormat.format(amount);
    }
    return _usdFormat.format(amount);
  }

  static String formatPrice(double price) => '\$${price.toStringAsFixed(2)}';
}

/// Date/time formatter
class DateFormatter {
  static final DateFormat _shortDate = DateFormat('MMM d, yyyy');
  static final DateFormat _fullDate = DateFormat('EEEE, MMMM d, yyyy');
  static final DateFormat _time = DateFormat('h:mm a');
  static final DateFormat _dateTime = DateFormat('MMM d, yyyy h:mm a');
  static final DateFormat _relative = DateFormat('yyyy-MM-dd');

  static String short(DateTime date) => _shortDate.format(date);
  static String full(DateTime date) => _fullDate.format(date);
  static String time(DateTime date) => _time.format(date);
  static String dateTime(DateTime date) => _dateTime.format(date);
  static String relative(DateTime date) => _relative.format(date);
}

/// Number formatter
class NumberFormatter {
  static final NumberFormat _decimal = NumberFormat('#,##0.##');
  static final NumberFormat _integer = NumberFormat('#,##0');
  static final NumberFormat _percent = NumberFormat.percentPattern();

  static String decimal(num value) => _decimal.format(value);
  static String integer(num value) => _integer.format(value);
  static String percent(double value) => _percent.format(value);
}

/// Text validators
class Validators {
  static String? required(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? minLength(String? value, int minLength, {String fieldName = 'Field'}) {
    if (value == null || value.trim().length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    return null;
  }

  static String? maxLength(String? value, int maxLength, {String fieldName = 'Field'}) {
    if (value != null && value.trim().length > maxLength) {
      return '$fieldName must be at most $maxLength characters';
    }
    return null;
  }

  static String? positiveNumber(String? value, {String fieldName = 'Value'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final number = double.tryParse(value.trim());
    if (number == null) {
      return 'Enter a valid number';
    }
    if (number <= 0) {
      return '$fieldName must be greater than 0';
    }
    return null;
  }

  static String? nonNegativeNumber(String? value, {String fieldName = 'Value'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final number = double.tryParse(value.trim());
    if (number == null) {
      return 'Enter a valid number';
    }
    if (number < 0) {
      return '$fieldName must be 0 or greater';
    }
    return null;
  }

  static String? integer(String? value, {String fieldName = 'Value'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final number = int.tryParse(value.trim());
    if (number == null) {
      return 'Enter a valid integer';
    }
    return null;
  }

  static String? combine(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }
}

/// Debouncer for search/input handling
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() {
    _timer?.cancel();
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

/// Responsive breakpoints
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;

  static int crossAxisCount(double width) {
    if (width >= desktop) return 4;
    if (width >= tablet) return 3;
    if (width >= mobile) return 2;
    return 1;
  }

  static bool isMobile(double width) => width < mobile;
  static bool isTablet(double width) => width >= mobile && width < desktop;
  static bool isDesktop(double width) => width >= desktop;
}