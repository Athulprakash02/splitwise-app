
class Group {
  final String? id;
  final String groupName;

  Group({
     this.id,
    required this.groupName,
  });

  toJson() {
    return {
      // "id": id,
      "group name": groupName};
  }
}
