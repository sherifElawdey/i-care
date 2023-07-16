import 'package:flutter/material.dart';

class TileItemModel {
  String? title;
  String? value;
  IconData? leadingIcon;
  IconData? trailingIcon;
  Widget? trailing;
  Widget? leading;
  Color? color;
  EdgeInsets? padding;
  EdgeInsets? margin;
  VoidCallback? onTap;

  TileItemModel({
    this.title,
    this.leadingIcon,
    this.trailing,
    this.leading,
    this.trailingIcon,
    this.onTap,
    this.value,
    this.color,
    this.margin,
    this.padding,
  });
}