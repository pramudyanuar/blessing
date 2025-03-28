import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlobalText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final double lineHeight;
  final String fontFamily;
  final VoidCallback? onTap;

  const GlobalText({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.textAlign = TextAlign.center,
    this.lineHeight = 1.2,
    this.fontFamily = 'Poppins',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        color: color,
        fontFamily: fontFamily,
        height: lineHeight,
        decoration: TextDecoration.none,
      ),
    );

    return onTap != null
        ? GestureDetector(onTap: onTap, child: textWidget)
        : textWidget;
  }

  // 🔹 Varian Clickable
  factory GlobalText.clickable(
    String text, {
    Key? key,
    double fontSize = 16,
    Color color = Colors.blue,
    TextAlign textAlign = TextAlign.center,
    String fontFamily = 'Poppins',
    required VoidCallback onTap,
  }) {
    return GlobalText(
      key: key,
      text: text,
      fontSize: fontSize.sp,
      fontWeight: FontWeight.w500,
      color: color,
      textAlign: textAlign,
      fontFamily: fontFamily,
      onTap: onTap,
    );
  }

  factory GlobalText.light(
    String text, {
    Key? key,
    double fontSize = 16,
    Color color = Colors.black,
    TextAlign textAlign = TextAlign.center,
    double lineHeight = 1.2,
    String fontFamily = 'Poppins',
  }) {
    return GlobalText(
      key: key,
      text: text,
      fontSize: fontSize.sp,
      fontWeight: FontWeight.w300,
      color: color,
      textAlign: textAlign,
      lineHeight: lineHeight,
      fontFamily: fontFamily,
    );
  }

  factory GlobalText.regular(
    String text, {
    Key? key,
    double fontSize = 16,
    Color color = Colors.black,
    TextAlign textAlign = TextAlign.center,
    double lineHeight = 1.2,
    String fontFamily = 'Poppins',
  }) {
    return GlobalText(
      key: key,
      text: text,
      fontSize: fontSize.sp,
      fontWeight: FontWeight.w400,
      color: color,
      textAlign: textAlign,
      lineHeight: lineHeight,
      fontFamily: fontFamily,
    );
  }

  factory GlobalText.medium(
    String text, {
    Key? key,
    double fontSize = 16,
    Color color = Colors.black,
    TextAlign textAlign = TextAlign.center,
    double lineHeight = 1.2,
    String fontFamily = 'Poppins',
  }) {
    return GlobalText(
      key: key,
      text: text,
      fontSize: fontSize.sp,
      fontWeight: FontWeight.w500,
      color: color,
      textAlign: textAlign,
      lineHeight: lineHeight,
      fontFamily: fontFamily,
    );
  }

  factory GlobalText.semiBold(
    String text, {
    Key? key,
    double fontSize = 16,
    Color color = Colors.black,
    TextAlign textAlign = TextAlign.center,
    double lineHeight = 1.2,
    String fontFamily = 'Poppins',
  }) {
    return GlobalText(
      key: key,
      text: text,
      fontSize: fontSize.sp,
      fontWeight: FontWeight.w600,
      color: color,
      textAlign: textAlign,
      lineHeight: lineHeight,
      fontFamily: fontFamily,
    );
  }

  factory GlobalText.bold(
    String text, {
    Key? key,
    double fontSize = 16,
    Color color = Colors.black,
    TextAlign textAlign = TextAlign.center,
    double lineHeight = 1.2,
    String fontFamily = 'Poppins',
  }) {
    return GlobalText(
      key: key,
      text: text,
      fontSize: fontSize.sp,
      fontWeight: FontWeight.w700,
      color: color,
      textAlign: textAlign,
      lineHeight: lineHeight,
      fontFamily: fontFamily,
    );
  }

  factory GlobalText.extraBold(
    String text, {
    Key? key,
    double fontSize = 16,
    Color color = Colors.black,
    TextAlign textAlign = TextAlign.center,
    double lineHeight = 1.2,
    String fontFamily = 'Poppins',
  }) {
    return GlobalText(
      key: key,
      text: text,
      fontSize: fontSize.sp,
      fontWeight: FontWeight.w800,
      color: color,
      textAlign: textAlign,
      lineHeight: lineHeight,
      fontFamily: fontFamily,
    );
  }
}
