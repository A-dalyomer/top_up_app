import 'package:flutter/material.dart';

import '../../domain/entity/user.dart';
import '../../domain/repository/user_management_repository.dart';

class UserManagementProvider extends ChangeNotifier {
  UserManagementProvider(this.userManagementRepository) {
    initializeUser();
  }
  final UserManagementRepository userManagementRepository;

  late User user;
  bool finishedInitialization = false;
  bool userExists = false;

  Future<void> initializeUser() async {
    User? savedUser = await userManagementRepository.getCurrentUser();
    userExists = savedUser != null;
    if (userExists) user = savedUser!;
    finishedInitialization = true;
    notifyListeners();
  }
}
