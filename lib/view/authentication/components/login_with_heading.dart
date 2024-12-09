import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IconWithHeadingAndSubHeading extends ConsumerWidget {
  const IconWithHeadingAndSubHeading({
    super.key,
    required this.heading,
    this.subHeading,
  });
  final String heading;
  final String? subHeading;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 50.0,
            bottom: 10.0,
          ),
          child: Text(
            heading,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 26,
            ),
          ),
        ),
        SizedBox(
            width: 350,
            child: Text(
              subHeading ??
                  "Just a step away from managing your account seamlessly",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            )),
      ],
    );
  }
}
