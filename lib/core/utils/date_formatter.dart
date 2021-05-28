import 'package:intl/intl.dart';

String ddMMyyyy(DateTime dateTime) {
  if (dateTime == null) return '-';
  return (DateFormat('dd/MM/yyyy').format(dateTime));
}
