import 'package:blood_link/features/auth/domain/entities/auth_entity.dart';
import 'package:equatable/equatable.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  registered,
  loaded,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthEntity? authEntity;
  final String? uploadProfilePictureName;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.authEntity,
    this.uploadProfilePictureName,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    AuthEntity? authEntity,
    String? uploadProfilePictureName,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      authEntity: authEntity ?? this.authEntity,
      errorMessage: errorMessage ?? this.errorMessage,
      uploadProfilePictureName:
          uploadProfilePictureName ?? this.uploadProfilePictureName,
    );
  }

  @override
  List<Object?> get props => [
    status,
    authEntity,
    uploadProfilePictureName,
    errorMessage,
  ];
}
