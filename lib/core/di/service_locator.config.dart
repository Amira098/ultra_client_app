// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;
import 'package:pretty_dio_logger/pretty_dio_logger.dart' as _i528;
import 'package:ultra_client/core/di/firebase_module.dart' as _i557;
import 'package:ultra_client/core/logger/logger_module.dart' as _i2;
import 'package:ultra_client/core/network/remote/api_manager.dart' as _i993;
import 'package:ultra_client/core/network/remote/dio_module.dart' as _i270;
import 'package:ultra_client/features/auth1/data/api/auth_retrofit_client.dart'
    as _i878;
import 'package:ultra_client/features/auth1/data/data_sources_imp/remote/remote_auth_data_source.dart'
    as _i442;
import 'package:ultra_client/features/auth1/data/data_sources_imp/remote/remote_auth_data_source_imp.dart'
    as _i617;
import 'package:ultra_client/features/auth1/presentation/view_model/register/register_cubit.dart'
    as _i48;
import 'package:ultra_client/features/auth1/presentation/view_model/sign_in_cubit.dart'
    as _i645;
import 'package:ultra_client/features/drawer_screen/data/api/drawer_retrofit_client.dart'
    as _i316;
import 'package:ultra_client/features/drawer_screen/data/data_sources_imp/remote/delete_account_data_sources.dart'
    as _i27;
import 'package:ultra_client/features/drawer_screen/data/data_sources_imp/remote/delete_account_data_sources_impl.dart'
    as _i344;
import 'package:ultra_client/features/drawer_screen/data/data_sources_imp/remote/remote_Drawer_data_source.dart'
    as _i1071;
import 'package:ultra_client/features/drawer_screen/data/data_sources_imp/remote/remote_Drawer_data_source_imp.dart'
    as _i141;
import 'package:ultra_client/features/drawer_screen/data/usecase/privacy_usecase.dart'
    as _i156;
import 'package:ultra_client/features/drawer_screen/data/usecase/terms-and-conditions_usecase.dart'
    as _i818;
import 'package:ultra_client/features/drawer_screen/presentation/view_model/contact_us_cubit/contact_us_cubit.dart'
    as _i941;
import 'package:ultra_client/features/drawer_screen/presentation/view_model/delete/delete_account_cubit.dart'
    as _i1048;
import 'package:ultra_client/features/drawer_screen/presentation/view_model/history/history_cubit.dart'
    as _i635;
import 'package:ultra_client/features/drawer_screen/presentation/view_model/privacy/privacy_cubit.dart'
    as _i94;
import 'package:ultra_client/features/drawer_screen/presentation/view_model/terms-and-conditions/terms_and_conditions_cubit.dart'
    as _i780;
import 'package:ultra_client/features/home_screen/data/api/home_retrofit_client.dart'
    as _i215;
import 'package:ultra_client/features/home_screen/data/data_sources_imp/home_data_sources.dart'
    as _i335;
import 'package:ultra_client/features/home_screen/data/data_sources_imp/home_data_sources_imp.dart'
    as _i779;
import 'package:ultra_client/features/home_screen/data/data_sources_imp/location_service.dart'
    as _i430;
import 'package:ultra_client/features/home_screen/data/data_sources_imp/trip_repository.dart'
    as _i885;
import 'package:ultra_client/features/home_screen/presentation/view_model/avalible_cars/avalible_cars_cubit.dart'
    as _i401;
import 'package:ultra_client/features/home_screen/presentation/view_model/cancell_trip/cancell_trip_cubit.dart'
    as _i453;
import 'package:ultra_client/features/home_screen/presentation/view_model/cancelling_reasons/cancelling_reasons_cubit.dart'
    as _i919;
import 'package:ultra_client/features/home_screen/presentation/view_model/confirm_locations/confirm_locations_cubit.dart'
    as _i777;
import 'package:ultra_client/features/home_screen/presentation/view_model/map/map_cubit.dart'
    as _i505;
import 'package:ultra_client/features/home_screen/presentation/view_model/select_car/select_car_cubit.dart'
    as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final firebaseModule = _$FirebaseModule();
    final loggerModule = _$LoggerModule();
    final dioModule = _$DioModule();
    gh.factory<_i430.LocationService>(() => _i430.LocationService());
    gh.singleton<_i993.ApiManager>(() => _i993.ApiManager());
    gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.lazySingleton<_i974.Logger>(() => loggerModule.loggerProvider);
    gh.lazySingleton<_i974.PrettyPrinter>(() => loggerModule.prettyPrinter);
    gh.lazySingleton<_i361.Dio>(() => dioModule.provideDio());
    gh.lazySingleton<_i528.PrettyDioLogger>(
        () => dioModule.providerInterceptor());
    gh.lazySingleton<_i885.TripRepository>(
        () => _i885.TripRepository(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i878.AuthRetrofitClient>(
        () => _i878.AuthRetrofitClient(gh<_i361.Dio>()));
    gh.lazySingleton<_i316.DrowerRetrofitClient>(
        () => _i316.DrowerRetrofitClient(gh<_i361.Dio>()));
    gh.lazySingleton<_i215.HomeRetrofitClient>(
        () => _i215.HomeRetrofitClient(gh<_i361.Dio>()));
    gh.factory<_i505.MapCubit>(() => _i505.MapCubit(
          locationService: gh<_i430.LocationService>(),
          tripRepository: gh<_i885.TripRepository>(),
        ));
    gh.factory<_i1071.RemoteDrawerDataSource>(
        () => _i141.RemoteDrawerDataSourceImp(
              gh<_i993.ApiManager>(),
              gh<_i316.DrowerRetrofitClient>(),
            ));
    gh.factory<_i941.ContactUsCubit>(
        () => _i941.ContactUsCubit(gh<_i1071.RemoteDrawerDataSource>()));
    gh.factory<_i156.PrivacyUseCase>(
        () => _i156.PrivacyUseCase(gh<_i1071.RemoteDrawerDataSource>()));
    gh.factory<_i818.termsAndConditionsUseCase>(() =>
        _i818.termsAndConditionsUseCase(gh<_i1071.RemoteDrawerDataSource>()));
    gh.factory<_i27.DeleteDataSources>(() => _i344.DeleteDataSourcesImpl(
          gh<_i316.DrowerRetrofitClient>(),
          gh<_i993.ApiManager>(),
        ));
    gh.factory<_i94.PrivacyCubit>(
        () => _i94.PrivacyCubit(gh<_i156.PrivacyUseCase>()));
    gh.factory<_i442.RemoteAuthDataSource>(() => _i617.RemoteAuthDataSourceImpl(
          gh<_i993.ApiManager>(),
          gh<_i878.AuthRetrofitClient>(),
        ));
    gh.factory<_i335.HomeDataSource>(() => _i779.HomeDataSourceImp(
          gh<_i215.HomeRetrofitClient>(),
          gh<_i993.ApiManager>(),
        ));
    gh.factory<_i48.RegisterCubit>(
        () => _i48.RegisterCubit(gh<_i442.RemoteAuthDataSource>()));
    gh.factory<_i645.LoginCubit>(
        () => _i645.LoginCubit(gh<_i442.RemoteAuthDataSource>()));
    gh.factory<_i635.HistoryCubit>(
        () => _i635.HistoryCubit(gh<_i1071.RemoteDrawerDataSource>()));
    gh.factory<_i777.ConfirmLocationsCubit>(
        () => _i777.ConfirmLocationsCubit(gh<_i335.HomeDataSource>()));
    gh.factory<_i780.TermsAndConditionsCubit>(() =>
        _i780.TermsAndConditionsCubit(gh<_i818.termsAndConditionsUseCase>()));
    gh.factory<_i1048.DeleteCubit>(
        () => _i1048.DeleteCubit(gh<_i27.DeleteDataSources>()));
    gh.factory<_i401.AvalibleCarsCubit>(
        () => _i401.AvalibleCarsCubit(gh<_i335.HomeDataSource>()));
    gh.factory<_i919.CancellingReasonsCubit>(
        () => _i919.CancellingReasonsCubit(gh<_i335.HomeDataSource>()));
    gh.factory<_i453.CancellTripCubit>(
        () => _i453.CancellTripCubit(gh<_i335.HomeDataSource>()));
    gh.factory<_i526.SelectCarCubit>(
        () => _i526.SelectCarCubit(gh<_i335.HomeDataSource>()));
    return this;
  }
}

class _$FirebaseModule extends _i557.FirebaseModule {}

class _$LoggerModule extends _i2.LoggerModule {}

class _$DioModule extends _i270.DioModule {}
