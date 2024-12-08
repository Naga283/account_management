import 'package:account_management/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpandedElevatedBtn extends ConsumerWidget {
  const ExpandedElevatedBtn({
    super.key,
    required this.btnName,
    required this.onTap,
    this.isLoading,
    this.btnHeight,
    this.btnWidth,
    this.bgCol,
  });
  final String btnName;
  final Function() onTap;
  final bool? isLoading;
  final double? btnWidth;
  final double? btnHeight;
  final Color? bgCol;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: btnHeight ?? MediaQuery.of(context).size.height * 0.06,
        width: btnWidth ?? double.infinity,
        decoration: BoxDecoration(
          color: bgCol ?? appColors.primary,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: (isLoading ?? false)
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: appColors.whiteColor,
                  ),
                )
              : Text(
                  btnName,
                  style: TextStyle(
                    color: appColors.whiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
