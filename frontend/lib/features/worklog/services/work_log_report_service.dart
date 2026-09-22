import '../../auth/services/auth_service.dart';
import '../data/demo_work_records.dart';
import '../models/work_log_report.dart';
import 'work_log_api_service.dart';

typedef WorkLogReportLoader =
    Future<WorkLogReport> Function(String? uid, String ownerName);

Future<WorkLogReport> loadWorkLogReport(String? uid, String ownerName) async {
  final now = DateTime.now().toUtc().add(const Duration(hours: 9));
  if (uid == null) {
    return WorkLogReport(
      generatedAt: now,
      isDemo: true,
      ownerName: 'DEMO',
      userId: null,
      records: demoWorkRecords(now),
    );
  }
  final auth = AuthService();
  if (auth.currentUser?.uid != uid) throw StateError('Account changed');
  final token = await auth.currentIdToken();
  if (token == null) throw StateError('Sign-in required');
  final api = WorkLogApiService();
  try {
    final records = await api.fetchRecent30Days(idToken: token, today: now);
    if (auth.currentUser?.uid != uid) throw StateError('Account changed');
    return WorkLogReport(
      generatedAt: now,
      isDemo: false,
      ownerName: ownerName,
      userId: uid,
      records: records,
    );
  } finally {
    api.dispose();
  }
}
