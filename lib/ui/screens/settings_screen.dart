import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:quran/features/settings/states/dark_mode_setting_cubit/dark_mode_setting_cubit.dart';

import '../../config/locale/app_localizations.dart';
import '../../features/splash/presentation/cubit/locale_cubit.dart';

class SettingsScreen extends StatefulWidget {
  final GetIt instance;
  const SettingsScreen({super.key, required this.instance});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final DarkModeSettingCubit _darkModeSettingCubit =
      widget.instance.get<DarkModeSettingCubit>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          constraints: constraints,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              _darkModeSwitcher(),
            ],
          ),
        );
      },
    );
  }

  Widget _darkModeSwitcher() {
    return BlocBuilder<DarkModeSettingCubit, bool>(
      bloc: _darkModeSettingCubit,
      builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                        AppLocalizations.of(context)?.translate('dark_mode') ??
                            'Dark Mode')),
                Switch(
                    value: state,
                    onChanged: (value) {
                      _darkModeSettingCubit.setDarkModeSetting(value);
                      return;
                    })
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                        AppLocalizations.of(context)?.translate('language') ??
                            "Language")),
                Switch(
                    value: !(AppLocalizations.of(context)!.isEnLocale),
                    onChanged: (value) {
                      if (AppLocalizations.of(context)!.isEnLocale) {
                        BlocProvider.of<LocaleCubit>(context).toArabic();
                      } else {
                        BlocProvider.of<LocaleCubit>(context).toEnglish();
                      }
                    })
              ],
            ),
          ],
        );
      },
    );
  }
}
