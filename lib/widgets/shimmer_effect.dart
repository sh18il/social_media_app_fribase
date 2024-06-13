import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class shimmerWidget extends StatelessWidget {
  const shimmerWidget({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        itemBuilder: (_, i) {
          final delay = (i * 300);
          return Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeShimmer.round(
                      size: 60,
                      fadeTheme: FadeTheme.dark,
                      millisecondsDelay: delay,
                    ),
                    Gap(5),
                    FadeShimmer(
                      height: height * 0.5,
                      width: width * .8,
                      radius: 7,
                      millisecondsDelay: delay,
                      fadeTheme: FadeTheme.dark,
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        FadeShimmer(
                          height: 8,
                          millisecondsDelay: delay,
                          width: 170,
                          radius: 4,
                          fadeTheme: FadeTheme.dark,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        },
        itemCount: 20,
        separatorBuilder: (_, __) => SizedBox(
          height: 16,
        ),
      ),
    );
  }
}


