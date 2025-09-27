import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/dhikr.dart';
import '../../shared/providers/custom_dhikr_provider.dart';
import '../../l10n/generated/app_localizations.dart';

class CustomDhikrScreen extends ConsumerStatefulWidget {
  const CustomDhikrScreen({super.key});

  @override
  ConsumerState<CustomDhikrScreen> createState() => _CustomDhikrScreenState();
}

class _CustomDhikrScreenState extends ConsumerState<CustomDhikrScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _arabicTextController = TextEditingController();
  final _transliterationController = TextEditingController();
  final _meaningController = TextEditingController();
  final _sourceController = TextEditingController();
  final _benefitsController = TextEditingController();
  final _targetCountController = TextEditingController(text: '33');

  String _selectedCategory = 'general_dhikr';
  bool _isLoading = false;

  final List<Map<String, String>> _categories = [
    {'id': 'tasbih_classical', 'name': 'Classical Tasbih'},
    {'id': 'morning_adhkar', 'name': 'Morning Adhkar'},
    {'id': 'evening_adhkar', 'name': 'Evening Adhkar'},
    {'id': 'general_dhikr', 'name': 'General Dhikr'},
    {'id': 'custom', 'name': 'Custom Category'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _arabicTextController.dispose();
    _transliterationController.dispose();
    _meaningController.dispose();
    _sourceController.dispose();
    _benefitsController.dispose();
    _targetCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.customDhikr),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveDhikr,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Basic Information'),
              _buildBasicInfoSection(),
              const SizedBox(height: 24),
              _buildSectionTitle('Arabic Text & Translation'),
              _buildTextSection(),
              const SizedBox(height: 24),
              _buildSectionTitle('Additional Information'),
              _buildAdditionalInfoSection(),
              const SizedBox(height: 24),
              _buildSectionTitle('Settings'),
              _buildSettingsSection(),
              const SizedBox(height: 32),
              _buildPreviewSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title *',
                hintText: 'Enter dhikr title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category['id'],
                  child: Text(category['name']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _arabicTextController,
              decoration: const InputDecoration(
                labelText: 'Arabic Text *',
                hintText: 'سُبْحَانَ اللَّهِ',
                border: OutlineInputBorder(),
              ),
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Amiri',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Arabic text is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _transliterationController,
              decoration: const InputDecoration(
                labelText: 'Transliteration',
                hintText: 'Subhan Allah',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _meaningController,
              decoration: const InputDecoration(
                labelText: 'Meaning',
                hintText: 'Glory be to Allah',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _sourceController,
              decoration: const InputDecoration(
                labelText: 'Source Reference',
                hintText: 'Quran 17:44, Sahih Bukhari...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _benefitsController,
              decoration: const InputDecoration(
                labelText: 'Benefits',
                hintText: 'Spiritual purification, protection...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _targetCountController,
              decoration: const InputDecoration(
                labelText: 'Target Count *',
                hintText: '33',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Target count is required';
                }
                final count = int.tryParse(value);
                if (count == null || count <= 0) {
                  return 'Please enter a valid positive number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Card(
      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.preview, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Preview',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  if (_titleController.text.isNotEmpty) ...[
                    Text(
                      _titleController.text,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (_arabicTextController.text.isNotEmpty) ...[
                    Text(
                      _arabicTextController.text,
                      style: const TextStyle(
                        fontSize: 24,
                        fontFamily: 'Amiri',
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (_transliterationController.text.isNotEmpty) ...[
                    Text(
                      _transliterationController.text,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (_meaningController.text.isNotEmpty) ...[
                    Text(
                      _meaningController.text,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (_targetCountController.text.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'Target: ${_targetCountController.text}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveDhikr() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final benefits = _benefitsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final dhikr = Dhikr.create(
        titleKey: _titleController.text.trim(),
        arabicText: _arabicTextController.text.trim(),
        targetCount: int.parse(_targetCountController.text),
        categoryId: _selectedCategory,
        transliteration: _transliterationController.text.trim().isEmpty
            ? null
            : _transliterationController.text.trim(),
        meaningKey: _meaningController.text.trim().isEmpty
            ? null
            : _meaningController.text.trim(),
        sourceReference: _sourceController.text.trim().isEmpty
            ? null
            : _sourceController.text.trim(),
        benefits: benefits,
        isCustom: true,
      );

      await ref.read(customDhikrProvider.notifier).addCustomDhikr(dhikr);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Custom dhikr saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving dhikr: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}