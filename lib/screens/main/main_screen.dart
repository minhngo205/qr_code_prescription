import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
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

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
        boxShadow: _boxShadow(),
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.decelerate,
        duration: Duration(milliseconds: 200),
      ),
      onItemSelected: (value) => {
        if (value == 2)
          {
            _controller.index = _selectedIndex,
            Navigator.pushNamed(context, SplashPage.routeName)
          }
        else
          setState(() {
            _selectedIndex = value;
          })
      },
      navBarStyle: NavBarStyle.style16,
    );
  }

  Widget getBody() {
    switch (_selectedIndex) {
      case 0:
        return const HomeScreen();
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
      const HomeScreen(),
      const Notification(),
      getBody(),
      const Message(),
      const Profile(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.house_fill),
        inactiveIcon: const Icon(CupertinoIcons.house),
        title: ("Home"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.bell_fill),
        inactiveIcon: const Icon(CupertinoIcons.bell),
        title: ("Settings"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          CupertinoIcons.qrcode_viewfinder,
          color: CupertinoColors.white,
        ),
        activeColorPrimary: CupertinoColors.activeBlue,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.rectangle_3_offgrid_fill),
        inactiveIcon: const Icon(CupertinoIcons.rectangle_3_offgrid),
        title: ("Settings"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person_fill),
        inactiveIcon: const Icon(CupertinoIcons.person),
        title: ("Settings"),
        activeColorPrimary: CupertinoColors.activeBlue,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  List<BoxShadow> _boxShadow() {
    return [const BoxShadow(color: CupertinoColors.activeGreen)];
  }
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
