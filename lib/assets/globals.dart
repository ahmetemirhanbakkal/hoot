import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

BuildContext homeContext;
BuildContext navigatorContext;

String getDateString(DateTime date) {
  DateTime now = DateTime.now();
  if (date.year == now.year && date.month == now.month) {
    if (date.day == now.day) return 'Today';
    if (date.day == now.day - 1) return 'Yesterday';
  }
  return DateFormat.MMMMd('en').format(date);
}
