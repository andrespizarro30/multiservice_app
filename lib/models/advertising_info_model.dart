class AdvertisingList {

  late List<Advertising> _advertisingList;

  List<Advertising> get advertisingList => _advertisingList;

  AdvertisingList({advertisingList}){
    this._advertisingList = advertisingList;
  }

  AdvertisingList.fromJson(Map<String, dynamic> json) {
    if (json['AdvertisingList'] != null) {
      _advertisingList = <Advertising>[];
      json['AdvertisingList'].forEach((v) {
        _advertisingList!.add(new Advertising.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._advertisingList != null) {
      data['AdvertisingList'] =
          this._advertisingList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Advertising {
  int? id;
  String? adName;
  String? adImage;

  Advertising({this.id, this.adName, this.adImage});

  Advertising.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adName = json['AdName'];
    adImage = json['Ad_Image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['AdName'] = this.adName;
    data['Ad_Image'] = this.adImage;
    return data;
  }
}