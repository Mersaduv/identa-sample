import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const TabItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 4.0),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
              color: isSelected ? Colors.white : Colors.grey[300],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8.0),
            height:
                isSelected ? 3.0 : 0.0, // Adjust the height of the line here
            width: 120.0, // Adjust the width here
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 4,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ]
                  : [],
              borderRadius: isSelected
                  ? BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
