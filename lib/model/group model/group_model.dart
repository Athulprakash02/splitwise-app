
class Group {
  final String? id;
  final String groupName;
  final double amount;

  Group( {
    required this.amount,
    required this.id,
    required this.groupName,
  });

  toJson() {
    return {
      // "id": id,
      "group name": groupName,
      "amount": amount,};
  }
}
