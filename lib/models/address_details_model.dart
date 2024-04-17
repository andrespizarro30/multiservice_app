import 'package:geolocator/geolocator.dart';

class AddressDetailModel{

  String? cityCountryAddress;
  String? formattedAddress;
  String? detailAddress;
  String? referenceAddress;
  String? position;

  AddressDetailModel({
    this.cityCountryAddress = "Ingrese su dirección",
    this.formattedAddress = "Click aquí",
    this.detailAddress = "",
    this.referenceAddress = "",
    this.position = ""
  });

  AddressDetailModel.fromJson(Map<String, dynamic> json) {
    cityCountryAddress = json['cityCountryAddress'];
    formattedAddress = json['formattedAddress'];
    detailAddress = json['detailAddress'];
    referenceAddress = json['referenceAddress'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cityCountryAddress'] = this.cityCountryAddress;
    data['formattedAddress'] = this.formattedAddress;
    data['detailAddress'] = this.detailAddress;
    data['referenceAddress'] = this.referenceAddress;
    data['position'] = this.position;
    return data;
  }

}