class UserModel {
  final int? id;
  final String name;
  final String userId;
  final String email;
  final String img;
  final String token;

  UserModel({
    this.id,
    required this.name,
    required this.userId,
    required this.email,
    required this.img,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => new UserModel(
    id: json['id'],
    name: json['name'],
    userId: json['userId'],
    email: json['email'],
    img: json['img'],
    token: json['token'],
  );

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userId': userId,
      'email': email,
      'img': img,
      'token': token,
    };
  }
}
