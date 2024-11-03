class Case {
  int? id;
  String? caseId;
  String? patientName;
  String? initialDeliveryDate;
  String? actualDeliveryDate;
  int? deliveredToClient;
  int? voucherPrintedBy;
  int? voucherRecievedBy;
  int? doctorId;
  int? finisher;
  int? impressionType;
  int? locked;
  Null deletedAt;
  String? createdAt;
  String? updatedAt;
  int? isReturned;
  int? isARemake;
  Null isRejected;
  int? containsModification;
  int? firstCaseIfRepeated;
  int ? deliveredInBox;
  Case(
      {this.id,
        this.caseId,
        this.patientName,
        this.initialDeliveryDate,
        this.actualDeliveryDate,
        this.deliveredToClient,
        this.voucherPrintedBy,
        this.voucherRecievedBy,
        this.doctorId,
        this.finisher,
        this.impressionType,
        this.locked,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.isReturned,
        this.isARemake,
        this.isRejected,
        this.containsModification,
        this.firstCaseIfRepeated,
        this.deliveredInBox});

  Case.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    caseId = json['case_id'];
    patientName = json['patient_name'];
    initialDeliveryDate = json['initial_delivery_date'];
    actualDeliveryDate = json['actual_delivery_date'];
    deliveredToClient = json['delivered_to_client'];
    voucherPrintedBy = json['voucher_printed_by'];
    voucherRecievedBy = json['voucher_recieved_by'];
    doctorId = json['doctor_id'];
    finisher = json['finisher'];
    impressionType = json['impression_type'];
    locked = json['locked'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isReturned = json['is_returned'];
    isARemake = json['is_a_remake'];
    isRejected = json['is_rejected'];
    containsModification = json['contains_modification'];
    firstCaseIfRepeated = json['first_case_if_repeated'];
    deliveredInBox = json['delivered_in_box'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['case_id'] = this.caseId;
    data['patient_name'] = this.patientName;
    data['initial_delivery_date'] = this.initialDeliveryDate;
    data['actual_delivery_date'] = this.actualDeliveryDate;
    data['delivered_to_client'] = this.deliveredToClient;
    data['voucher_printed_by'] = this.voucherPrintedBy;
    data['voucher_recieved_by'] = this.voucherRecievedBy;
    data['doctor_id'] = this.doctorId;
    data['finisher'] = this.finisher;
    data['impression_type'] = this.impressionType;
    data['locked'] = this.locked;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_returned'] = this.isReturned;
    data['is_a_remake'] = this.isARemake;
    data['is_rejected'] = this.isRejected;
    data['contains_modification'] = this.containsModification;
    data['first_case_if_repeated'] = this.firstCaseIfRepeated;
    data['delivered_in_box'] = this.deliveredInBox;
    return data;
  }
}