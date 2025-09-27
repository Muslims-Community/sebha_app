import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/providers/goals_provider.dart';
import '../../shared/models/analytics.dart';

class AddGoalScreen extends ConsumerStatefulWidget {
  const AddGoalScreen({super.key});

  @override
  ConsumerState<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends ConsumerState<AddGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetController = TextEditingController();

  GoalType _selectedType = GoalType.weeklyCount;
  Duration? _selectedTimeFrame;
  String? _selectedDhikrId;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة هدف جديد'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildGoalTypeSection(),
            const SizedBox(height: 24),
            _buildGoalDetailsSection(),
            const SizedBox(height: 24),
            _buildTimeFrameSection(),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalTypeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'نوع الهدف',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: GoalType.values.map((type) {
                final isSelected = _selectedType == type;
                return ChoiceChip(
                  label: Text(_getGoalTypeText(type)),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedType = type;
                        _updateDefaultValues();
                      });
                    }
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Text(
              _getGoalTypeDescription(_selectedType),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalDetailsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تفاصيل الهدف',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'عنوان الهدف',
                hintText: 'مثال: إكمال 100 تسبيحة يومياً',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال عنوان الهدف';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'وصف الهدف (اختياري)',
                hintText: 'تفاصيل إضافية عن الهدف',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _targetController,
              decoration: InputDecoration(
                labelText: _getTargetLabel(_selectedType),
                hintText: _getTargetHint(_selectedType),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال الهدف المطلوب';
                }
                final target = int.tryParse(value);
                if (target == null || target <= 0) {
                  return 'يرجى إدخال رقم صحيح أكبر من صفر';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeFrameSection() {
    if (_selectedType == GoalType.consecutiveDays) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'المدة الزمنية',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _getTimeFrameOptions().map((option) {
                final isSelected = _selectedTimeFrame == option['duration'];
                return ChoiceChip(
                  label: Text(option['label'] as String),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedTimeFrame = selected ? option['duration'] as Duration? : null;
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _createGoal,
            child: const Text('إنشاء الهدف'),
          ),
        ),
      ],
    );
  }

  String _getGoalTypeText(GoalType type) {
    switch (type) {
      case GoalType.dailySessions:
        return 'جلسات يومية';
      case GoalType.weeklyCount:
        return 'عدد أسبوعي';
      case GoalType.monthlyTime:
        return 'وقت شهري';
      case GoalType.consecutiveDays:
        return 'أيام متتالية';
      case GoalType.specificDhikr:
        return 'ذكر محدد';
      case GoalType.totalCount:
        return 'العدد الإجمالي';
    }
  }

  String _getGoalTypeDescription(GoalType type) {
    switch (type) {
      case GoalType.dailySessions:
        return 'هدف لإكمال عدد معين من جلسات الذكر يومياً';
      case GoalType.weeklyCount:
        return 'هدف لإكمال عدد معين من التسبيحات أسبوعياً';
      case GoalType.monthlyTime:
        return 'هدف لقضاء وقت معين في الذكر شهرياً';
      case GoalType.consecutiveDays:
        return 'هدف للمحافظة على الذكر لعدد متتالي من الأيام';
      case GoalType.specificDhikr:
        return 'هدف لذكر معين (مثل سبحان الله أو الاستغفار)';
      case GoalType.totalCount:
        return 'هدف لإكمال عدد إجمالي من التسبيحات';
    }
  }

  String _getTargetLabel(GoalType type) {
    switch (type) {
      case GoalType.dailySessions:
        return 'عدد الجلسات المطلوبة يومياً';
      case GoalType.weeklyCount:
        return 'عدد التسبيحات المطلوبة أسبوعياً';
      case GoalType.monthlyTime:
        return 'عدد الدقائق المطلوبة شهرياً';
      case GoalType.consecutiveDays:
        return 'عدد الأيام المتتالية';
      case GoalType.specificDhikr:
        return 'عدد مرات الذكر المطلوبة';
      case GoalType.totalCount:
        return 'العدد الإجمالي المطلوب';
    }
  }

  String _getTargetHint(GoalType type) {
    switch (type) {
      case GoalType.dailySessions:
        return 'مثال: 3';
      case GoalType.weeklyCount:
        return 'مثال: 1000';
      case GoalType.monthlyTime:
        return 'مثال: 300';
      case GoalType.consecutiveDays:
        return 'مثال: 30';
      case GoalType.specificDhikr:
        return 'مثال: 100';
      case GoalType.totalCount:
        return 'مثال: 10000';
    }
  }

  List<Map<String, dynamic>> _getTimeFrameOptions() {
    switch (_selectedType) {
      case GoalType.dailySessions:
        return [
          {'label': 'أسبوع واحد', 'duration': const Duration(days: 7)},
          {'label': 'أسبوعان', 'duration': const Duration(days: 14)},
          {'label': 'شهر واحد', 'duration': const Duration(days: 30)},
          {'label': 'بدون نهاية', 'duration': null},
        ];
      case GoalType.weeklyCount:
      case GoalType.specificDhikr:
        return [
          {'label': 'أسبوع واحد', 'duration': const Duration(days: 7)},
          {'label': 'شهر واحد', 'duration': const Duration(days: 30)},
          {'label': 'ثلاثة أشهر', 'duration': const Duration(days: 90)},
        ];
      case GoalType.monthlyTime:
        return [
          {'label': 'شهر واحد', 'duration': const Duration(days: 30)},
          {'label': 'ثلاثة أشهر', 'duration': const Duration(days: 90)},
          {'label': 'ستة أشهر', 'duration': const Duration(days: 180)},
        ];
      case GoalType.totalCount:
        return [
          {'label': 'شهر واحد', 'duration': const Duration(days: 30)},
          {'label': 'ثلاثة أشهر', 'duration': const Duration(days: 90)},
          {'label': 'سنة واحدة', 'duration': const Duration(days: 365)},
          {'label': 'بدون نهاية', 'duration': null},
        ];
      default:
        return [{'label': 'بدون نهاية', 'duration': null}];
    }
  }

  void _updateDefaultValues() {
    switch (_selectedType) {
      case GoalType.dailySessions:
        _titleController.text = 'جلسات ذكر يومية';
        _targetController.text = '2';
        break;
      case GoalType.weeklyCount:
        _titleController.text = 'تسبيحات أسبوعية';
        _targetController.text = '500';
        break;
      case GoalType.monthlyTime:
        _titleController.text = 'وقت ذكر شهري';
        _targetController.text = '120';
        break;
      case GoalType.consecutiveDays:
        _titleController.text = 'أيام متتالية من الذكر';
        _targetController.text = '30';
        break;
      case GoalType.specificDhikr:
        _titleController.text = 'ذكر محدد';
        _targetController.text = '100';
        break;
      case GoalType.totalCount:
        _titleController.text = 'العدد الإجمالي للتسبيح';
        _targetController.text = '10000';
        break;
    }
  }

  void _createGoal() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final description = _descriptionController.text.isEmpty
          ? _getGoalTypeDescription(_selectedType)
          : _descriptionController.text;
      final target = int.parse(_targetController.text);

      final goal = PersonalGoal(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        type: _selectedType,
        target: target,
        currentProgress: 0,
        startDate: DateTime.now(),
        endDate: _selectedTimeFrame != null
            ? DateTime.now().add(_selectedTimeFrame!)
            : null,
        timeFrame: _selectedTimeFrame,
        isActive: true,
        dhikrId: _selectedDhikrId,
      );

      ref.read(goalsProvider.notifier).addGoal(goal);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إنشاء الهدف بنجاح!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }
}