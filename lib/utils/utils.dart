import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Utils {
  static String formatDate(Timestamp time) {
    final myTimeFormat = DateFormat('d/m/y');

    return myTimeFormat.format((time).toDate());
  }


  

}
