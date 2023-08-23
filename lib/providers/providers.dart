import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jointact_case_study/repositories/admin_repository.dart';

final adminProvider = ChangeNotifierProvider((ref) {
  return AdminRepository();
});
