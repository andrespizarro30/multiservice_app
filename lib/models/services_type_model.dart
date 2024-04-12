class ServicesType {

  late List<ServicesList> _servicesList;

  List<ServicesList> get servicesList=>_servicesList;

  ServicesType({required servicesList}){
    this._servicesList = servicesList;
  }

  ServicesType.fromJson(Map<String, dynamic> json) {
    if (json['ServicesList'] != null) {
      _servicesList = <ServicesList>[];
      json['ServicesList'].forEach((v) {
        _servicesList!.add(new ServicesList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._servicesList != null) {
      data['ServicesList'] = this._servicesList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServicesList {
  int? id;
  String? serviceType;
  String? descriptingIcon;

  ServicesList({this.id, this.serviceType, this.descriptingIcon});

  ServicesList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceType = json['ServiceType'];
    descriptingIcon = json['Descripting_Icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ServiceType'] = this.serviceType;
    data['Descripting_Icon'] = this.descriptingIcon;
    return data;
  }
}