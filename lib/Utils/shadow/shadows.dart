import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:flutter/material.dart';

class TShadowStyle{
  static final verticalProductShadow = BoxShadow(
    color: TColors.darkerGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2)
  );
  static final horizontalProductShadow = BoxShadow(
    color: TColors.darkGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2)
  );
  static final postShadowLight = BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(5, 5), 
          );
  static final postShadowDark = BoxShadow(
            color: Colors.white.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(5, 5), 
          );
  
}