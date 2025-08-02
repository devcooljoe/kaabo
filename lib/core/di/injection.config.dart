// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:kaabo/core/di/register_module.dart' as _i803;
import 'package:kaabo/core/services/cloudinary_service.dart' as _i330;
import 'package:kaabo/data/datasources/remote/auth_remote_datasource.dart'
    as _i868;
import 'package:kaabo/data/datasources/remote/property_service.dart' as _i204;
import 'package:kaabo/data/repositories/auth_repository_impl.dart' as _i158;
import 'package:kaabo/data/repositories/property_repository_impl.dart' as _i953;
import 'package:kaabo/data/repositories/review_repository_impl.dart' as _i702;
import 'package:kaabo/domain/repositories/auth_repository.dart' as _i442;
import 'package:kaabo/domain/repositories/property_repository.dart' as _i379;
import 'package:kaabo/domain/repositories/review_repository.dart' as _i937;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.lazySingleton<_i330.CloudinaryService>(() => _i330.CloudinaryService());
    gh.factory<_i204.PropertyService>(
      () => _i204.PropertyService(
        gh<_i974.FirebaseFirestore>(),
        gh<_i330.CloudinaryService>(),
      ),
    );
    gh.lazySingleton<_i868.AuthRemoteDataSource>(
      () => _i868.AuthRemoteDataSourceImpl(
        gh<_i59.FirebaseAuth>(),
        gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i442.AuthRepository>(
      () => _i158.AuthRepositoryImpl(gh<_i868.AuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i937.ReviewRepository>(
      () => _i702.ReviewRepositoryImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i379.PropertyRepository>(
      () => _i953.PropertyRepositoryImpl(gh<_i204.PropertyService>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i803.RegisterModule {}
