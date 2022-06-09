import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_prescription/components/default_button.dart';
import 'package:qr_code_prescription/components/fab_bottom_app_bar.dart';
import 'package:qr_code_prescription/screens/errors/connection_lost.dart';
import 'package:qr_code_prescription/screens/loading/loading_screen.dart';
import 'package:qr_code_prescription/screens/main/home_screen/home_screen.dart';
import 'package:qr_code_prescription/screens/main/user_profile/profile_screen.dart';
import 'package:qr_code_prescription/screens/qr_code_screen/qr_screen.dart';
import 'package:qr_code_prescription/services/dtos/prescription.dart';
import 'package:qr_code_prescription/services/dtos/user_info.dart';
import 'package:qr_code_prescription/services/storage/storage_service.dart';
import 'package:qr_code_prescription/services/user_service/user_service.dart';
import 'package:qr_code_prescription/utils/size_config.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static String routeName = "/main";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool isLoading = true;
  late UserInfo userInfo;
  late List<Prescription> listPres;

  loadData() async {
    StorageRepository storageRepository = StorageRepository();
    UserRepository userRepository = UserRepository();

    UserInfo? userFromStorage = await storageRepository.getUserInfo();
    if (userFromStorage != null) {
      debugPrint("Get user from storage");
      setState(() {
        userInfo = userFromStorage;
      });
    } else {
      UserInfo? userFromAPI = await userRepository.getUserInfo();
      if (userFromAPI != null) {
        debugPrint("Get user from API");
        setState(() {
          userInfo = userFromAPI;
        });
      } else {
        debugPrint("Error");
        Navigator.pushReplacementNamed(
          context,
          ConnectionFaildScreen.routeName,
        );
      }
    }

    userRepository.getUserPrescriptionList(1, 3).then((value) => {
          if (value != null)
            {
              setState(() {
                listPres = value;
                isLoading = false;
              })
            }
          else
            {
              setState(() {
                listPres = [];
                isLoading = false;
              })
            }
        });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return isLoading
        ? Loading(haveText: false)
        : Scaffold(
            body: _buildScreens().elementAt(_selectedIndex),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Visibility(
              visible: !keyboardIsOpen,
              child: FloatingActionButton(
                child: const Icon(CupertinoIcons.qrcode_viewfinder),
                onPressed: () {
                  Navigator.pushNamed(context, QRCodeScreen.routeName);
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

  List<Widget> _buildScreens() {
    return [
      HomeTab(
        userInfo: userInfo,
        listPres: listPres,
      ),
      const Notification(),
      const Message(),
      ProfileScreen(
        userInfo: userInfo,
      ),
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
      iconData: CupertinoIcons.calendar,
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
    return Center(
      child: DefaultButton(
        backgroundColor: CupertinoColors.activeBlue,
        text: "Test",
        textColor: CupertinoColors.white,
        press: () {
          StorageRepository storageRepository = StorageRepository();
          UserRepository repository = UserRepository();
          repository.getUserInfo();
          repository.getUserPrescriptionList(1, 3);
          storageRepository
              .getUserInfo()
              .then((value) => {debugPrint(value!.name)});
        },
      ),
    );
  }
}
