import 'package:blood_link/features/user/data/models/user_api_model.dart';

abstract interface class IUserDatasource {
  Future<UserApiModel?> getCurrentUserProfile();

  Future<UserApiModel?> lockDonorActiveRequest({
    required String userId,
    required String requestId,
  });

  Future<UserApiModel?> unlockDonorActiveRequest({
    required String userId,
    required String requestId,
  });
}
