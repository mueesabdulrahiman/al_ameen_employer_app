class Login {
  Login(this.username, this.password);
  final String username;
  final String password;
  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}
