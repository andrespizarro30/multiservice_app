class CitiesPoligonsList {

  late List<CityPoligonsData> _citiespoligonsList;

  List<CityPoligonsData> get citiespoligonsList => _citiespoligonsList;

  CitiesPoligonsList({required citiespoligonsList}){
    this._citiespoligonsList = citiespoligonsList;
  }

  CitiesPoligonsList.fromJson(Map<String, dynamic> json) {
    if (json['CitiespoligonsList'] != null) {
      _citiespoligonsList = <CityPoligonsData>[];
      json['CitiespoligonsList'].forEach((v) {
        _citiespoligonsList!.add(new CityPoligonsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._citiespoligonsList != null) {
      data['CitiespoligonsList'] =
          this._citiespoligonsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CityPoligonsData {
  int? id;
  String? cityName;
  String? poligonMarks;
  String? circlesCenter;

  CityPoligonsData(
      {this.id, this.cityName, this.poligonMarks, this.circlesCenter});

  CityPoligonsData.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    cityName = json['CityName'];
    poligonMarks = json['PoligonMarks'];
    circlesCenter = json['CirclesCenter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['CityName'] = this.cityName;
    data['PoligonMarks'] = this.poligonMarks;
    data['CirclesCenter'] = this.circlesCenter;
    return data;
  }
}