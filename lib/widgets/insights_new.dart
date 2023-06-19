import 'package:flutter/material.dart';

class NewInsightsDialog extends StatefulWidget {
  final Function(String) onCreate;

  const NewInsightsDialog({Key? key, required this.onCreate}) : super(key: key);

  @override
  _NewInsightsDialogState createState() => _NewInsightsDialogState();
}

class _NewInsightsDialogState extends State<NewInsightsDialog> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void createInsights() {
    final insightsName = _textEditingController.text.trim();
    if (insightsName.isNotEmpty) {
      widget.onCreate(insightsName);
      Navigator.pop(context); // Close the dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Insights'),
      content: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
          hintText: 'Insights Name',
          hintStyle: TextStyle(
            fontWeight: FontWeight.w300, // Set a lighter font weight
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.only(right: 8.0),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
            ),
            const SizedBox(width: 8.0), // Add some space between the buttons
            TextButton(
              child: const Text('Create'),
              onPressed: createInsights,
            ),
          ],
        ),
      ],
    );
  }
}
