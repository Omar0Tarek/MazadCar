class Message {
  final String id;
  final String senderName;
  final String senderID;

  final DateTime timeStamp;

  final String content;

  final String? image;

  Message(
      {required this.id,
      required this.senderName,
      required this.senderID,
      required this.timeStamp,
      required this.content,
      this.image});

  static Message constructFromFirebase(Map<dynamic, dynamic> data, String id) {
    print("This is the data:");
    print(data);

    return Message(
      id: id,
      senderID: data['senderID'] ?? "",
      senderName: data['senderName'] ?? "",
      timeStamp: data['timeStamp'].toDate() ?? "",
      image: data['image'],
      content: data['content'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      'senderName': senderName,
      'senderID': senderID,
      "timeStamp": timeStamp,
      "image": image,
      "content": content
    };
  }
}
