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
  final bool biometricAvailable;
  final bool biometricEnabled;
  final bool biometricLoading;

  const AuthState({
    this.status = AuthStatus.initial,
    this.authEntity,
    this.uploadProfilePictureName,
    this.errorMessage,
    this.biometricAvailable = false,
    this.biometricEnabled = false,
    this.biometricLoading = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    AuthEntity? authEntity,
    String? uploadProfilePictureName,
    String? errorMessage,
    bool clearError = false,
    bool? biometricAvailable,
    bool? biometricEnabled,
    bool? biometricLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      authEntity: authEntity ?? this.authEntity,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      uploadProfilePictureName:
          uploadProfilePictureName ?? this.uploadProfilePictureName,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      biometricLoading: biometricLoading ?? this.biometricLoading,
    );
  }

  @override
  List<Object?> get props => [
    status,
    authEntity,
    uploadProfilePictureName,
    errorMessage,
    biometricAvailable,
    biometricEnabled,
    biometricLoading,
  ];
}
