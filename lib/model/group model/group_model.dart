
class Group {
  final String? id;
  final String name;

  Group({
     this.id,
    required this.name,
  });

  toJson() {
    return {
      // "id": id,
      "name": name};
  }
}
