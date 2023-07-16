import 'package:get/get.dart';
import 'package:icare/helper/paths/links.dart';
import 'package:icare/helper/state/user_controller.dart';
import 'package:icare/services/firebase/fire_methods.dart';

Future<List<Map<String, dynamic>?>?> getTopRated({required int limit})async{
  return  await FirebaseMethods().getListFromFirestore(doctorsCollection,
    whereField: 'verified',
    conditionEqual: true,
    orderBy: "rating",
    descending:true ,
    limit: limit,
  );
}

Future<List<Map<String, dynamic>?>?> getNearbyPharmacy({required int limit})async{
  String address =Get.put(UserController()).userData.value.address??'';
  return  await FirebaseMethods().getListFromFirestore(pharmacyCollection,
    whereField: "address",
    conditionContains:address.substring(0,address.lastIndexOf(',')),
    limit: limit,
  );
}