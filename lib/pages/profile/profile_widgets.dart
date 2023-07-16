import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwitchThemeWidget extends StatefulWidget {
  const SwitchThemeWidget({super.key});

  @override
  State<SwitchThemeWidget> createState() => _SwitchThemeWidgetState();
}
class _SwitchThemeWidgetState extends State<SwitchThemeWidget> {
  bool darkMode=Get.isDarkMode;
  @override
  Widget build(BuildContext context) {
    //final controller =Get.put(UserController());
    return Padding(
      padding:const EdgeInsets.symmetric(vertical: 8),
      child: SwitchListTile.adaptive(
          tileColor: greyColor.withOpacity(0.1),
          shape: RoundedRectangleBorder(borderRadius: Sizes.borderRadius(context)['r2']!),
          contentPadding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 15),
          title: CustomText(
            text:'Dark Mode',
            size: Sizes.textSize(context)['h3'],
          ),
          secondary:const Icon(CupertinoIcons.moon_stars_fill,size: 30),
          activeColor: appColor,
          value:darkMode,
          onChanged:(value){
            if(value){
              setState(() {
                Get.changeThemeMode(ThemeMode.dark);
                darkMode=value;
                saveTheme();
              });
            }else{
              setState(() {
                Get.changeThemeMode(ThemeMode.light);
                darkMode=value;
                saveTheme();
              });
            }
          }
      ),
    );
  }
  saveTheme()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('dark', darkMode);
  }
}