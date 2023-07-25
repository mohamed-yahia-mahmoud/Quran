import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:quran/config/locale/app_localizations.dart';
import 'package:quran/cores/utils/asset_manager.dart';
import 'package:quran/ui/screens/home_screen.dart';
import 'package:quran/ui/screens/settings_screen.dart';

class NavigationScreen extends StatefulWidget {
  final GetIt instance;
  const NavigationScreen({super.key, required this.instance});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final ValueNotifier<int> _currentNavigationIndex = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: _currentNavigationIndex,
        builder: (context, currentIndex, _) {
          return Scaffold(
            bottomNavigationBar: _bottomNavigation(currentIndex),
            body: SafeArea(
              child: LayoutBuilder(builder: (context, constraints) {
                return Container(
                  constraints: constraints,
                  child: IndexedStack(
                    index: currentIndex,
                    children: [
                      HomeScreen(
                        instance: widget.instance,
                      ),
                      SettingsScreen(instance: widget.instance)
                    ],
                  ),
                );
              }),
            ),
          );
        });
  }

  Widget _bottomNavigation(int currentIndex) {
    return BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          return onChangeNavigation(
              currentIndex: currentIndex, newIndexValue: value);
        },
        items: [
          BottomNavigationBarItem(
            icon: Image(
              image: currentIndex == 0
                  ? const AssetImage(
                      ImgAssets.homeFilled,
                    )
                  : const AssetImage(
                      ImgAssets.homeOutline,
                    ),
              width: 30,
              height: 30,
            ),
            label: AppLocalizations.of(context)!.translate('home')!,
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 1
                ? const Image(
                    image: AssetImage(
                      ImgAssets.moreFilled,
                    ),
                    width: 30,
                    height: 30,
                  )
                : const Image(
                    image: AssetImage(
                      ImgAssets.moreOutline,
                    ),
                    width: 30,
                    height: 30,
                  ),
            label: AppLocalizations.of(context)!.translate('more')!,
          )
        ]);
  }

  void onChangeNavigation({
    required int newIndexValue,
    required int currentIndex,
  }) {
    if (newIndexValue == currentIndex) {
      return;
    }
    setState(() {
      _currentNavigationIndex.value = newIndexValue;
    });
  }
}
