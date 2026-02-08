class Medication {
  String name;
  String time;
  bool taken;

  Medication({
    required this.name,
    required this.time,
    this.taken = false,
  });
}
