class Contact {
  Contact({
    //this.id,
    required this.phone,
    required this.fullName,
  });
  int? id;
  late final String phone;
  late final String fullName;

  Contact.fromJson(Map<String, dynamic> json){
    id = json['id'];
    phone = json['phone'];
    fullName = json['fullName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    //_data['id'] = id;
    _data['phone'] = phone;
    _data['fullName'] = fullName;
    return _data;
  }
}