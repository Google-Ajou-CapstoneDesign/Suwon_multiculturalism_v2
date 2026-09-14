import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:frontend/core/api_client.dart';
import 'package:frontend/features/worklog/services/evidence_api_service.dart';

void main() {
  test('upload uses authenticated multipart and FastAPI query names', () async {
    final api = EvidenceApiService(
      client: ApiClient(
        client: MockClient((request) async {
          expect(request.method, 'POST');
          expect(request.url.path, '/api/uploads');
          expect(request.url.queryParameters, {
            'case_type': 'worklog_photo',
            'worklog_date': '2026-09-03',
          });
          expect(request.headers['Authorization'], 'Bearer test-token');
          expect(
            request.headers['content-type'],
            startsWith('multipart/form-data; boundary='),
          );
          final body = utf8.decode(request.bodyBytes);
          expect(body, contains('name="file"; filename="contract.txt"'));
          expect(body, contains('content-type: text/plain'));
          expect(body, contains('원본 증빙 내용'));
          return http.Response(jsonEncode({'fileId': 'uploaded-id'}), 200);
        }),
      ),
    );
    addTearDown(api.dispose);
    expect(
      await api.upload(
        token: 'test-token',
        category: 'worklog_photo',
        filename: 'contract.txt',
        bytes: utf8.encode('원본 증빙 내용'),
        contentType: 'text/plain',
        day: DateTime(2026, 9, 3),
      ),
      'uploaded-id',
    );
  });

  test(
    'list retains filename underscores and filters by requested day on server',
    () async {
      final api = EvidenceApiService(
        client: ApiClient(
          client: MockClient((request) async {
            expect(request.method, 'GET');
            expect(request.url.queryParameters['worklog_date'], '2026-09-03');
            expect(request.headers['Authorization'], 'Bearer test-token');
            return http.Response.bytes(
              utf8.encode(
                jsonEncode([
                  {
                    'fileId': 'id',
                    'caseType': 'contract',
                    'sizeBytes': 42,
                    'storedPath':
                        'evidence/u/contract/20260903T010203Z_${'a' * 32}_근로_계약서.pdf',
                  },
                ]),
              ),
              200,
            );
          }),
        ),
      );
      addTearDown(api.dispose);
      final files = await api.list('test-token', day: DateTime(2026, 9, 3));
      expect(files.single.name, '근로_계약서.pdf');
      expect(files.single.category, 'contract');
      expect(files.single.size, 42);
    },
  );

  test('upload failures propagate without reporting success', () async {
    for (final status in [401, 413, 503]) {
      final api = EvidenceApiService(
        client: ApiClient(
          client: MockClient((_) async => http.Response('error', status)),
        ),
      );
      addTearDown(api.dispose);
      await expectLater(
        api.upload(
          token: 'token',
          category: 'contract',
          filename: 'a.pdf',
          bytes: [1, 2],
          contentType: 'application/pdf',
        ),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'status', status),
        ),
      );
    }
  });
}
