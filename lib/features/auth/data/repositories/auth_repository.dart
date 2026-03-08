import 'dart:io';

import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/services/connectivity/network_info.dart';
import 'package:blood_link/features/auth/data/datasources/auth_datasource.dart';
import 'package:blood_link/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:blood_link/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:blood_link/features/auth/data/models/auth_api_model.dart';
import 'package:blood_link/features/auth/data/models/auth_hive_model.dart';
import 'package:blood_link/features/auth/domain/entities/auth_entity.dart';
import 'package:blood_link/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository(
    authLocalDatasource: ref.read(authLocalDatasourceProvider),
    authRemoteDatasource: ref.read(authRemoteDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthLocalDatasource _authLocalDatasource;
  final IAuthRemoteDatasource _authRemoteDatasource;
  final NetworkInfo _networkInfo;

  AuthRepository({
    required IAuthLocalDatasource authLocalDatasource,
    required IAuthRemoteDatasource authRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _authLocalDatasource = authLocalDatasource,
       _authRemoteDatasource = authRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDatasource.getCurrentUser();
        if (apiModel != null) {
          final entity = apiModel.toEntity();
          return Right(entity);
        }
        return Left(ApiFailure(message: "User Not Found"));
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message:
                e.response?.data?["message"] ??
                e.message ??
                "Failed to fetch user",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No InternetConnect"));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDatasource.login(email, password);
        if (apiModel != null) {
          final entity = apiModel.toEntity();
          return Right(entity);
        }
        return Left(ApiFailure(message: "Invalid Credentials"));
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data['message'] ?? e.message ?? "Login Failed",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final user = await _authLocalDatasource.login(email, password);
        if (user != null) {
          final entity = user.toEntity();
          return Right(entity);
        }
        return Left(
          LocalDatabaseFailure(message: "Invalid email or password "),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = AuthApiModel.fromEntity(entity);
        await _authRemoteDatasource.register(apiModel);
        return Right(true);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message:
                e.response?.data['message'] ??
                e.message ??
                "Registration Failed",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final existingEmail = await _authLocalDatasource.getUserByEmail(
          entity.email,
        );
        final existingPhoneNumber = await _authLocalDatasource
            .getUserByPhoneNumber(entity.phoneNumber);
        if (existingEmail != null) {
          return Left(
            LocalDatabaseFailure(message: "Email already registered"),
          );
        }
        if (existingPhoneNumber != null) {
          return Left(
            LocalDatabaseFailure(message: "Phone number already registered"),
          );
        }

        final authModel = AuthHiveModel(
          fullName: entity.fullName,
          phoneNumber: entity.phoneNumber,
          dob: entity.dob,
          gender: entity.gender,
          bloodId: entity.bloodId,
          healthCondition: entity.healthCondition,
          email: entity.email,
          password: entity.password,
          profilePicture: entity.profilePicture,
        );
        await _authLocalDatasource.register(authModel);
        return Right(true);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _authLocalDatasource.logout();
      if (result) {
        return Right(true);
      }
      return Left(LocalDatabaseFailure(message: "Failed to logout user"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> uploadProfilePicture(File image) async {
    if (await _networkInfo.isConnected) {
      try {
        final fileName = await _authRemoteDatasource.uploadProfilePicture(
          image,
        );
        return Right(fileName);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message:
                e.response?.data?["message"] ?? e.message ?? "Upload Failed",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> updateUserProfile(AuthEntity entity) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = AuthApiModel.fromEntity(entity);
        final updated = await _authRemoteDatasource.updateUserProfile(apiModel);
        if (updated != null) {
          return Right(updated.toEntity());
        }
        return Left(ApiFailure(message: "Failed to update profile"));
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message:
                e.response?.data?["message"] ??
                e.message ??
                "Failed to update profile",
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return Left(ApiFailure(message: "No Internet Connection"));
    }
  }
}
