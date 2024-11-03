class Employee {
  int? id;
  String? nameInitials;

  Employee({this.id, this.nameInitials});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameInitials = json['name_initials'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_initials'] = this.nameInitials;
    return data;
  }
}