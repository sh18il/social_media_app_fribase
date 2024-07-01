import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const SizedBox(
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
                    const Gap(5),
                    FadeShimmer(
                      height: height * 0.5,
                      width: width * .8,
                      radius: 7,
                      millisecondsDelay: delay,
                      fadeTheme: FadeTheme.dark,
                    ),
                    const SizedBox(
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
        separatorBuilder: (_, __) => const SizedBox(
          height: 16,
        ),
      ),
    );
  }
}


