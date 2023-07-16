import 'package:cloud_firestore/cloud_firestore.dart';

enum Administration{
  user,
  admin,
  doctor,
  pharmacy,
}
const List<String> specialization=[
  'الطب الباطني',
  'طب الأسنان',
  'طب العيون',
  'أمراض جلدية',
  'طب الأطفال',
  'العظام',
  'جراحة التجميل',
  'الأورام',
  'أعصاب',
  'طب الأمراض النفسية',
  'النساء والتوليد',
  'طب القلب / جراحة القلب',
  'الجراحة العامة',
  'طب الأنف والأذن والحنجرة',
  'طب تخصص الغدد',
  'أمراض الجهاز الهضمي',
  'أمراض الدم',
  'أمراض الكبد',
  'أمراض الكلى',
  'أمراض الروماتيزم',
  'المسالك البولية',
  'التخدير',
];
class UserModel{
  String? id;
  DocumentReference? reference;
  String? name;
  String? picture;
  String? title;
  String? email;
  String? password;
  String? phoneNumber; //+20117388474
  GeoPoint? location; // 30.12345678 ,31.23456789
  String? address;   //governorate,center,village,street
  String? administration; //Administration.user.name
  String? idPicture;  //card picture
  bool? verified;  //card picture
  String? specialization;
  double? rating = 0.0;
  String? disclosurePrice;
  List<dynamic>? daysOfWork; // sunday,monday
  String? timesOfWork; // 11:30 am,05:30 pm

  UserModel({
    this.id,  //
    this.reference, //
    this.name,
    this.picture,
    this.title,
    this.email,
    this.password,
    this.phoneNumber,
    this.location,
    this.address,
    this.administration,
    this.idPicture, //
    this.verified,  //
    this.specialization,
    this.rating,
    this.disclosurePrice,
    this.daysOfWork,
    this.timesOfWork
  });

  UserModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    reference = json['reference'];
    name = json['name'];
    if(json['picture']!=null) picture = json['picture'];
    if(json['title']!=null) title = json['title'];
    if(json['email']!=null) email = json['email'];
    if(json['password']!=null) password = json['password'];
    if(json['phoneNumber']!=null) phoneNumber = json['phoneNumber'];
    if(json['location']!=null) location = json['location'];
    if(json['address']!=null)  address = json['address'];
    if(json['idPicture']!=null)idPicture = json['idPicture'];
    if(json['verified']!=null) verified = json['verified'];
    if(json['specialization']!=null) specialization = json['specialization'];
    if(json['rating']!=null) rating = json['rating'];
    if(json['disclosurePrice']!=null) disclosurePrice = json['disclosurePrice'];
    if(json['timesOfWork']!=null) timesOfWork = json['timesOfWork'];
    if(json['daysOfWork']!=null) daysOfWork = json['daysOfWork'];
    if(json['administration']!=null) administration = json['administration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(id!=null)data['id'] = id;
    if(reference!=null)data['reference'] = reference;
    if(name!=null)data['name'] = name;
    if(picture!=null)data['picture'] = picture;
    if(title!=null)data['title'] = title;
    if(email!=null)data['email'] = email;
    if(password!=null)data['password'] = password;
    if(phoneNumber!=null)data['phoneNumber'] = phoneNumber;
    if(location!=null)data['location'] = location;
    if(address!=null)data['address'] = address;
    if(idPicture!=null)data['idPicture'] = idPicture;
    if(verified!=null)data['verified'] = verified;
    if(specialization!=null)data['specialization'] = specialization;
    if(rating!=null)data['rating'] = rating;
    if(disclosurePrice!=null)data['disclosurePrice'] = disclosurePrice;
    if(timesOfWork!=null)data['timesOfWork'] = timesOfWork;
    if(daysOfWork!=null)data['daysOfWork'] = daysOfWork;
    if(administration!=null)data['administration'] = administration;
    return data;
  }
}