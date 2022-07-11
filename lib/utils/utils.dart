// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Utils {
  static String formatDate(Timestamp time) {
    final myTimeFormat = DateFormat('d/M/y');

    return myTimeFormat.format((time).toDate());
  }
}
