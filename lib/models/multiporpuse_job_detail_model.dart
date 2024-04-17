class MultiporpuseJobDetail{

  String? OrderNumber;
  String? JobType;
  String? JobAddress;
  String? JobLocation;
  String? JobDescription;
  String? FilesPath;
  String? FormType;
  String? LoadedJob;
  String? RequestedDate;

  MultiporpuseJobDetail({
    this.OrderNumber = "",
    this.JobType = "",
    this.JobAddress = "",
    this.JobLocation = "",
    this.JobDescription = "",
    this.FilesPath = "",
    this.FormType = "",
    this.LoadedJob = "",
    this.RequestedDate
  });

  MultiporpuseJobDetail.fromJson(Map<String, dynamic> json) {
    OrderNumber = json['OrderNumber'];
    JobType = json['JobType'];
    JobAddress = json['JobAddress'];
    JobLocation = json['JobLocation'];
    JobDescription = json['JobDescription'];
    FilesPath = json['FilesPath'];
    FormType = json['FormType'];
    LoadedJob = json['LoadedJob'];
    RequestedDate = json['RequestedDate'];
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['OrderNumber'] = this.OrderNumber;
    data['JobType'] = this.JobType;
    data["JobAddress"] = this.JobAddress;
    data["JobLocation"] = this.JobLocation;
    data["JobDescription"] = this.JobDescription;
    data["FilesPath"] = this.FilesPath;
    data["FormType"] = this.FormType;
    data['LoadedJob'] = this.LoadedJob;
    data['RequestedDate'] = this.RequestedDate;
    return data;
  }


}