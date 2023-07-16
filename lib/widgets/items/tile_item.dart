import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/tile_item_model.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:flutter/material.dart';

Widget tileItem(BuildContext context,TileItemModel item,) =>
    Padding(
      padding: item.margin ?? EdgeInsets.symmetric(vertical: Sizes.heightScreen(context)*0.01),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: Sizes.borderRadius(context)['r2']!),
        tileColor:greyColor.withOpacity(0.1),
        minLeadingWidth: 0,
        contentPadding:item.padding ??const EdgeInsets.symmetric(vertical: 5.0,horizontal: 15),
        title: CustomText(
          text: item.value.toString(),
          size: Sizes.textSize(context)['h3'],
          fontWeight: FontWeight.w500,
        ),
        leading: item.title!=null
            ? CustomText(text: '${item.title} :')
            : item.leadingIcon!=null
            ? Icon(item.leadingIcon,color: item.color,)
            : item.leading,
        trailing:item.trailing ?? Icon(item.trailingIcon ?? Icons.arrow_forward_ios_rounded),
        onTap: item.onTap,
      ),
    );
