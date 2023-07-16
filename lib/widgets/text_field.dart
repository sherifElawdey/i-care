import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:flutter/material.dart';

class CustomTextField extends Container{
  CustomTextField(BuildContext context, {
    Key? formFieldKey,
    double? height,
    Widget? prefix,
    String? prefixText,
    Widget? underFieldWidget,   //
    TextEditingController? controller,
    String? hintText,
    int? maxLines,
    String? labelText,
    String? suffixText,
    Widget? suffixIcon,
    Color? textColor,
    Color? backgroundColor,
    String? errorText,
    bool readonly = false,
    String? initialValue,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,        //
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onFieldSubmitted,
    VoidCallback? onEditingComplete,
    FormFieldSetter<String>? onSaved,
    bool? enabled,
    bool obscureText = false,
    InputDecoration? inputDecoration,
    EdgeInsetsGeometry? margin,
    EdgeInsets? contentPadding,
    Key? key,
  }) : super(
    key: key,
    height: height,
    margin: margin ?? Sizes.marginTextFields(context),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: TextFormField(
      key: formFieldKey,
      controller:initialValue==null ?controller:TextEditingController(text: initialValue),
      validator: validator,
      maxLines: maxLines,
      enabled: enabled,
      obscureText: obscureText,
      onSaved: onSaved,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete ,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,
      readOnly: readonly,
      textInputAction:textInputAction,
      decoration: inputDecoration ?? InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hintText: hintText,
        contentPadding:contentPadding ?? Sizes.paddingTextFields(context),
        prefixIcon: prefix ,
        prefixText: prefixText,
        counter: underFieldWidget,
        labelText: labelText,
        labelStyle: customTextStyle(size: Sizes.textSize(context)['h3']),
        suffixIcon:suffixIcon ,
        suffixText:suffixText ,
        errorStyle: customTextStyle(color: errorColor,),
        fillColor: backgroundColor ?? Colors.transparent
       ),
    ),
  );

}