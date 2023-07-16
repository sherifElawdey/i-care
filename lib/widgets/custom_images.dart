
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icare/helper/paths/images.dart';
import 'package:icare/helper/styles/colors.dart';

Widget profilePicture(String picture,double size,{VoidCallback? onTap})=>GestureDetector(
  onTap: onTap,
  child: ClipOval(
    child: Image.network(picture,
      width: size,
      height: size,
      fit: BoxFit.cover,
      scale: 1,
      errorBuilder: (context,obj,stake){
        return SvgPicture.asset('${ImagePath.icons}profile.svg',width: size,height: size,color: greyColor,);
      },
    ),
  ),
);

Widget postPicture(String picture,double size,{VoidCallback? onTap})=>GestureDetector(
  onTap: onTap,
  child: ClipRRect(
    borderRadius:BorderRadius.circular(10),
    child: Image.network(picture,
      height: size,
      width: Size.infinite.width,
      fit: BoxFit.cover,
      scale: 1,
      errorBuilder: (context,obj,stake){
        return SvgPicture.asset('${ImagePath.emptyIcons}offline.svg',
          width: Size.infinite.width,
          alignment: Alignment.center,
          height: size,
        );
      },
    ),
  ),
);


