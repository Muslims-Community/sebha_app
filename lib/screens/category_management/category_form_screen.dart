import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../main.dart';
import '../../shared/providers/custom_categories_provider.dart';

class CategoryFormScreen extends ConsumerStatefulWidget {
  final DhikrCategory? categoryToEdit;

  const CategoryFormScreen({
    super.key,
    this.categoryToEdit,
  });

  @override
  ConsumerState<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends ConsumerState<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<DhikrFormData> _dhikrs = [];

  bool get _isEditing => widget.categoryToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.categoryToEdit!.title;
      _descriptionController.text = widget.categoryToEdit!.description;
      _dhikrs.addAll(
        widget.categoryToEdit!.dhikrs.map((dhikr) => DhikrFormData.fromDhikr(dhikr)),
      );
    } else {
      _addNewDhikr();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addNewDhikr() {
    setState(() {
      _dhikrs.add(DhikrFormData());
    });
  }

  void _removeDhikr(int index) {
    if (_dhikrs.length > 1) {
      setState(() {
        _dhikrs.removeAt(index);
      });
    }
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_dhikrs.isEmpty || !_dhikrs.every((dhikr) => dhikr.isValid)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إضافة ذكر واحد على الأقل'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final categoryId = _isEditing ? widget.categoryToEdit!.id : 'custom_${const Uuid().v4()}';

    final dhikrs = _dhikrs.map((dhikrData) {
      return Dhikr(
        id: dhikrData.id ?? 'dhikr_${const Uuid().v4()}',
        title: dhikrData.titleController.text.trim(),
        arabicText: dhikrData.arabicTextController.text.trim(),
        targetCount: int.parse(dhikrData.targetCountController.text.trim()),
        category: categoryId,
        transliteration: dhikrData.transliterationController.text.trim().isNotEmpty
            ? dhikrData.transliterationController.text.trim()
            : null,
        meaning: dhikrData.meaningController.text.trim().isNotEmpty
            ? dhikrData.meaningController.text.trim()
            : null,
      );
    }).toList();

    final category = DhikrCategory(
      id: categoryId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dhikrs: dhikrs,
    );

    try {
      if (_isEditing) {
        await ref.read(customCategoriesProvider.notifier).updateCategory(categoryId, category);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تحديث الفئة بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await ref.read(customCategoriesProvider.notifier).addCategory(category);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إضافة الفئة بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          _isEditing ? 'تعديل الفئة' : 'إضافة فئة جديدة',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withValues(alpha: 0.8),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveCategory,
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
              _buildCategoryInfoSection(),
              const SizedBox(height: 24),
              _buildDhikrsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryInfoSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.category, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'معلومات الفئة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                labelText: 'اسم الفئة',
                hintText: 'مثل: أذكار المساء',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال اسم الفئة';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              textDirection: TextDirection.rtl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'وصف الفئة',
                hintText: 'وصف مختصر عن الفئة وفائدتها',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال وصف الفئة';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDhikrsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.menu_book, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'الأذكار',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _addNewDhikr,
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة ذكر'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_dhikrs.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'لا توجد أذكار بعد\nاضغط "إضافة ذكر" لبدء الإضافة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              ...List.generate(_dhikrs.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildDhikrForm(index),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildDhikrForm(int index) {
    final dhikr = _dhikrs[index];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'الذكر ${index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (_dhikrs.length > 1)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeDhikr(index),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: dhikr.titleController,
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                labelText: 'عنوان الذكر',
                hintText: 'مثل: سبحان الله',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال عنوان الذكر';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: dhikr.arabicTextController,
              textDirection: TextDirection.rtl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'النص العربي',
                hintText: 'سُبْحَانَ اللهِ',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'يرجى إدخال النص العربي';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: dhikr.targetCountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'العدد المستهدف',
                      hintText: '33',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال العدد';
                      }
                      final count = int.tryParse(value.trim());
                      if (count == null || count <= 0) {
                        return 'يرجى إدخال عدد صحيح';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: dhikr.transliterationController,
              decoration: const InputDecoration(
                labelText: 'النطق (اختياري)',
                hintText: 'Subhan Allah',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: dhikr.meaningController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'المعنى (اختياري)',
                hintText: 'سبحان الله أي تنزيه الله عن كل نقص',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DhikrFormData {
  final String? id;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController arabicTextController = TextEditingController();
  final TextEditingController targetCountController = TextEditingController(text: '33');
  final TextEditingController transliterationController = TextEditingController();
  final TextEditingController meaningController = TextEditingController();

  DhikrFormData({this.id});

  DhikrFormData.fromDhikr(Dhikr dhikr) : id = dhikr.id {
    titleController.text = dhikr.title;
    arabicTextController.text = dhikr.arabicText;
    targetCountController.text = dhikr.targetCount.toString();
    transliterationController.text = dhikr.transliteration ?? '';
    meaningController.text = dhikr.meaning ?? '';
  }

  bool get isValid {
    return titleController.text.trim().isNotEmpty &&
           arabicTextController.text.trim().isNotEmpty &&
           int.tryParse(targetCountController.text.trim()) != null;
  }

  void dispose() {
    titleController.dispose();
    arabicTextController.dispose();
    targetCountController.dispose();
    transliterationController.dispose();
    meaningController.dispose();
  }
}