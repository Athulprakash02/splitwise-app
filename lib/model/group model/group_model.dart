
class Group {
  final String? id;
  final String groupName;

  Group({
    required this.id,
    required this.groupName,
  });

  toJson() {
    return {
      // "id": id,
      "group name": groupName};
  }
}
