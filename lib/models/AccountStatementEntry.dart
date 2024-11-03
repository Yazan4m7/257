class AccountStatementEntry {
  AccountStatementEntry({
     this.id,
    this.patientName,
     this.status,
     this.amount,
     this.amountBeforeDiscount,
     this.caseId,
     this.doctorId,
    this.discountTitle,
     this.dateApplied,
     this.rejectionInvoice,
    this.deletedAt,
     this.createdAt,
     this.updatedAt,
     this.notes,
     this.collector,
     this.receivedBy,
     this.recievedOn,
     this.isCreditNote,
    this.fromBank,
    this.additionalNotes,
    this.balance
  });

  @override
  String toString() {
    return ("$id - $patientName - $amount - $createdAt");
  }

  int? id;
  String? patientName;
  int? status;
  double? amount;
  int? amountBeforeDiscount;
  int? caseId;
  int? doctorId;
  String? discountTitle;
  String? dateApplied;
  int? rejectionInvoice;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? notes;
  int? collector;
  int? receivedBy;
  String? recievedOn;
  int? isCreditNote;
  int? fromBank;
  String? additionalNotes;
  double? balance;

  AccountStatementEntry.fromJson(Map<String, dynamic> json){
    id = json['id'];
    patientName = json['patient_name'];
    status = json['status'];
    amount = json['amount'].toDouble();
    amountBeforeDiscount = json['amount_before_discount'];
    caseId = json['case_id'];
    doctorId = json['doctor_id'];
    discountTitle = json['discount_title'];
    dateApplied = json['date_applied'];
    rejectionInvoice = json['rejection_invoice'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    notes = json['notes'];
    collector = json['collector'];
    receivedBy = json['received_by'];
    recievedOn = json['recieved_on'];
    isCreditNote = json['is_credit_note'];
    fromBank = json['from_bank'];
    additionalNotes = json['additional_notes'];

  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['status'] = status;
    _data['amount'] = amount;
    _data['amount_before_discount'] = amountBeforeDiscount;
    _data['case_id'] = caseId;
    _data['doctor_id'] = doctorId;
    _data['discount_title'] = discountTitle;
    _data['date_applied'] = dateApplied;
    _data['rejection_invoice'] = rejectionInvoice;
    _data['deleted_at'] = deletedAt;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['notes'] = notes;
    _data['collector'] = collector;
    _data['received_by'] = receivedBy;
    _data['recieved_on'] = recievedOn;
    _data['is_credit_note'] = isCreditNote;
    _data['from_bank'] = fromBank;
    _data['additional_notes'] = additionalNotes;
    return _data;
  }
}