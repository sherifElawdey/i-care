enum AppointmentState{
  waiting,
  done
}

class AppointmentModel{
  String? id;
  String? patientId;
  String? doctorId;
  String? doctorName;
  String? patientName;
  String? payed;
  String? offer;
  String? appointmentDate;
  String? appointmentState;

  AppointmentModel({
    this.id,
    this.patientId,
    this.doctorId,
    this.doctorName,
    this.patientName,
    this.payed,
    this.offer,
    this.appointmentDate,
    this.appointmentState
  });
  AppointmentModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    patientId = json['patientId'];
    doctorId = json['doctorId'];
    doctorName = json['doctorName'];
    patientName = json['patientName'];
    if(json['payed']!=null)        payed = json['payed'];
    if(json['offer']!=null)        offer = json['offer'];
    if(json['appointmentDate']!=null)     appointmentDate = json['appointmentDate'];
    if(json['appointmentState']!=null)  appointmentState = json['appointmentState'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(id!=null)data['id'] = id;
    if(patientId!=null)data['patientId'] = patientId;
    if(doctorId!=null)data['doctorId'] = doctorId;
    if(doctorName!=null)data['doctorName'] = doctorName;
    if(patientName!=null)data['patientName'] = patientName;
    if(payed!=null)data['payed'] = payed;
    if(offer!=null)data['offer'] = offer;
    if(appointmentDate!=null)data['appointmentDate'] = appointmentDate;
    if(appointmentState!=null)data['appointmentState'] = appointmentState;
    return data;
  }
}