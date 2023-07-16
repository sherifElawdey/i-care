class ReminderModel{
  int? id;
  String? name;
  String? amount;
  String? hour;
  String? minute;

  ReminderModel({this.id, this.name, this.amount, this.hour,this.minute});

  ReminderModel.fromJson(Map<String,dynamic> json){
    if(json['id']!=null)id=json['id'];
    if(json['name']!=null)name=json['name'];
    if(json['amount']!=null)amount=json['amount'];
    if(json['hour']!=null)hour=json['hour'];
    if(json['minute']!=null)minute=json['minute'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(id!=null)data['id'] = id;
    if(name!=null)data['name'] = name;
    if(amount!=null)data['amount'] = amount;
    if(hour!=null)data['hour'] = hour;
    if(minute!=null)data['minute'] = minute;
    return data;
  }
}