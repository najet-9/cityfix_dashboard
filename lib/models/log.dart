class AdminLog {
  final String time;
  final String admin;
  final String action;
  final String target;
  final String ip;

  AdminLog({
    required this.time,
    required this.admin,
    required this.action,
    required this.target,
    required this.ip,
  });
}
