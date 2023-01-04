class UserModel {
  String id;
  String email;
  String phone;
  String name;
  String profilepic;

  UserModel(
      {required this.id,
      required this.email,
      required this.phone,
      required this.profilepic,
      required this.name});

  static UserModel constructFromFirebase(
      Map<dynamic, dynamic> data, String id) {
    return UserModel(
      id: id,
      name: data['name'] ?? "",
      email: data['email'] ?? "",
      phone: data['phone'] ?? "",
      profilepic: data['profilepic'] ??
          "https://firebasestorage.googleapis.com/v0/b/mazadcar-60190.appspot.com/o/posts%2Fdata%2Fuser%2F0%2Fcom.example.mazadcarapp%2Fcache%2Fe70822e6-c95f-4ee0-b095-708f7149512d6623604385751819593.jpg?alt=media&token=373fb680-48ac-4f82-91e1-a41e24d629d3",
    );
  }
}
