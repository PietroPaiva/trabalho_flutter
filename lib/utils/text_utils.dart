import 'package:intl/intl.dart';

String removeAccents(String input) {
  const from = 'áàâãäåéèêëíìîïóòôõöúùûüçñ';
  const to = 'aaaaaaeeeeiiiiooooouuuucn';
  final buffer = StringBuffer();
  for (final rune in input.toLowerCase().runes) {
    final char = String.fromCharCode(rune);
    final index = from.indexOf(char);
    buffer.write(index >= 0 ? to[index] : char);
  }
  return buffer.toString();
}

String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

String dateKey(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

String formatLongDate(DateTime date) {
  return capitalize(DateFormat("EEEE, d 'de' MMMM", 'pt_BR').format(date));
}