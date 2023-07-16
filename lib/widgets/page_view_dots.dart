import 'package:icare/helper/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget pageViewDots({required int currentPage, required int length}) {
  ScrollController controller=ScrollController();
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(length, (index) {
      if(index==currentPage+1||index==currentPage-1){
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 7,
          width:7,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color:appColor.withOpacity(0.5),
          ),
        );
      }else if(index==currentPage+2||index==currentPage-2){
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 4,
          width:4,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color:appColor.withOpacity(0.5),
          ),
        );
      }else if(index==currentPage){
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 7,
          width:21 ,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color:appColor,
          ),
        );
      }else{
        return const SizedBox();
      }
    }),
  );
/*
  return SizedBox(
    width: 60,
      height: 17,
      child: ListView.builder(
        controller: controller,
        dragStartBehavior: DragStartBehavior.start,
        addAutomaticKeepAlives: true,
        itemCount: length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context,index){
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 7,
              width:(index == currentPage) ? 21 : 7,
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color:(index == currentPage) ? appColor : appColor.withOpacity(0.5),
              ),
            );
          }
      ),
  );
*/
}
