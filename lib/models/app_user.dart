class AppUser {
  const AppUser({
    required this.name,
    required this.email,
    required this.passwordHash,
  });

  final String name;
  final String email;
  final String passwordHash;

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'passwordHash': passwordHash,
      };

  factory AppUser.fromMap(Map<String, dynamic> map) => AppUser(
        name: map['name'] as String,
        email: map['email'] as String,
        passwordHash: map['passwordHash'] as String,
      );
}