class UserProfile {
  final String id;
  final String email;
  String username;
  String phone;
  String token;

  UserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.token,
  });
}
