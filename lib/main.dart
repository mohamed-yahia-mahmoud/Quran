import 'package:quran/features/quran/states/quran_by_reciter/quran_by_reciter_bloc.dart';
import 'package:quran/features/quran/states/reciter_bloc/reciter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:quran/cores/theme.dart';
import 'package:quran/features/quran/states/search_bloc/search_bloc.dart';
import 'package:quran/features/settings/states/dark_mode_setting_cubit/dark_mode_setting_cubit.dart';
import 'package:quran/inject_dependency.dart';
import 'package:quran/ui/screens/navigation_screen.dart';
import 'config/locale/app_localizations_setup.dart';
import 'features/splash/presentation/cubit/locale_cubit.dart';
import 'injection_container.dart' as di;

class BlocObs extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint(
        "Bloc ${bloc.runtimeType}{currentState : ${change.currentState}, nextState ${change.nextState} }");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await initDependency();
  Bloc.observer = BlocObs();
  runApp(MyApp(
    instance: getIt,
  ));
}

class MyApp extends StatelessWidget {
  late final DarkModeSettingCubit darkModeSettingCubit =
      instance.get<DarkModeSettingCubit>();
  final GetIt instance;
  MyApp({super.key, required this.instance});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ReciterBloc>(create: (_) => instance.get<ReciterBloc>()),
        BlocProvider<QuranByReciterBloc>(
            create: (_) => instance.get<QuranByReciterBloc>()),
        BlocProvider<SearchBloc>(create: (_) => instance.get<SearchBloc>()),
        BlocProvider<DarkModeSettingCubit>.value(value: darkModeSettingCubit),
        BlocProvider<LocaleCubit>(create: (context) => di.sl<LocaleCubit>()),
      ],
      child: BlocBuilder<DarkModeSettingCubit, bool>(
        builder: (context, isDarkModeActive) {
          return BlocBuilder<LocaleCubit, LocaleState>(
            buildWhen: (previousState, currentState) {
              return previousState != currentState;
            },
            builder: (context, state) {
              return MaterialApp(
                title: 'Quran',
                theme: AppTheme.fromIsDarkModeActive(isDarkModeActive).theme,
                home: NavigationScreen(instance: instance),
                debugShowCheckedModeBanner: false,
                locale: state.locale,
                supportedLocales: AppLocalizationsSetup.supportedLocales,
                localeResolutionCallback:
                    AppLocalizationsSetup.localeResolutionCallback,
                localizationsDelegates:
                    AppLocalizationsSetup.localizationsDelegates,
              );
            },
          );
        },
      ),
    );
  }
}
