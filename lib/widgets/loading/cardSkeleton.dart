import 'package:flutter/material.dart';
import 'package:identa/widgets/loading/skeleton.dart';

const double defaultPadding = 16.0;

class CardSkelton extends StatelessWidget {
  const CardSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Skeleton(height: 90, width: 90),
        SizedBox(width: defaultPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: defaultPadding / 2),
              Skeleton(),
              SizedBox(height: defaultPadding / 2),
              Skeleton(),
              SizedBox(height: defaultPadding / 2),
            ],
          ),
        )
      ],
    );
  }
}
