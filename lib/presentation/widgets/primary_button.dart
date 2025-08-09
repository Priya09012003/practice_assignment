import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback function;
  final double? width;
  final double? height;
  final double? padding;
  final TextStyle? textStyle;
  final Color? buttonColor;
  final bool? showBorder;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.function,
    this.width,
    this.height,
    this.textStyle,
    this.padding,
    this.buttonColor,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final double btnWidth = width ?? MediaQuery.of(context).size.width;
    final double btnHeight = height ?? 50.0;
    final double btnPadding = padding ?? 8.0;
    final Color bgColor = showBorder == true ? Colors.transparent : (buttonColor ?? AppColors.primaryBrown);
    final Color borderColor = buttonColor ?? AppColors.brown400;
    final TextStyle defaultTextStyle =
        textStyle ??
        Theme.of(context).textTheme.labelLarge!.copyWith(color: showBorder == true ? borderColor : Colors.white);

    return InkWell(
      onTap: function,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        width: btnWidth,
        height: btnHeight,
        padding: EdgeInsets.all(btnPadding),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.0),
          border: showBorder == true ? Border.all(color: borderColor, width: 1.5) : null,
        ),
        child: Text(text, style: defaultTextStyle),
      ),
    );
  }
}
