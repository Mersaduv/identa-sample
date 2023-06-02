import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:identa/widgets/tab_item.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {Key? key, required this.tabController, required this.openDrawer})
      : super(key: key);

  final TabController tabController;
  final VoidCallback openDrawer;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 40.0);

  @override
  CustomAppBarState createState() => CustomAppBarState();
}

class CustomAppBarState extends State<CustomAppBar> {
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
      leading: IconButton(
        padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
        icon: SvgPicture.asset(
          'assets/menu.svg',
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
        onPressed: widget.openDrawer,
      ),
      titleSpacing: 0.0,
      title: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(bottom: 8.0),
        child: const Row(
          children: [
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
        preferredSize: const Size.fromHeight(40.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.bottomCenter,
          child: TabBar(
            controller: widget.tabController,
            indicator: const BoxDecoration(),
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
