class Client {
  Client({
     this.id,
     this.name,
     this.phone,
      this.clinicPhone,
     this.address,
     this.balance,
     this.active,
    this.deletedAt,
     this.createdAt,
     this.updatedAt,
  });

    int? id;
    String? name;
    String? phone;
    String? clinicPhone;
    String? address;
    int? balance;
    int? active;
    String? deletedAt;
    String? createdAt;
    String? updatedAt;

  Client.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    clinicPhone = json['clinic_phone'];
    address = json['address'];
    balance = json['balance'];
    active = json['active'];
    deletedAt = null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['phone'] = phone;
    _data['clinic_phone'] = clinicPhone;
    _data['address'] = address;
    _data['balance'] = balance;
    _data['active'] = active;
    _data['deleted_at'] = deletedAt;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}