import 'dart:io';

import 'package:blood_link/app/routes/app_routes.dart';
import 'package:blood_link/app/theme/app_colors.dart';
import 'package:blood_link/core/api/api_endpoints.dart';
import 'package:blood_link/core/services/storage/user_session_service.dart';
import 'package:blood_link/core/utils/snackbar_utils.dart';
import 'package:blood_link/features/auth/presentation/pages/login_page.dart';
import 'package:blood_link/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  Widget _initialAvatar(String userName) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Text(
        userName.isNotEmpty ? userName[0].toUpperCase() : "U",
        style: const TextStyle(fontSize: 45),
      ),
    );
  }

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;

    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
      return false;
    }

    return false;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission Required"),
        content: const Text(
          "This feature requires permission to access your camera or gallery. Please enable it in your settings.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => openAppSettings(),
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  // code for camera
  Future<void> _pickFromCamera() async {
    final hasPermission = await _requestPermission(Permission.camera);
    if (!hasPermission) return;

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo != null) {
      await ref
          .read(authViewmodelProvider.notifier)
          .uploadProfilePicture(File(photo.path));

      if (mounted) setState(() {});
    }
  }

  // code for gallery
  Future<void> _pickFromGallery({bool allowMultiple = false}) async {
    try {
      if (allowMultiple) return;

      bool ok = await _requestPermission(Permission.photos);

      if (!ok) {
        ok = await _requestPermission(Permission.storage);
      }

      if (!ok) return;

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        await ref
            .read(authViewmodelProvider.notifier)
            .uploadProfilePicture(File(image.path));

        if (mounted) setState(() {});
      }
    } catch (e) {
      debugPrint("Gallery Error: $e");
      if (mounted) {
        SnackbarUtils.showError(
          context,
          "Unable to access gallery. Please try camera instead",
        );
      }
    }
  }

  Future<void> _pickMedia() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Take a photo"),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: const Text("Choose from gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final compact = screenWidth < 380;
    final coverHeight = compact ? 300.0 : 350.0;
    final avatarSize = compact ? 104.0 : 130.0;

    final userSessionService = ref.watch(userSessionServiceProvider);

    final userName = userSessionService.getCurrentUserFullName() ?? 'User';
    final userEmail =
        userSessionService.getCurrentUserEmail() ?? 'user@email.com';

    final profileFileName = userSessionService.getCurrentUserProfilePicture();
    final profileImageUrl =
        (profileFileName != null && profileFileName.isNotEmpty)
        ? ApiEndpoints.profilePicture(profileFileName)
        : null;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: coverHeight,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: compact ? 14 : 20),
                    Text(
                      "My Profile",
                      style: TextStyle(
                        fontFamily: "BricolageGrotesque SemiBold",
                        fontSize: compact ? 18 : 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: compact ? 18 : 25),

                    // Profile Picture (API only)
                    GestureDetector(
                      onTap: _pickMedia,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: avatarSize,
                            height: avatarSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x33000000),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: (profileImageUrl != null)
                                  ? Image.network(
                                      profileImageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, error, stackTrace) =>
                                          _initialAvatar(userName),
                                    )
                                  : _initialAvatar(userName),
                            ),
                          ),

                          // little camera icon
                          Container(
                            margin: const EdgeInsets.only(right: 6, bottom: 6),
                            padding: EdgeInsets.all(compact ? 6 : 7),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: compact ? 16 : 18,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: compact ? 10 : 15),
                    Text(
                      userName,
                      style: TextStyle(
                        fontFamily: "BricolageGrotesque SemiBold",
                        fontSize: compact ? 21 : 25,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      userEmail,
                      style: TextStyle(
                        fontFamily: "BricolageGrotesque Light",
                        fontSize: compact ? 13 : 14,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  compact ? 20 : 28,
                  16,
                  compact ? 24 : 32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Manage your account settings and sign out securely.",
                              style: TextStyle(
                                fontSize: compact ? 13 : 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () => _showLogoutDialog(context),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.logout, size: compact ? 18 : 20),
                                const SizedBox(width: 6),
                                Text(
                                  "Logout",
                                  style: TextStyle(fontSize: compact ? 14 : 15),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Logout',
          style: TextStyle(fontFamily: "BricolageGrotesque Bold"),
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref.read(authViewmodelProvider.notifier).logout();
              if (context.mounted) {
                AppRoutes.pushAndRemoveUntil(context, const LoginPage());
              }
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.green,
                fontFamily: "BricolageGrotesque Bold",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
