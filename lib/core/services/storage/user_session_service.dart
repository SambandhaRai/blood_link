import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences instance provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

// UserSessionService Provider
final userSessionServiceProvider = Provider<UserSessionService>((ref) {
  return UserSessionService(prefs: ref.read(sharedPreferencesProvider));
});

class UserSessionService {
  final SharedPreferences _prefs;

  // Keys for storing user data
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserFullName = 'user_full_name';
  static const String _keyUserPhoneNumber = 'user_phone_number';
  static const String _keyUserGender = 'user_gender';
  static const String _keyUserBloodId = 'user_blood_id';
  static const String _keyUserDob = 'user_dob';
  static const String _keyUserHealthCondition = 'user_health_condition';
  static const String _keyUserProfilePicture = 'user_profile_picture';

  UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

  // Save user session after login
  Future<void> saveUserSession({
    required String userId,
    required String email,
    required String fullName,
    required String phoneNumber,
    String? gender,
    String? bloodId,
    String? dob,
    String? healthCondition,
    String? profilePicture,
  }) async {
    await _prefs.setBool(_keyIsLoggedIn, true);
    await _prefs.setString(_keyUserId, userId);
    await _prefs.setString(_keyUserEmail, email);
    await _prefs.setString(_keyUserFullName, fullName);
    await _prefs.setString(_keyUserPhoneNumber, phoneNumber);
    if (healthCondition != null) {
      await _prefs.setString(_keyUserHealthCondition, healthCondition);
    }
    if (dob != null) {
      await _prefs.setString(_keyUserDob, dob);
    }
    if (gender != null) {
      await _prefs.setString(_keyUserGender, gender);
    }
    if (bloodId != null) {
      await _prefs.setString(_keyUserBloodId, bloodId);
    }
    if (profilePicture != null) {
      await _prefs.setString(_keyUserProfilePicture, profilePicture);
    }
  }

  // Check if user is logged in
  bool isUserLoggedIn() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Get current user id
  String? getCurrentUserId() {
    return _prefs.getString(_keyUserId);
  }

  // Get current user email
  String? getCurrentUserEmail() {
    return _prefs.getString(_keyUserEmail);
  }

  // Get current user full name
  String? getCurrentUserFullName() {
    return _prefs.getString(_keyUserFullName);
  }

  // Get current user phone number
  String? getCurrentUserPhoneNumber() {
    return _prefs.getString(_keyUserPhoneNumber);
  }

  // Get current user gender
  String? getCurrentUserGender() {
    return _prefs.getString(_keyUserGender);
  }

  // Get current user blood id
  String? getCurrentUserBloodId() {
    return _prefs.getString(_keyUserBloodId);
  }

  // Get current user dob
  String? getCurrentUserDob() {
    return _prefs.getString(_keyUserDob);
  }

  // Get current user health condition
  String? getCurrentUserHealthCondition() {
    return _prefs.getString(_keyUserHealthCondition);
  }

  // Get current user profile picture
  String? getCurrentUserProfilePicture() {
    return _prefs.getString(_keyUserProfilePicture);
  }

  // Clear user session on logout
  Future<void> clearUserSession() async {
    await _prefs.remove(_keyIsLoggedIn);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserFullName);
    await _prefs.remove(_keyUserPhoneNumber);
    await _prefs.remove(_keyUserGender);
    await _prefs.remove(_keyUserBloodId);
    await _prefs.remove(_keyUserDob);
    await _prefs.remove(_keyUserHealthCondition);
    await _prefs.remove(_keyUserProfilePicture);
  }
}
