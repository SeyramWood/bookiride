class TripType {
  final bool today;
  final bool scheduled;
  final bool completed;

  TripType(
      {required this.today, required this.scheduled, required this.completed});

  Map toJson() {
    return {
      'today': today,
      'scheduled': scheduled,
      'completed': completed,
    };
  }
}
