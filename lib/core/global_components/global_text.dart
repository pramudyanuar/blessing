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
  final int? maxLines; // Tambahkan maxLines
  final TextOverflow overflow; // Tambahkan overflow

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
    this.maxLines, // Default null berarti unlimited
    this.overflow = TextOverflow.ellipsis, // Default: elipsis
  });

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines, // Gunakan maxLines
      overflow: overflow, // Gunakan overflow
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

  // 🔹 Semua varian dengan maxLines & overflow
  factory GlobalText.clickable(
    String text, {
    Key? key,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w500,
    Color color = Colors.blue,
    TextAlign textAlign = TextAlign.center,
    String fontFamily = 'Poppins',
    int? maxLines,
    TextOverflow overflow = TextOverflow.ellipsis,
    required VoidCallback onTap,
  }) {
    return GlobalText(
      key: key,
      text: text,
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      fontFamily: fontFamily,
      maxLines: maxLines,
      overflow: overflow,
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
    int? maxLines,
    TextOverflow overflow = TextOverflow.ellipsis,
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
      maxLines: maxLines,
      overflow: overflow,
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
    int? maxLines,
    TextOverflow overflow = TextOverflow.ellipsis,
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
      maxLines: maxLines,
      overflow: overflow,
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
    int? maxLines,
    TextOverflow overflow = TextOverflow.ellipsis,
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
      maxLines: maxLines,
      overflow: overflow,
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
    int? maxLines,
    TextOverflow overflow = TextOverflow.ellipsis,
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
      maxLines: maxLines,
      overflow: overflow,
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
    int? maxLines,
    TextOverflow overflow = TextOverflow.ellipsis,
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
      maxLines: maxLines,
      overflow: overflow,
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
    int? maxLines,
    TextOverflow overflow = TextOverflow.ellipsis,
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
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
