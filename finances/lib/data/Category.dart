class Category{

  late String _name;

  Category();
  Category.all(this._name);

  Category.fromJson(Map<String, dynamic> json) {
    name = json['name'];
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