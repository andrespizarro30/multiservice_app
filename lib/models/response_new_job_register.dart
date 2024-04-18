class ResponseNewJobRegisterModel{

  String? RegisteredJob;

  ResponseNewJobRegisterModel({
    required this.RegisteredJob
  });

  ResponseNewJobRegisterModel.fromJson(Map<String, dynamic> json) {
    RegisteredJob = json['RegisteredJob'];
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data["RegisteredJob"] = this.RegisteredJob;
    return data;
  }



}