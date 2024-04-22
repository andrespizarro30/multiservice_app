class SignUpBody{

  String? name;
  String? phone;
  String? email;
  String? password;

  SignUpBody({
    this.name = "",
    this.phone = "",
    this.email = "",
    this.password = "",
  });

  SignUpBody.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    phone = json['Phone'];
    email = json['Email'];
    password = json['Password'];
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data["name"] = this.name;
    data["phone"] = this.phone;
    data["email"] = this.email;
    data["password"] = this.password;
    return data;
  }

}