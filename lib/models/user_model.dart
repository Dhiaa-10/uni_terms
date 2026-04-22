class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profilePic;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePic,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profilePic: json['profilePic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePic': profilePic,
    };
  }
}
