class User {
  String? id;
  String? name;
  String? email;
  String? password;
  String? role;

  User(
      {this.role,
      this.name,
      this.email,
      this.password,
      this.id});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    role = json['role'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['role'] = this.role;
    data['password'] = this.password;
    return data;
  }
}
