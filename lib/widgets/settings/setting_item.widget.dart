import 'package:flutter/material.dart';

class SettingItemWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onTapped;
  final IconData? prefixIcon;
  final bool isInRed;
  final Future<void>? Function() onPressed;
  const SettingItemWidget(
      {Key? key,
      required this.onPressed,
      this.onTapped,
      this.prefixIcon,
      required this.title,
      this.isInRed = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1))),
      width: double.infinity,
      child: InkWell(
        onTap: onTapped,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: prefixIcon != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 2, left: 8),
                          child: Icon(prefixIcon,
                              size: 22,
                              color: isInRed ? Colors.red : Colors.black),
                        )),
                    _title
                  ],
                )
              : _title,
        ),
      ),
    );
  }

  Widget get _title => Text(title,
      style: TextStyle(
          color: isInRed ? Colors.red : Colors.black,
          fontWeight: FontWeight.bold));
}
