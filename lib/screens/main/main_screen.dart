import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:qr_code_prescription/components/fab_bottom_app_bar.dart';
import 'package:qr_code_prescription/screens/main/home_screen.dart';
import 'package:qr_code_prescription/screens/splash/splash_screen.dart';
import 'package:qr_code_prescription/utils/size_config.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static String routeName = "/main";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: _buildScreens().elementAt(_selectedIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: !keyboardIsOpen,
        child: FloatingActionButton(
          child: const Icon(CupertinoIcons.qrcode_viewfinder),
          onPressed: () {
            Navigator.pushNamed(context, SplashPage.routeName);
          },
        ),
      ),
      bottomNavigationBar: FABBottomAppBar(
        items: _navBarsItems,
        centerItemText: "",
        backgroundColor: CupertinoColors.white,
        color: CupertinoColors.inactiveGray,
        selectedColor: CupertinoColors.activeBlue,
        notchedShape: const CircularNotchedRectangle(),
        onTabSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
      ),
    );
  }

  Widget getBody() {
    switch (_selectedIndex) {
      case 0:
        return const HomeTab();
      case 1:
        return const Notification();
      case 3:
        return const Message();
      case 4:
        return const Profile();
      default:
        return const Home();
    }
  }

  List<Widget> _buildScreens() {
    return [
      const HomeTab(),
      const Notification(),
      const Message(),
      const Profile(),
    ];
  }

  final List<FABBottomAppBarItem> _navBarsItems = [
    FABBottomAppBarItem(
      iconData: CupertinoIcons.home,
      text: 'Trang chủ',
    ),
    FABBottomAppBarItem(
      iconData: CupertinoIcons.bell,
      text: 'Thông báo',
    ),
    FABBottomAppBarItem(
      iconData: CupertinoIcons.rectangle_3_offgrid,
      text: 'Danh mục',
    ),
    FABBottomAppBarItem(
      iconData: CupertinoIcons.person,
      text: 'Cá nhân',
    ),
  ];
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Home"));
  }
}

class Notification extends StatelessWidget {
  const Notification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Notifications"));
  }
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Profile"));
  }
}

class Message extends StatelessWidget {
  const Message({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Message"));
  }
}
