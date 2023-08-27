import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jointact_case_study/repositories/admin_repository.dart';
import 'package:jointact_case_study/repositories/user_repository.dart';

/// Bu provider nesnesi AdminRepository() sınıfını tutar ve
/// bu sınıfta yer alan değişken ve fonksiyonlara erişmeyi sağlar.
final adminProvider = ChangeNotifierProvider((ref) {
  return AdminRepository();
});

/// Bu provider nesnesi UserRepository() sınıfını tutar ve
/// bu sınıfta yer alan değişken ve fonksiyonlara erişmeyi sağlar.
final userProvider = ChangeNotifierProvider((ref) {
  return UserRepository();
});
