enum Prices {
  free,
  price
}

class MedicineModel{
  String? id;
  String? reference;
  String? name;
  String? price;
  String? picture;
  String? amount;
  String? pharmacyId; //PharmacyId,name
  String? donorName;
  bool? availableNow = true;

  MedicineModel({
    this.id,
    this.reference,
    this.name,
    this.price,
    this.picture,
    this.amount,
    this.pharmacyId,
    this.donorName,
    this.availableNow
  });

  MedicineModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    reference = json['reference'];
    name = json['name'];
    if(json['price']!=null)        price = json['price'];
    if(json['picture']!=null)     picture = json['picture'];
    if(json['amount']!=null)  amount = json['amount'];
    if(json['pharmacyId']!=null)     pharmacyId = json['pharmacyId'];
    if(json['donorName']!=null)      donorName = json['donorName'];
    if(json['availableNow']!=null)    availableNow = json['availableNow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(id!=null)data['id'] = id;
    if(reference!=null)data['reference'] = reference;
    if(name!=null)data['name'] = name;
    if(price!=null)data['price'] = price;
    if(picture!=null)data['picture'] = picture;
    if(amount!=null)data['amount'] = amount;
    if(pharmacyId!=null)data['pharmacyId'] = pharmacyId;
    if(donorName!=null)data['donorName'] = donorName;
    if(availableNow!=null)data['availableNow'] = availableNow;
    return data;
  }
}