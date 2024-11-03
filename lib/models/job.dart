class job {
  String? jobType;
  String? material;
  int? hasBeenRejected;
  int? isRejection;
  int? qty;
  int? total;

  job({this.jobType, this.material, this.qty, this.total});

  job.fromJson(Map<String, dynamic> json) {
    jobType = json['jobType'];
    hasBeenRejected = json['hasBeenRejected'];
    isRejection = json['isRejection'];
    material = json['material'];
    qty = json['qty'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jobType'] = this.jobType;
    data['material'] = this.material;
    data['isRejection'] = this.isRejection;
    data['hasBeenRejected'] = this.hasBeenRejected;
    data['qty'] = this.qty;
    data['total'] = this.total;
    return data;
  }
}