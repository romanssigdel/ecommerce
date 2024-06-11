class User {
  String? name;
  String? email;
  String? password;
  String? confirmPassword;

  User({this.name, this.email, this.password, this.confirmPassword});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    confirmPassword = json['confirm_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['confirm_password'] = this.confirmPassword;
    return data;
  }
}
