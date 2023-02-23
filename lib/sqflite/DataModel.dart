// to map data
class DataModel {
  int? id;
  String title;
  String subtitle;
  DataModel({this.id, required this.title, required this.subtitle});

  // 1st method will get data from database and use as class object and map json so that we can use it in app
// 2nd method will map class object on json data

  factory DataModel.fromMap(Map<String, dynamic> json) => DataModel(
      id: json['id'], title: json['title'], subtitle: json['subtitle']);
// map object will be use at time of insert data
  Map<String, dynamic> toMap() =>
      {"id": id, "title": title, "subtitle": subtitle};
}
