import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:icare/modules/user_model.dart';
import 'package:icare/services/firebase/fire_methods.dart';

class UserController extends GetxController{
  var userData=(UserModel()).obs;
  var userDataReference=(FirebaseMethods().addUserReference()).obs;
  var dateToday=DateTime.now().toString().obs;

  Future<UserModel> getUserData()async{
    userData = (await FirebaseMethods().getUserData()).obs;
    update();
    return userData.value;
  }
  @override
  void onInit() async{
    userData = (await FirebaseMethods().getUserData()).obs;
    update();
    FlutterNativeSplash.remove();
    super.onInit();
  }
}