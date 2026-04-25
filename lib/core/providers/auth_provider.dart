import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/domain/entities/app_user.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AppAuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  AppUser? _user;
  bool _loading = false;
  String? _error;

  AppAuthProvider(this._authService, this._firestoreService);

  AppUser? get user => _user;
  bool get loading => _loading;
  String? get error => _error;

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  void _setError(String? v) {
    _error = v;
    notifyListeners();
  }

  void clearError() => _setError(null);

  Future<void> loadCurrentUser() async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;
    try {
      final doc = await _firestoreService.getUser(uid);
      if (doc.exists && doc.data() != null) {
        _user = UserModel.fromMap(doc.data()!, uid);
        notifyListeners();
      } else {
        // Retry once — handles registration race condition
        await Future.delayed(const Duration(seconds: 1));
        final doc2 = await _firestoreService.getUser(uid);
        if (doc2.exists && doc2.data() != null) {
          _user = UserModel.fromMap(doc2.data()!, uid);
          notifyListeners();
        }
      }
    } catch (_) {}
  }

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      await _authService.signIn(email.trim(), password);
      await loadCurrentUser();
      _setLoading(false);
      return true;
    } on Exception catch (e) {
      _setError(_friendlyError(e.toString()));
      _setLoading(false);
      return false;
    }
  }

  Future<bool> registerManager({
    required String name,
    required String email,
    required String password,
    required String companyName,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final cred = await _authService.register(email.trim(), password);
      final uid = cred.user!.uid;
      final companyRef = _firestoreService.newCompanyRef();
      final companyId = companyRef.id;
      final now = DateTime.now();

      final batch = _firestoreService.batch();
      batch.set(companyRef, {
        'name': companyName.trim(),
        'ownerId': uid,
        'createdAt': Timestamp.fromDate(now),
      });
      batch.set(
        FirebaseFirestore.instance.collection('users').doc(uid),
        {
          'name': name.trim(),
          'email': email.trim(),
          'role': 'manager',
          'companyId': companyId,
          'createdAt': Timestamp.fromDate(now),
        },
      );
      await batch.commit();

      _user = UserModel(
        uid: uid,
        name: name.trim(),
        email: email.trim(),
        role: 'manager',
        companyId: companyId,
        createdAt: now,
      );
      _setLoading(false);
      return true;
    } on Exception catch (e) {
      _setError(_friendlyError(e.toString()));
      _setLoading(false);
      return false;
    }
  }

  Future<bool> registerWorker({
    required String name,
    required String email,
    required String password,
    required String companyId,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final companyDoc = await _firestoreService.getCompany(companyId.trim());
      if (!companyDoc.exists) {
        _setError('Geçersiz şirket kodu. Lütfen yöneticinizden alın.');
        _setLoading(false);
        return false;
      }

      final cred = await _authService.register(email.trim(), password);
      final uid = cred.user!.uid;
      final now = DateTime.now();

      await _firestoreService.setUser(uid, {
        'name': name.trim(),
        'email': email.trim(),
        'role': 'worker',
        'companyId': companyId.trim(),
        'createdAt': Timestamp.fromDate(now),
      });

      _user = UserModel(
        uid: uid,
        name: name.trim(),
        email: email.trim(),
        role: 'worker',
        companyId: companyId.trim(),
        createdAt: now,
      );
      _setLoading(false);
      return true;
    } on Exception catch (e) {
      _setError(_friendlyError(e.toString()));
      _setLoading(false);
      return false;
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    _setLoading(true);
    _setError(null);
    try {
      await _authService.sendPasswordReset(email.trim());
      _setLoading(false);
      return true;
    } on Exception catch (e) {
      _setError(_friendlyError(e.toString()));
      _setLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  String _friendlyError(String raw) {
    if (raw.contains('user-not-found') ||
        raw.contains('wrong-password') ||
        raw.contains('invalid-credential')) {
      return 'E-posta veya şifre hatalı.';
    }
    if (raw.contains('email-already-in-use')) return 'Bu e-posta zaten kayıtlı.';
    if (raw.contains('weak-password')) return 'Şifre en az 6 karakter olmalı.';
    if (raw.contains('invalid-email')) return 'Geçersiz e-posta adresi.';
    if (raw.contains('network')) return 'Ağ bağlantısı hatası.';
    return 'Bir hata oluştu. Lütfen tekrar deneyin.';
  }
}
