import 'package:flutter/material.dart';
import '../../../common/widgets/app_card.dart';
import '../../../core/app_language.dart';
import '../../../theme/app_colors.dart';
import '../models/category_detail.dart';
import '../models/encyclopedia_strings.dart';

/// 카테고리 하위 문서 1개(예: "하이코리아 회원가입 & 비밀번호 찾기") 상세 화면.
class SubDocumentScreen extends StatefulWidget {
  const SubDocumentScreen({
    super.key,
    required this.doc,
    required this.language,
  });

  final SubDocument doc;
  final AppLanguage language;

  @override
  State<SubDocumentScreen> createState() => _SubDocumentScreenState();
}

class _SubDocumentScreenState extends State<SubDocumentScreen> {
  final _checked = <int>{};

  @override
  Widget build(BuildContext context) {
    final doc = widget.doc;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          doc.title.of(widget.language),
          style: const TextStyle(fontSize: 15),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Text(
            doc.description.of(widget.language),
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < doc.body.length; i++) ...[
                  if (i > 0)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 7),
                      child: Divider(height: 1),
                    ),
                  Text(
                    doc.body[i].of(widget.language),
                    style: const TextStyle(fontSize: 13, height: 1.55),
                  ),
                ],
              ],
            ),
          ),
          if (doc.checklist.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              EncyclopediaStrings.checklistTitle.of(widget.language),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            const SizedBox(height: 8),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (var i = 0; i < doc.checklist.length; i++)
                    CheckboxListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 13,
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: _checked.contains(i),
                      title: Text(
                        doc.checklist[i].of(widget.language),
                        style: const TextStyle(fontSize: 12.5),
                      ),
                      onChanged: (v) => setState(() {
                        if (v ?? false) {
                          _checked.add(i);
                        } else {
                          _checked.remove(i);
                        }
                      }),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
