import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:identa/widgets/tab_item.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key, required this.tabController}) : super(key: key);

  final TabController tabController;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 40.0);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      setState(() {
        _selectedTab = widget.tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0.0,
      title: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
        child: Row(
          children: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/menu.svg',
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                // Open the menu
              },
            ),
            SizedBox(width: 8.0),
            Text(
              'identa',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      centerTitle: false,
      elevation: 0.0,
      backgroundColor: const Color(0xFF2D9CDB),
      toolbarHeight: kToolbarHeight + 40.0,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.bottomCenter,
          child: TabBar(
            controller: widget.tabController,
            indicator: BoxDecoration(),
            tabs: [
              TabItem(
                title: 'Chat',
                isSelected: _selectedTab == 0,
                onTap: () {
                  widget.tabController.index = 0;
                },
              ),
              TabItem(
                title: 'Insights',
                isSelected: _selectedTab == 1,
                onTap: () {
                  widget.tabController.index = 1;
                },
              ),
              TabItem(
                title: 'Notes',
                isSelected: _selectedTab == 2,
                onTap: () {
                  widget.tabController.index = 2;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
