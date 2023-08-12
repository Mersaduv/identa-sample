import 'package:flutter/material.dart';
import 'package:identa/widgets/loading/skeleton.dart';

const double defaultPadding = 16.0;

class CardSkeltonProfile extends StatelessWidget {
  const CardSkeltonProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: defaultPadding / 1),
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
