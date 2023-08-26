import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jointact_case_study/repositories/admin_repository.dart';
import 'package:jointact_case_study/repositories/user_repository.dart';

final adminProvider = ChangeNotifierProvider((ref) {
  return AdminRepository();
});

final userProvider = ChangeNotifierProvider((ref) {
  return UserRepository();
});
