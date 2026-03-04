import 'package:blood_link/core/error/failures.dart';
import 'package:blood_link/core/services/connectivity/network_info.dart';
import 'package:blood_link/features/user/data/datasource/remote/user_remote_datasource.dart';
import 'package:blood_link/features/user/domain/entities/user_entity.dart';
import 'package:blood_link/features/user/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<IUserRepository>((ref) {
  return UserRepository(
    userRemoteDatasource: ref.read(userRemoteDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class UserRepository implements IUserRepository {
  final UserRemoteDatasource _userRemoteDatasource;
  final NetworkInfo _networkInfo;

  UserRepository({
    required UserRemoteDatasource userRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _userRemoteDatasource = userRemoteDatasource,
       _networkInfo = networkInfo;

  String _dioErrorMessage(
    DioException e, {
    String fallback = "Request failed",
  }) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data["message"];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }
      final errors = data["errors"];
      if (errors is String && errors.trim().isNotEmpty) {
        return errors.trim();
      }
    }
    return e.message?.trim().isNotEmpty == true ? e.message!.trim() : fallback;
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUserProfile() async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No Internet Connection"));
    }

    try {
      final user = await _userRemoteDatasource.getCurrentUserProfile();
      return Right(user?.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: _dioErrorMessage(
            e,
            fallback: "Failed to load current user profile",
          ),
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> lockDonorActiveRequest({
    required String userId,
    required String requestId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No Internet Connection"));
    }

    try {
      final user = await _userRemoteDatasource.lockDonorActiveRequest(
        userId: userId,
        requestId: requestId,
      );
      return Right(user?.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: _dioErrorMessage(
            e,
            fallback: "Failed to lock donor active request",
          ),
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> unlockDonorActiveRequest({
    required String userId,
    required String requestId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No Internet Connection"));
    }

    try {
      final user = await _userRemoteDatasource.unlockDonorActiveRequest(
        userId: userId,
        requestId: requestId,
      );
      return Right(user?.toEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: _dioErrorMessage(
            e,
            fallback: "Failed to unlock donor active request",
          ),
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
