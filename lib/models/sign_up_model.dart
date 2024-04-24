class SignUpBody{

  String? name;
  String? phone;
  String? email;
  String? password;
  String? userType;

  SignUpBody({
    this.name = "",
    this.phone = "",
    this.email = "",
    this.password = "",
    this.userType = ""
  });

  SignUpBody.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    phone = json['Phone'];
    email = json['Email'];
    password = json['Password'];
    userType = json['UserType'];
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data["name"] = this.name;
    data["phone"] = this.phone;
    data["email"] = this.email;
    data["password"] = this.password;
    data["userType"] = this.userType;
    return data;
  }

}