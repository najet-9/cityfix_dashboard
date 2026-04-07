class Report {
  final String id;
  final String category;
  final String desc;
  final String address;
  final String status;
  final int confirmations;
  final String date;

  Report({
    required this.id,
    required this.category,
    required this.desc,
    required this.address,
    required this.status,
    required this.confirmations,
    required this.date,
  });
}
