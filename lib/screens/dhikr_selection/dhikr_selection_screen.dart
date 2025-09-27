import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../../shared/providers/dhikr_favorites_provider.dart';
import '../dhikr_counting/dhikr_counting_screen.dart';

class DhikrSelectionScreen extends ConsumerStatefulWidget {
  final Dhikr? currentDhikr;
  final Function(Dhikr) onDhikrSelected;

  const DhikrSelectionScreen({
    super.key,
    this.currentDhikr,
    required this.onDhikrSelected,
  });

  @override
  ConsumerState<DhikrSelectionScreen> createState() => _DhikrSelectionScreenState();
}

class _DhikrSelectionScreenState extends ConsumerState<DhikrSelectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Dhikr> get _filteredDhikrs {
    List<Dhikr> allDhikrs = DhikrData.categories
        .expand((category) => category.dhikrs)
        .toList();

    if (_searchQuery.isNotEmpty) {
      allDhikrs = allDhikrs.where((dhikr) {
        return dhikr.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            dhikr.arabicText.contains(_searchQuery) ||
            (dhikr.transliteration ?? '').toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (dhikr.meaning ?? '').toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (_selectedCategory != 'all') {
      allDhikrs = allDhikrs.where((dhikr) => dhikr.category == _selectedCategory).toList();
    }

    return allDhikrs;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'اختيار الذكر',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              _buildSearchBar(),
              _buildCategoryFilter(),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllDhikrsTab(),
                _buildFavoritesTab(),
                _buildRecentTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
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
        decoration: const InputDecoration(
          hintText: 'ابحث في الأذكار...',
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildCategoryChip('all', 'الكل', Icons.apps),
          ...DhikrData.categories.map((category) {
            return _buildCategoryChip(
              category.id,
              category.title,
              _getCategoryIcon(category.id),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String categoryId, String title, IconData icon) {
    final isSelected = _selectedCategory == categoryId;
    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: FilterChip(
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = categoryId;
          });
        },
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Theme.of(context).primaryColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        selectedColor: Theme.of(context).primaryColor,
        side: BorderSide(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
        ),
        elevation: isSelected ? 4 : 2,
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Theme.of(context).primaryColor,
        indicatorWeight: 3,
        tabs: const [
          Tab(
            icon: Icon(Icons.library_books),
            text: 'جميع الأذكار',
          ),
          Tab(
            icon: Icon(Icons.favorite),
            text: 'المفضلة',
          ),
          Tab(
            icon: Icon(Icons.history),
            text: 'المستخدمة مؤخراً',
          ),
        ],
      ),
    );
  }

  Widget _buildAllDhikrsTab() {
    final dhikrs = _filteredDhikrs;

    if (dhikrs.isEmpty) {
      return _buildEmptyState(
        icon: Icons.search_off,
        title: 'لا توجد نتائج',
        subtitle: 'جرب كلمات بحث أخرى',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dhikrs.length,
      itemBuilder: (context, index) {
        final dhikr = dhikrs[index];
        return _buildDhikrCard(dhikr);
      },
    );
  }

  Widget _buildFavoritesTab() {
    final favoriteDhikrs = ref.read(dhikrFavoritesProvider.notifier).getFavoriteDhikrs();

    if (favoriteDhikrs.isEmpty) {
      return _buildEmptyState(
        icon: Icons.favorite_border,
        title: 'لا توجد أذكار مفضلة',
        subtitle: 'اضغط على القلب لإضافة ذكر إلى المفضلة',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favoriteDhikrs.length,
      itemBuilder: (context, index) {
        final dhikr = favoriteDhikrs[index];
        return _buildDhikrCard(dhikr);
      },
    );
  }

  Widget _buildRecentTab() {
    final recentlyUsedDhikrs = ref.read(dhikrRecentlyUsedProvider.notifier).getRecentlyUsedDhikrs();

    if (recentlyUsedDhikrs.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history,
        title: 'لا توجد أذكار مستخدمة مؤخراً',
        subtitle: 'ابدأ بتسبيح ذكر لرؤيته هنا',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recentlyUsedDhikrs.length,
      itemBuilder: (context, index) {
        final dhikr = recentlyUsedDhikrs[index];
        return _buildDhikrCard(dhikr, showRecentBadge: true);
      },
    );
  }

  Widget _buildDhikrCard(Dhikr dhikr, {bool showRecentBadge = false}) {
    final isCurrentDhikr = widget.currentDhikr?.id == dhikr.id;
    final favorites = ref.watch(dhikrFavoritesProvider);
    final isFavorite = favorites.contains(dhikr.id);
    final category = DhikrData.categories.firstWhere(
      (cat) => cat.id == dhikr.category,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: isCurrentDhikr ? 8 : 3,
        shadowColor: isCurrentDhikr
            ? Theme.of(context).primaryColor.withValues(alpha: 0.3)
            : Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isCurrentDhikr
              ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
              : BorderSide.none,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            widget.onDhikrSelected(dhikr);
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(dhikr.category).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getCategoryIcon(dhikr.category),
                            size: 14,
                            color: _getCategoryColor(dhikr.category),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            category.title,
                            style: TextStyle(
                              fontSize: 12,
                              color: _getCategoryColor(dhikr.category),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (showRecentBadge)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'مؤخراً',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    if (isCurrentDhikr)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'الحالي',
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    IconButton(
                      onPressed: () {
                        ref.read(dhikrFavoritesProvider.notifier).toggleFavorite(dhikr.id);
                      },
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  dhikr.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Text(
                    dhikr.arabicText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.8,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                const SizedBox(height: 12),
                if (dhikr.transliteration != null) ...[
                  Text(
                    dhikr.transliteration!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
                if (dhikr.meaning != null) ...[
                  Text(
                    dhikr.meaning!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Row(
                  children: [
                    Icon(
                      Icons.repeat,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'العدد المطلوب: ${dhikr.targetCount}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final category = DhikrData.categories.firstWhere(
                            (cat) => cat.id == dhikr.category,
                          );
                          final dhikrIndex = category.dhikrs.indexWhere(
                            (d) => d.id == dhikr.id,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DhikrCountingScreen(
                                category: category,
                                startingDhikrIndex: dhikrIndex,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.auto_awesome, size: 16),
                        label: const Text(
                          'الفئة كاملة',
                          style: TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          widget.onDhikrSelected(dhikr);
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.play_arrow, size: 16),
                        label: const Text(
                          'ذكر واحد',
                          style: TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
        return Colors.blue;
      case 'morning_adhkar':
        return Colors.orange;
      case 'evening_adhkar':
        return Colors.deepPurple;
      case 'after_prayer':
        return Colors.teal;
      case 'general_dhikr':
        return Colors.grey;
      case 'sleeping_adhkar':
        return Colors.indigo;
      case 'istighfar':
        return Colors.green;
      case 'salawat':
        return Colors.pink;
      case 'tasbeeh_tahmeed':
        return Colors.amber;
      case 'protection_adhkar':
        return Colors.red;
      case 'friday_adhkar':
        return Colors.cyan;
      case 'travel_adhkar':
        return Colors.blueGrey;
      case 'eating_adhkar':
        return Colors.brown;
      case 'weather_adhkar':
        return Colors.lightBlue;
      default:
        return Colors.grey;
    }
  }
}