import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/question.dart';
import '../providers/locale_provider.dart';
import '../providers/question_provider.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  String? _selectedTopicSlug;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locale = context.read<LocaleProvider>().languageCode;
      context.read<QuestionProvider>().loadTopics(locale: locale);
      context.read<QuestionProvider>().loadQuestions(locale: locale);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final locale = context.read<LocaleProvider>().languageCode;
    context.read<QuestionProvider>().loadQuestions(
          locale: locale,
          search: _searchController.text.trim(),
          topicSlug: _selectedTopicSlug,
        );
  }

  void _onTopicChanged(String? slug) {
    setState(() => _selectedTopicSlug = slug);
    final locale = context.read<LocaleProvider>().languageCode;
    context.read<QuestionProvider>().loadQuestions(
          locale: locale,
          search: _searchController.text.trim(),
          topicSlug: slug,
        );
  }

  void _openAskDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const _AskQuestionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final prov = context.watch<QuestionProvider>();
    final locale = Localizations.localeOf(context).languageCode;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Ask Button
            LayoutBuilder(
              builder: (context, constraints) {
                final isSmall = constraints.maxWidth < 650;

                return Flex(
                  direction: isSmall ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: isSmall ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.help_outline, color: Color(0xFF0F766E), size: 26),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          l10n?.questions ?? 'Tanya Jawab Masyarakat',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    if (isSmall) const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D9488),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _openAskDialog,
                      icon: const Icon(Icons.add_comment_outlined, size: 18),
                      label: Text(
                        l10n?.askQuestion ?? 'Ajukan Pertanyaan',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 28),

            // Search & Filter
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (_) => _onSearch(),
                    decoration: InputDecoration(
                      hintText: l10n?.searchPlaceholder ?? 'Cari pertanyaan atau kata kunci...',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF0F766E)),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _onSearch,
                  child: Text(l10n?.search ?? 'Cari'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Topic Chips
            if (prov.topics.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _topicChip(
                      label: l10n?.allTopics ?? 'Semua Topik',
                      isSelected: _selectedTopicSlug == null,
                      onTap: () => _onTopicChanged(null),
                    ),
                    ...prov.topics.map(
                      (t) => _topicChip(
                        label: t.name,
                        isSelected: _selectedTopicSlug == t.slug,
                        onTap: () => _onTopicChanged(t.slug),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 32),

            // Questions List
            if (prov.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(60),
                  child: CircularProgressIndicator(color: Color(0xFF0F766E)),
                ),
              )
            else if (prov.questions.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(60),
                  child: Column(
                    children: [
                      Icon(Icons.speaker_notes_off_outlined, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        l10n?.noQuestionsFound ?? 'Belum ada pertanyaan ditemukan.',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: prov.questions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final q = prov.questions[index];
                  return _buildQuestionCard(context, q, locale, l10n);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(
    BuildContext context,
    Question q,
    String locale,
    AppLocalizations? l10n,
  ) {
    String dateStr = '';
    if (q.createdAt != null) {
      dateStr = DateFormat('d MMM yyyy', locale).format(q.createdAt!);
    }

    final hasAnswer = q.answer != null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header info
          Row(
            children: [
              if (q.topic != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    q.topic!.name,
                    style: const TextStyle(
                      color: Color(0xFF0F766E),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: hasAnswer ? Colors.green.shade50 : Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: hasAnswer ? Colors.green.shade200 : Colors.amber.shade200,
                  ),
                ),
                child: Text(
                  hasAnswer ? (l10n?.answered ?? 'Sudah Dijawab') : (l10n?.pending ?? 'Menunggu'),
                  style: TextStyle(
                    color: hasAnswer ? Colors.green.shade800 : Colors.amber.shade800,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Subject
          InkWell(
            onTap: () => context.go('/questions/${q.id}'),
            child: Text(
              q.subject,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Question Body
          Text(
            q.body,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
          ),
          const SizedBox(height: 14),

          // Question Meta: Ask by, date
          Row(
            children: [
              Icon(Icons.person_outline, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(
                q.name,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              if (dateStr.isNotEmpty) ...[
                const SizedBox(width: 12),
                Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(
                  dateStr,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ],
          ),

          // Answer box if answered
          if (hasAnswer) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDFA),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFCCFBF1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.verified, size: 16, color: Color(0xFF0F766E)),
                      const SizedBox(width: 6),
                      Text(
                        '${l10n?.answer ?? "Jawaban:"} (${q.answer!.officerName})',
                        style: const TextStyle(
                          color: Color(0xFF0F766E),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    q.answer!.body,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade800,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _topicChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: const Color(0xFF0D9488),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade800,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class _AskQuestionDialog extends StatefulWidget {
  const _AskQuestionDialog();

  @override
  State<_AskQuestionDialog> createState() => _AskQuestionDialogState();
}

class _AskQuestionDialogState extends State<_AskQuestionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  int? _selectedTopicId;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _subjectCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTopicId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap pilih topik pertanyaan.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final locale = context.read<LocaleProvider>().languageCode;

    final success = await context.read<QuestionProvider>().submitQuestion(
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
          topicId: _selectedTopicId!,
          subject: _subjectCtrl.text.trim(),
          body: _bodyCtrl.text.trim(),
          locale: locale,
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      Navigator.of(context).pop();
      final l10n = AppLocalizations.of(context);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n?.formSuccessTitle ?? 'Pertanyaan Terkirim!'),
          content: Text(
            l10n?.formSuccessMsg ??
                'Terima kasih, pertanyaan Anda telah berhasil dikirim dan akan dijawab oleh tim kami.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengirim pertanyaan. Silakan coba beberapa saat lagi.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final topics = context.watch<QuestionProvider>().topics;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 580),
        padding: const EdgeInsets.all(28),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n?.askQuestion ?? 'Ajukan Pertanyaan',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Name
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    labelText: l10n?.formName ?? 'Nama Lengkap *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? (l10n?.formValidationRequired ?? 'Wajib') : null,
                ),
                const SizedBox(height: 16),

                // Email & Phone
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: l10n?.formEmail ?? 'Email *',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return l10n?.formValidationRequired ?? 'Wajib';
                          }
                          if (!v.contains('@')) {
                            return l10n?.formValidationEmail ?? 'Email tidak valid';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: l10n?.formPhone ?? 'No. Telepon (Opsional)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Topic Dropdown
                DropdownButtonFormField<int>(
                  value: _selectedTopicId,
                  decoration: InputDecoration(
                    labelText: l10n?.formTopic ?? 'Topik Pertanyaan *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: topics.map((t) {
                    return DropdownMenuItem<int>(
                      value: t.id,
                      child: Text(t.name),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedTopicId = val),
                  validator: (v) => v == null ? (l10n?.formValidationRequired ?? 'Pilih topik') : null,
                ),
                const SizedBox(height: 16),

                // Subject
                TextFormField(
                  controller: _subjectCtrl,
                  decoration: InputDecoration(
                    labelText: 'Subjek Pertanyaan *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? (l10n?.formValidationRequired ?? 'Wajib') : null,
                ),
                const SizedBox(height: 16),

                // Body
                TextFormField(
                  controller: _bodyCtrl,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: l10n?.formQuestion ?? 'Isi Pertanyaan *',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? (l10n?.formValidationRequired ?? 'Wajib') : null,
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D9488),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            l10n?.formSubmit ?? 'Kirim Pertanyaan',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

