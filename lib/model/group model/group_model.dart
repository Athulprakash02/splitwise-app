class Group {
  final String? id;
  final String groupName;
  final double amount;
  final String imageAvatar;
  final String path;
  final double amountPersonOne;
  final double amountPersonTwo;
  final double amountPersonThree;

  Group({
    required this.amount,
    required this.id,
    required this.imageAvatar,
    required this.path,
    required this.groupName,
    required this.amountPersonOne,
    required this.amountPersonTwo,
    required this.amountPersonThree,
  });

  toJson() {
    return {
      // "id": id,
      "group name": groupName,
      "amount": amount,
      "image path": path,
      "image avatar url": imageAvatar,
      "person one amount": amountPersonOne,
      "person two amount": amountPersonTwo,
      "person three amount": amountPersonThree,
    };
  }
}
