/// formatClock formats [time] in local time as `HH:mm`, such as "09:05".
String formatClock(DateTime time) {
  final local = time.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(local.hour)}:${two(local.minute)}';
}
