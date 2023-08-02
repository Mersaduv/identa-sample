import 'package:flutter/material.dart';
import 'package:identa/classes/language_constants.dart';

class ShowCustomDialog {
  static Future<bool?> show(
      BuildContext context, String title, String content) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: Text(translation(context).no),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(translation(context).yes),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }
}
