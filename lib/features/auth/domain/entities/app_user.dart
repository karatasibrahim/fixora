class AppUser {
  final String uid;
  final String name;
  final String email;
  final String role; // 'manager' | 'worker'
  final String companyId;
  final String jobTitle;
  final DateTime createdAt;

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.companyId,
    required this.createdAt,
    this.jobTitle = '',
  });

  bool get isManager => role == 'manager';

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  AppUser copyWith({String? name, String? jobTitle}) => AppUser(
        uid: uid,
        name: name ?? this.name,
        email: email,
        role: role,
        companyId: companyId,
        jobTitle: jobTitle ?? this.jobTitle,
        createdAt: createdAt,
      );
}
