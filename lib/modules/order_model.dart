
class OrderModel{
  String? id;
  String? medicineId;
  String? buyerReference;
  String? price;
  String? name;
  String? amount;
  String? isDone;

  OrderModel({this.id, this.medicineId, this.buyerReference, this.price, this.amount, this.name, this.isDone});

  OrderModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    if(json['medicineId']!=null) medicineId = json['medicineId'];
    if(json['buyerReference']!=null) buyerReference = json['buyerReference'];
    if(json['price']!=null) price = json['price'];
    if(json['name']!=null) name = json['name'];
    if(json['amount']!=null) amount = json['amount'];
    if(json['isDone']!=null) isDone = json['isDone'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(id!=null)data['id'] = id;
    if(medicineId!=null)data['medicineId'] = medicineId;
    if(buyerReference!=null)data['buyerReference'] = buyerReference;
    if(price!=null)data['price'] = price;
    if(name!=null)data['name'] = name;
    if(amount!=null)data['amount'] = amount;
    if(isDone!=null)data['isDone'] = isDone;
    return data;
  }
}