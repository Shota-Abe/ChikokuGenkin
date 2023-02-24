class Schedule {
  String title;
  DateTime startAt;
  DateTime endAt;
  DateTime getUpTime;
  String? memo;

  Schedule(
      {required this.title,
      required this.startAt,
      required this.endAt,
      required this.getUpTime,
      required this.memo});
}
