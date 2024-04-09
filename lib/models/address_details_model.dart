class AddressDetailModel{

  String? cityCountryAddress;
  String? formattedAddress;
  String? detailAddress;
  String? referenceAddress;

  AddressDetailModel({
    this.cityCountryAddress = "",
    this.formattedAddress = "",
    this.detailAddress = "",
    this.referenceAddress = ""
  });

  AddressDetailModel.fromJson(Map<String, dynamic> json) {
    cityCountryAddress = json['cityCountryAddress'];
    formattedAddress = json['formattedAddress'];
    detailAddress = json['detailAddress'];
    referenceAddress = json['referenceAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cityCountryAddress'] = this.cityCountryAddress;
    data['formattedAddress'] = this.formattedAddress;
    data['detailAddress'] = this.detailAddress;
    data['referenceAddress'] = this.referenceAddress;
    return data;
  }

}