import 'package:flutter/material.dart';
import 'package:flutter_task/screens/history_screen.dart';
import 'package:flutter_task/screens/home.dart';
import 'package:flutter_task/screens/recipient_screen.dart';
import 'package:flutter_task/screens/send_money_screen.dart';
import 'package:flutter_task/screens/setting_screen.dart';
import 'package:flutter_task/utils/app_colors.dart';
import 'package:flutter_task/utils/app_icons.dart';
import 'package:flutter_task/widgets/appbar.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int indexColor = 0;
  late List<Widget> screens;
  @override
  void initState() {
    super.initState();
    screens = [
      const Home(),
      const RecipientScreen(),
      const SendMoneyScreen(),
      const HistoryScreen(),
      const SettingScreen()
    ];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  const CustomAppBar(),
      body: screens[indexColor],
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(190, 93, 182, 233),
                blurRadius: 0,
                spreadRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                indexColor = 2;
              });
            },
            backgroundColor: AppColors.primary,
            shape: const CircleBorder(),
            elevation: 0,
            child: Transform.rotate(
              angle: 320 * (3.1416 / 180),
              child: const Icon(
                AppIcons.sendMoney,
                color: AppColors.background,
                size: 36, // Increase icon size
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: AppColors.cardBackground,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navBarItem(0, AppIcons.home, "Home"),
              navBarItem(1, AppIcons.recipient, "Recipient"),
              const Padding(
                padding: EdgeInsets.only(top: 35),
                child: Text(
                  "Send Money",
                  style: TextStyle(),
                ),
              ),
              navBarItem(3, AppIcons.history, "History"),
              navBarItem(4, AppIcons.settings, "Settings"),
            ],
          ),
        ),
      ),
    );
  }

  Widget navBarItem(int index, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          indexColor = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: indexColor == index ? AppColors.primary : AppColors.textHint,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: indexColor == index ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
