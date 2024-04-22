class RequestedJobList {

  late List<RequestedJob> _requestedJobList;
  List<RequestedJob> get requestedJobList=>_requestedJobList;

  RequestedJobList({required requestedJobList}){
    this._requestedJobList = requestedJobList;
  }

  RequestedJobList.fromJson(Map<String, dynamic> json) {
    if (json['RequestedJobList'] != null) {
      _requestedJobList = <RequestedJob>[];
      json['RequestedJobList'].forEach((v) {
        _requestedJobList!.add(new RequestedJob.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._requestedJobList != null) {
      data['RequestedJobList'] =
          this._requestedJobList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RequestedJob {
  int? id;
  String? orderNumber;
  String? jobType;
  String? jobAddress;
  String? jobLocation;
  String? jobDescription;
  String? filesPath;
  String? formType;
  String? requestedDate;
  String? jobUID;
  String? jobToken;
  String? accepted;
  String? professionalName;
  String? professionalUID;
  String? professionalToken;

  RequestedJob(
      {this.id,
        this.orderNumber,
        this.jobType,
        this.jobAddress,
        this.jobLocation,
        this.jobDescription,
        this.filesPath,
        this.formType,
        this.requestedDate,
        this.jobUID,
        this.jobToken,
        this.accepted,
        this.professionalName,
        this.professionalUID,
        this.professionalToken});

  RequestedJob.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    orderNumber = json['OrderNumber'];
    jobType = json['JobType'];
    jobAddress = json['JobAddress'];
    jobLocation = json['JobLocation'];
    jobDescription = json['JobDescription'];
    filesPath = json['FilesPath'];
    formType = json['FormType'];
    requestedDate = json['RequestedDate'];
    jobUID = json['JobUID'];
    jobToken = json['JobToken'];
    accepted = json['Accepted'];
    professionalName = json['ProfessionalName'];
    professionalUID = json['ProfessionalUID'];
    professionalToken = json['ProfessionalToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['OrderNumber'] = this.orderNumber;
    data['JobType'] = this.jobType;
    data['JobAddress'] = this.jobAddress;
    data['JobLocation'] = this.jobLocation;
    data['JobDescription'] = this.jobDescription;
    data['FilesPath'] = this.filesPath;
    data['FormType'] = this.formType;
    data['RequestedDate'] = this.requestedDate;
    data['JobUID'] = this.jobUID;
    data['JobToken'] = this.jobToken;
    data['Accepted'] = this.accepted;
    data['ProfessionalName'] = this.professionalName;
    data['ProfessionalUID'] = this.professionalUID;
    data['ProfessionalToken'] = this.professionalToken;
    return data;
  }
}