import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:identa/constants/colors.dart';
import 'package:identa/constants/text_styles.dart';
import 'package:identa/core/models/model_core/tap_data.dart';
import 'package:identa/modules/tab_item.dart';

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
  List<TabData> tabDataList = [
    TabData(title: 'Chat'),
    TabData(title: 'Insights'),
    TabData(title: 'Notes'),
  ];

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
          color: Colors.white,
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
            Text('identa', style: MyTextStyles.appbar),
          ],
        ),
      ),
      centerTitle: false,
      elevation: 0.0,
      backgroundColor: MyColors.primaryColor,
      toolbarHeight: kToolbarHeight + 40.0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.bottomCenter,
          child: TabBar(
            controller: widget.tabController,
            indicator: const BoxDecoration(),
            tabs: List.generate(
              tabDataList.length,
              (index) => TabItem(
                title: tabDataList[index].title,
                isSelected: _selectedTab == index,
                onTap: () {
                  widget.tabController.index = index;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
