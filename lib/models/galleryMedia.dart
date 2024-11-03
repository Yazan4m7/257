class GalleryMedia {
  int? id;
  String? text;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  GalleryMedia(
      {this.id, this.text, this.createdAt, this.updatedAt, this.deletedAt});

  GalleryMedia.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}