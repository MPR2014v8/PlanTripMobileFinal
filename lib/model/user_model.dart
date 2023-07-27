class User {
  final int id;
  final String username;
  final String email;
  final String first_name;
  final String last_name;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.first_name,
    required this.last_name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      first_name: json['first_name'],
      last_name: json['last_name'],
    );
  }
}