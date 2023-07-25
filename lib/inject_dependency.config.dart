// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i7;
import 'package:uuid/uuid.dart' as _i8;

import 'cores/env.dart' as _i4;
import 'cores/utils/uuid_generator.dart' as _i9;
import 'features/quran/data/quran_repository_impl.dart' as _i6;
import 'features/quran/domain/quran_repository.dart' as _i5;
import 'features/quran/domain/usecases/find_quran_by_resicuter_usecase.dart'
    as _i10;
import 'features/quran/domain/usecases/find_quran_usecase.dart' as _i11;
import 'features/quran/domain/usecases/get_resicuter_usecase.dart' as _i13;
import 'features/quran/states/quran_by_reciter/quran_by_reciter_bloc.dart'
    as _i14;
import 'features/quran/states/reciter_bloc/reciter_bloc.dart' as _i15;
import 'features/quran/states/search_bloc/search_bloc.dart' as _i16;
import 'features/settings/domain/get_dark_mode_setting_usecase.dart' as _i12;
import 'features/settings/domain/set_dark_mode_setting_usecase.dart' as _i17;
import 'features/settings/states/dark_mode_setting_cubit/dark_mode_setting_cubit.dart'
    as _i18;
import 'register_module.dart' as _i19;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// initializes the registration of main-scope dependencies inside of GetIt
Future<_i1.GetIt> $Init(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.factory<_i3.Dio>(() => registerModule.httpRestClient);
  gh.factory<_i4.Env>(() => registerModule.env);
  gh.lazySingleton<_i5.QuranRepository>(() => _i6.MusicRepositoryImpl(
        restApiClient: gh<_i3.Dio>(),
        env: gh<_i4.Env>(),
      ));
  await gh.factoryAsync<_i7.SharedPreferences>(
    () => registerModule.localStorage,
    preResolve: true,
  );
  gh.factory<_i8.Uuid>(() => registerModule.uuid);
  gh.factory<_i9.UUIDGenerator>(() => _i9.UUIDGenerator(uuid: gh<_i8.Uuid>()));
  gh.lazySingleton<_i10.FindQuranByRecicterUsecase>(
      () => _i10.FindQuranByRecicterUsecase(
            uuidGenerator: gh<_i9.UUIDGenerator>(),
            musicRepository: gh<_i5.QuranRepository>(),
          ));
  gh.lazySingleton<_i11.FindQuranUsecase>(() => _i11.FindQuranUsecase(
        uuidGenerator: gh<_i9.UUIDGenerator>(),
        musicRepository: gh<_i5.QuranRepository>(),
      ));
  gh.lazySingleton<_i12.GetDarkModeSettingUsecase>(
      () => _i12.GetDarkModeSettingUsecase(
            uuidGenerator: gh<_i9.UUIDGenerator>(),
            localStorage: gh<_i7.SharedPreferences>(),
          ));
  gh.lazySingleton<_i13.GetRecicterUsecase>(() => _i13.GetRecicterUsecase(
        uuidGenerator: gh<_i9.UUIDGenerator>(),
        musicRepository: gh<_i5.QuranRepository>(),
      ));
  gh.lazySingleton<_i14.QuranByReciterBloc>(() => _i14.QuranByReciterBloc(
      findQuranByRecicterUsecase: gh<_i10.FindQuranByRecicterUsecase>()));
  gh.lazySingleton<_i15.ReciterBloc>(() => _i15.ReciterBloc(
        getRecicterUsecase: gh<_i13.GetRecicterUsecase>(),
        songsByArtistBloc: gh<_i14.QuranByReciterBloc>(),
      ));
  gh.lazySingleton<_i16.SearchBloc>(
      () => _i16.SearchBloc(findQuranUsecase: gh<_i11.FindQuranUsecase>()));
  gh.lazySingleton<_i17.SetDarkModeSettingUsecase>(
      () => _i17.SetDarkModeSettingUsecase(
            uuidGenerator: gh<_i9.UUIDGenerator>(),
            localStorage: gh<_i7.SharedPreferences>(),
          ));
  gh.lazySingleton<_i18.DarkModeSettingCubit>(() => _i18.DarkModeSettingCubit(
        getDarkModeSettingUsecase: gh<_i12.GetDarkModeSettingUsecase>(),
        setDarkModeSettingUsecase: gh<_i17.SetDarkModeSettingUsecase>(),
      ));
  return getIt;
}

class _$RegisterModule extends _i19.RegisterModule {}
