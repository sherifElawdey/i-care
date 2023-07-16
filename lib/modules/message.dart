import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultModel{
  String? id;
  String? receiverPath;
  String? senderPath;
  String? receiverName;
  String? senderName;
  String? receiverPicture;
  String? senderPicture;
  bool? read;

  ConsultModel(
      {this.id,
      this.receiverPath,
      this.senderPath,
      this.receiverName,
      this.senderName,
      this.receiverPicture,
      this.senderPicture,
      this.read = false,
      });

  ConsultModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    if(json['receiverPath']!=null) receiverPath = json['receiverPath'];
    if(json['senderPath']!=null) senderPath = json['senderPath'];
    if(json['receiverName']!=null)receiverName = json['receiverName'];
    if(json['senderName']!=null)senderName = json['senderName'];
    if(json['receiverPicture']!=null)receiverPicture = json['receiverPicture'];
    if(json['senderPicture']!=null)senderPicture = json['senderPicture'];
    if(json['read']!=null)read = json['read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(id!=null)data['id'] = id;
    if(receiverPath!=null)data['receiverPath'] = receiverPath;
    if(senderPath!=null)data['senderPath'] = senderPath;
    if(receiverName!=null)data['receiverName'] = receiverName;
    if(senderName!=null)data['senderName'] = senderName;
    if(receiverPicture!=null)data['receiverPicture'] = receiverPicture;
    if(senderPicture!=null)data['senderPicture'] = senderPicture;
    if(read!=null)data['read'] = read;
    return data;
  }

}

class MessageModel{
  String? id;
  String? senderId;
  String? message;
  Timestamp? date;

  MessageModel({this.id, this.senderId, this.message, this.date});

  MessageModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    if(json['senderId']!=null) senderId = json['senderId'];
    message = json['message'];
    if(json['date']!=null) date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(id!=null)data['id'] = id;
    if(senderId!=null)data['senderId'] = senderId;
    if(message!=null)data['message'] = message;
    if(date!=null)data['date'] = date;
    return data;
  }

}