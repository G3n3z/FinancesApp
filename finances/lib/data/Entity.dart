class Entity{

  late String _name;

  Entity();

  Entity.all(this._name);

  Entity.fromJson(Map<String, dynamic> json){
    _name = json['name'];
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = _name;
    return data;
  }

}