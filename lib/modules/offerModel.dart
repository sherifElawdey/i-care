import 'package:cloud_firestore/cloud_firestore.dart';

class OfferModel{
  String? id;
  String? title;
  String? description;
  DocumentReference? writer;
  String? picture;

  OfferModel(
      {this.id, this.title, this.description, this.writer, this.picture});

  OfferModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    if(json['title']!=null) title = json['title'];
    description = json['description'];
    writer = json['writer'];
    if(json['picture']!=null) picture = json['picture'];

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(id!=null)data['id'] = id;
    if(title!=null)data['title'] = title;
    if(description!=null)data['description'] = description;
    if(picture!=null)data['picture'] = picture;
    if(writer!=null)data['writer'] = writer;
    return data;
  }
}