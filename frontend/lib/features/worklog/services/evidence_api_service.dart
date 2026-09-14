import '../../../core/api_client.dart';

class EvidenceFile {
  EvidenceFile.fromJson(Map<String, dynamic> json)
    : id = json['fileId'] as String,
      category = json['caseType'] as String? ?? '',
      path = json['storedPath'] as String,
      size = (json['sizeBytes'] as num).toInt();

  final String id;
  final String category;
  final String path;
  final int size;

  String get name => path
      .split('/')
      .last
      .replaceFirst(RegExp(r'^\d{8}T\d{6}Z_[a-f0-9]{32}_'), '');
}

class EvidenceApiService {
  EvidenceApiService({ApiClient? client}) : _client = client ?? ApiClient();
  final ApiClient _client;

  Map<String, String> _query(DateTime? day) => {
    if (day != null)
      'worklog_date':
          '${day.year.toString().padLeft(4, '0')}-'
          '${day.month.toString().padLeft(2, '0')}-'
          '${day.day.toString().padLeft(2, '0')}',
  };

  Future<List<EvidenceFile>> list(String token, {DateTime? day}) async {
    final json = await _client
        .getJson('/api/uploads', idToken: token, query: _query(day))
        .timeout(const Duration(seconds: 30));
    return (json as List)
        .map((item) => EvidenceFile.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<String> upload({
    required String token,
    required String category,
    required String filename,
    required List<int> bytes,
    required String contentType,
    DateTime? day,
  }) async {
    final json = await _client.uploadFile(
      '/api/uploads',
      idToken: token,
      filename: filename,
      bytes: bytes,
      contentType: contentType,
      query: {..._query(day), 'case_type': category},
    );
    return json['fileId'] as String;
  }

  void dispose() => _client.dispose();
}
