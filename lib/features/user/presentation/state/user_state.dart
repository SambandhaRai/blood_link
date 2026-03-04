import 'package:blood_link/features/user/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

enum UserStatus { initial, loading, loaded, error }

class UserState extends Equatable {
  final UserStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final String? successMessage;

  const UserState({
    this.status = UserStatus.initial,
    this.user,
    this.errorMessage,
    this.successMessage,
  });

  UserState copyWith({
    UserStatus? status,
    UserEntity? user,
    bool resetUser = false,
    String? errorMessage,
    bool resetErrorMessage = false,
    String? successMessage,
    bool resetSuccessMessage = false,
  }) {
    return UserState(
      status: status ?? this.status,
      user: resetUser ? null : (user ?? this.user),
      errorMessage: resetErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      successMessage: resetSuccessMessage
          ? null
          : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage, successMessage];
}
