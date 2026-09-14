class BugReportEmail {
  const BugReportEmail({required this.title, required this.description});

  static const recipient = 'teameqlab@gmail.com';
  final String title;
  final String description;

  String get subject => '[Local Bridge Bug Report] ${title.trim()}';
  String get body => description.trim();

  // mailto의 공백은 +가 아닌 %20으로 인코딩해야 메일 앱에서 원문이 유지된다.
  Uri get uri => Uri(
    scheme: 'mailto',
    path: recipient,
    query: {'subject': subject, 'body': body}.entries
        .map(
          (entry) =>
              '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}',
        )
        .join('&'),
  );

  String get clipboardText => '$recipient\n$subject\n\n$body';
}
