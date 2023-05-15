int getDifference(String busETA) {
  DateTime current = DateTime.now();
  final busTime = DateTime.parse(busETA);
  final difference = busTime.difference(current).inMinutes;

  print(busETA);
  print(busTime);
  print(current);
  print(difference);
  return difference;
}

String timeDisplay(int minutes) {
  if (minutes < 0) {
    return '5 minutes';
  }
  if (minutes <= 1) {
    return 'NOW';
  }
  return '${minutes.toString()} minutes';
}