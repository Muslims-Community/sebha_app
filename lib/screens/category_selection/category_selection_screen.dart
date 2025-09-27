import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../dhikr_counting/dhikr_counting_screen.dart';
import '../../shared/providers/custom_categories_provider.dart';
import '../category_management/category_form_screen.dart';

class CategorySelectionScreen extends ConsumerStatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  ConsumerState<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends ConsumerState<CategorySelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<DhikrCategory> get _filteredCategories {
    final allCategories = ref.read(allCategoriesProvider);
    if (_searchQuery.isEmpty) {
      return allCategories;
    }
    return allCategories.where((category) {
      return category.title.contains(_searchQuery) ||
             category.description.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'اختر فئة الأذكار',
          style: TextStyle(
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
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () => _navigateToAddCategory(),
            tooltip: 'إضافة فئة جديدة',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  hintText: 'ابحث في فئات الأذكار...',
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  prefixIcon: Icon(Icons.search, color: Theme.of(context).hintColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
          ),

          // Categories grid
          Expanded(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return _buildCategoriesGrid();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    final categories = _filteredCategories;

    if (categories.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final animationDelay = index * 0.1;

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final slideAnimation = Tween<Offset>(
              begin: const Offset(0, 0.5),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                animationDelay,
                1.0,
                curve: Curves.easeOutBack,
              ),
            ));

            final fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                animationDelay,
                1.0,
                curve: Curves.easeIn,
              ),
            ));

            return SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: _buildCategoryCard(category, index),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryCard(DhikrCategory category, int index) {
    final cardColor = _getCategoryColor(category.id);
    final totalDhikrs = category.dhikrs.length;

    final isCustomCategory = ref.read(customCategoriesProvider.notifier).isCustomCategory(category.id);

    return GestureDetector(
      onTap: () => _navigateToCategory(category),
      onLongPress: isCustomCategory ? () => _showCategoryOptions(category) : null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: cardColor.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cardColor,
                  cardColor.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          _getCategoryIcon(category.id),
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      if (isCustomCategory) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'مخصص',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: cardColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Title
                  Text(
                    category.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Description
                  Text(
                    category.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(),

                  // Count badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.bookmark,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$totalDhikrs أذكار',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'لا توجد فئات مطابقة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'جرب كلمات بحث أخرى',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).hintColor.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCategory(DhikrCategory category) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => DhikrCountingScreen(
          category: category,
          startingDhikrIndex: 0,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case 'tasbih_classical':
        return Icons.stars;
      case 'morning_adhkar':
        return Icons.wb_sunny;
      case 'evening_adhkar':
        return Icons.nights_stay;
      case 'after_prayer':
        return Icons.mosque;
      case 'general_dhikr':
        return Icons.menu_book;
      case 'sleeping_adhkar':
        return Icons.bedtime;
      case 'istighfar':
        return Icons.healing;
      case 'salawat':
        return Icons.favorite;
      case 'tasbeeh_tahmeed':
        return Icons.brightness_7;
      case 'protection_adhkar':
        return Icons.shield;
      case 'friday_adhkar':
        return Icons.calendar_today;
      case 'travel_adhkar':
        return Icons.flight;
      case 'eating_adhkar':
        return Icons.restaurant;
      case 'weather_adhkar':
        return Icons.cloud;
      default:
        return Icons.menu_book;
    }
  }

  Color _getCategoryColor(String categoryId) {
    switch (categoryId) {
      case 'tasbih_classical':
        return const Color(0xFF2196F3);
      case 'morning_adhkar':
        return const Color(0xFFFF9800);
      case 'evening_adhkar':
        return const Color(0xFF673AB7);
      case 'after_prayer':
        return const Color(0xFF009688);
      case 'general_dhikr':
        return const Color(0xFF607D8B);
      case 'sleeping_adhkar':
        return const Color(0xFF3F51B5);
      case 'istighfar':
        return const Color(0xFF4CAF50);
      case 'salawat':
        return const Color(0xFFE91E63);
      case 'tasbeeh_tahmeed':
        return const Color(0xFFFFC107);
      case 'protection_adhkar':
        return const Color(0xFFf44336);
      case 'friday_adhkar':
        return const Color(0xFF00BCD4);
      case 'travel_adhkar':
        return const Color(0xFF795548);
      case 'eating_adhkar':
        return const Color(0xFF8BC34A);
      case 'weather_adhkar':
        return const Color(0xFF03A9F4);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  void _navigateToAddCategory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CategoryFormScreen(),
      ),
    );
  }

  void _showCategoryOptions(DhikrCategory category) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                category.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('تعديل الفئة'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToEditCategory(category);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('حذف الفئة'),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(category);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToEditCategory(DhikrCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryFormScreen(categoryToEdit: category),
      ),
    );
  }

  void _showDeleteConfirmation(DhikrCategory category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: Text('هل أنت متأكد من حذف فئة "${category.title}"؟\n\nسيتم حذف جميع الأذكار الموجودة في هذه الفئة نهائياً.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCategory(category);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCategory(DhikrCategory category) async {
    try {
      await ref.read(customCategoriesProvider.notifier).deleteCategory(category.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم حذف فئة "${category.title}" بنجاح'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'تراجع',
              onPressed: () {
                // TODO: Implement undo functionality
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء حذف الفئة: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}