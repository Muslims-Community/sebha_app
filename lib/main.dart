import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'shared/providers/settings_provider.dart';
import 'shared/providers/theme_provider.dart';
import 'shared/providers/session_provider.dart';
import 'shared/providers/audio_provider.dart';
import 'shared/providers/goals_provider.dart';
import 'shared/providers/notification_provider.dart';
import 'shared/providers/widget_provider.dart';
import 'shared/providers/shortcuts_provider.dart';
import 'shared/providers/notification_settings_provider.dart';
import 'shared/providers/dhikr_favorites_provider.dart';
import 'shared/widgets/quick_settings_panel.dart';
import 'shared/models/app_settings.dart' as app_models;
import 'shared/models/dhikr.dart' as new_models;
import 'shared/models/analytics.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/statistics/statistics_screen.dart';
import 'screens/custom_dhikr/custom_dhikr_screen.dart';
import 'screens/advanced/advanced_features_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/goals/goals_screen.dart' as goals;
import 'screens/dhikr_selection/dhikr_selection_screen.dart';
import 'screens/category_selection/category_selection_screen.dart';
import 'screens/category_management/category_form_screen.dart';
import 'l10n/generated/app_localizations.dart';

class Dhikr {
  final String id;
  final String title;
  final String arabicText;
  final int targetCount;
  final String category;
  final String? transliteration;
  final String? meaning;

  const Dhikr({
    required this.id,
    required this.title,
    required this.arabicText,
    required this.targetCount,
    required this.category,
    this.transliteration,
    this.meaning,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'arabicText': arabicText,
      'targetCount': targetCount,
      'category': category,
      'transliteration': transliteration,
      'meaning': meaning,
    };
  }

  factory Dhikr.fromJson(Map<String, dynamic> json) {
    return Dhikr(
      id: json['id'] as String,
      title: json['title'] as String,
      arabicText: json['arabicText'] as String,
      targetCount: json['targetCount'] as int,
      category: json['category'] as String,
      transliteration: json['transliteration'] as String?,
      meaning: json['meaning'] as String?,
    );
  }
}

class DhikrCategory {
  final String id;
  final String title;
  final String description;
  final List<Dhikr> dhikrs;

  const DhikrCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.dhikrs,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dhikrs': dhikrs.map((dhikr) => dhikr.toJson()).toList(),
    };
  }

  factory DhikrCategory.fromJson(Map<String, dynamic> json) {
    return DhikrCategory(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dhikrs: (json['dhikrs'] as List<dynamic>)
          .map((dhikrJson) => Dhikr.fromJson(dhikrJson as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DhikrData {
  static const List<DhikrCategory> categories = [
    DhikrCategory(
      id: 'tasbih_classical',
      title: 'التسبيح الكلاسيكي',
      description: 'التسبيحات التقليدية بعد الصلاة',
      dhikrs: [
        Dhikr(
          id: 'subhan_allah',
          title: 'سبحان الله',
          arabicText: 'سُبْحَانَ اللَّهِ',
          targetCount: 33,
          category: 'tasbih_classical',
          transliteration: 'Subhan Allah',
          meaning: 'Glory be to Allah',
        ),
        Dhikr(
          id: 'alhamdulillah',
          title: 'الحمد لله',
          arabicText: 'الْحَمْدُ لِلَّهِ',
          targetCount: 33,
          category: 'tasbih_classical',
          transliteration: 'Alhamdulillah',
          meaning: 'All praise is due to Allah',
        ),
        Dhikr(
          id: 'allahu_akbar',
          title: 'الله أكبر',
          arabicText: 'اللَّهُ أَكْبَرُ',
          targetCount: 34,
          category: 'tasbih_classical',
          transliteration: 'Allahu Akbar',
          meaning: 'Allah is the Greatest',
        ),
      ],
    ),
    DhikrCategory(
      id: 'morning_adhkar',
      title: 'أذكار الصباح',
      description: 'الأذكار المستحبة في الصباح من بعد الفجر إلى طلوع الشمس',
      dhikrs: [
        Dhikr(
          id: 'ayat_kursi_morning',
          title: 'آية الكرسي',
          arabicText: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ',
          targetCount: 1,
          category: 'morning_adhkar',
          transliteration: 'Allahu la ilaha illa huwa al-hayyu al-qayyumu...',
          meaning: 'Allah - there is no deity except Him, the Ever-Living, the Self-Sustaining...',
        ),
        Dhikr(
          id: 'qul_huwa_allah_morning',
          title: 'سورة الإخلاص',
          arabicText: 'قُلْ هُوَ اللَّهُ أَحَدٌ ۝ اللَّهُ الصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ',
          targetCount: 3,
          category: 'morning_adhkar',
          transliteration: 'Qul huwa Allahu ahad, Allahu samad...',
          meaning: 'Say: He is Allah, the One! Allah, the Eternal, Absolute...',
        ),
        Dhikr(
          id: 'qul_aoodhu_falaq_morning',
          title: 'سورة الفلق',
          arabicText: 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۝ مِنْ شَرِّ مَا خَلَقَ ۝ وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ ۝ وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ۝ وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ',
          targetCount: 3,
          category: 'morning_adhkar',
          transliteration: 'Qul aoodhu bi rabbi al-falaq...',
          meaning: 'Say: I seek refuge with the Lord of the daybreak...',
        ),
        Dhikr(
          id: 'qul_aoodhu_naas_morning',
          title: 'سورة الناس',
          arabicText: 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ ۝ مَلِكِ النَّاسِ ۝ إِلَٰهِ النَّاسِ ۝ مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ۝ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ۝ مِنَ الْجِنَّةِ وَالنَّاسِ',
          targetCount: 3,
          category: 'morning_adhkar',
          transliteration: 'Qul aoodhu bi rabbi an-naas...',
          meaning: 'Say: I seek refuge with the Lord of mankind...',
        ),
        Dhikr(
          id: 'subhan_allah_morning',
          title: 'سبحان الله وبحمده',
          arabicText: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
          targetCount: 100,
          category: 'morning_adhkar',
          transliteration: 'Subhan Allah wa bihamdihi',
          meaning: 'Glory be to Allah and praise be to Him',
        ),
        Dhikr(
          id: 'la_hawla_morning',
          title: 'لا حول ولا قوة إلا بالله',
          arabicText: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
          targetCount: 100,
          category: 'morning_adhkar',
          transliteration: 'La hawla wa la quwwata illa billah',
          meaning: 'There is no power except with Allah',
        ),
        Dhikr(
          id: 'istighfar_morning',
          title: 'الاستغفار',
          arabicText: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ',
          targetCount: 100,
          category: 'morning_adhkar',
          transliteration: 'Astaghfiru Allah al-azeem alladhi la ilaha illa huwa al-hayyu al-qayyumu wa atoobu ilayh',
          meaning: 'I seek forgiveness from Allah the Magnificent, there is no god but Him, the Ever-Living, the Self-Sustaining, and I repent to Him',
        ),
        Dhikr(
          id: 'radheetu_billah_morning',
          title: 'رضيت بالله رباً',
          arabicText: 'رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ رَسُولًا',
          targetCount: 3,
          category: 'morning_adhkar',
          transliteration: 'Radheetu billahi rabban, wa bil-islami deenan, wa bi Muhammadin rasoolan',
          meaning: 'I am pleased with Allah as my Lord, Islam as my religion, and Muhammad as my messenger',
        ),
        Dhikr(
          id: 'hasbi_allah_morning',
          title: 'حسبي الله لا إله إلا هو',
          arabicText: 'حَسْبِيَ اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
          targetCount: 7,
          category: 'morning_adhkar',
          transliteration: 'Hasbi Allah la ilaha illa huwa alayhi tawakkaltu wa huwa rabbu al-arshi al-azeem',
          meaning: 'Allah is sufficient for me; there is no god but He. In Him I trust, and He is the Lord of the Great Throne',
        ),
        Dhikr(
          id: 'morning_protection',
          title: 'دعاء الحفظ الصباحي',
          arabicText: 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَٰهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَىٰ عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي، فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
          targetCount: 1,
          category: 'morning_adhkar',
          transliteration: 'Allahumma anta rabbi la ilaha illa anta, khalaqtani wa ana abduka...',
          meaning: 'O Allah, You are my Lord, there is no god but You. You created me and I am Your servant...',
        ),
      ],
    ),
    DhikrCategory(
      id: 'evening_adhkar',
      title: 'أذكار المساء',
      description: 'الأذكار المستحبة في المساء من بعد العصر إلى المغرب',
      dhikrs: [
        Dhikr(
          id: 'ayat_kursi_evening',
          title: 'آية الكرسي',
          arabicText: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ',
          targetCount: 1,
          category: 'evening_adhkar',
          transliteration: 'Allahu la ilaha illa huwa al-hayyu al-qayyumu...',
          meaning: 'Allah - there is no deity except Him, the Ever-Living, the Self-Sustaining...',
        ),
        Dhikr(
          id: 'qul_huwa_allah_evening',
          title: 'سورة الإخلاص',
          arabicText: 'قُلْ هُوَ اللَّهُ أَحَدٌ ۝ اللَّهُ الصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ',
          targetCount: 3,
          category: 'evening_adhkar',
          transliteration: 'Qul huwa Allahu ahad, Allahu samad...',
          meaning: 'Say: He is Allah, the One! Allah, the Eternal, Absolute...',
        ),
        Dhikr(
          id: 'qul_aoodhu_falaq_evening',
          title: 'سورة الفلق',
          arabicText: 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۝ مِنْ شَرِّ مَا خَلَقَ ۝ وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ ۝ وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ۝ وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ',
          targetCount: 3,
          category: 'evening_adhkar',
          transliteration: 'Qul aoodhu bi rabbi al-falaq...',
          meaning: 'Say: I seek refuge with the Lord of the daybreak...',
        ),
        Dhikr(
          id: 'qul_aoodhu_naas_evening',
          title: 'سورة الناس',
          arabicText: 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ ۝ مَلِكِ النَّاسِ ۝ إِلَٰهِ النَّاسِ ۝ مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ۝ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ۝ مِنَ الْجِنَّةِ وَالنَّاسِ',
          targetCount: 3,
          category: 'evening_adhkar',
          transliteration: 'Qul aoodhu bi rabbi an-naas...',
          meaning: 'Say: I seek refuge with the Lord of mankind...',
        ),
        Dhikr(
          id: 'subhan_allah_evening',
          title: 'سبحان الله وبحمده',
          arabicText: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
          targetCount: 100,
          category: 'evening_adhkar',
          transliteration: 'Subhan Allah wa bihamdihi',
          meaning: 'Glory be to Allah and praise be to Him',
        ),
        Dhikr(
          id: 'la_ilaha_illa_allah_evening',
          title: 'لا إله إلا الله وحده',
          arabicText: 'لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ',
          targetCount: 10,
          category: 'evening_adhkar',
          transliteration: 'La ilaha illa Allah wahdahu la sharika lah, lahu al-mulku wa lahu al-hamdu wa huwa ala kulli shayin qadeer',
          meaning: 'There is no god but Allah alone, with no partner. His is the dominion and His is the praise, and He is able to do all things',
        ),
        Dhikr(
          id: 'istighfar_evening',
          title: 'الاستغفار المسائي',
          arabicText: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ',
          targetCount: 100,
          category: 'evening_adhkar',
          transliteration: 'Astaghfiru Allah al-azeem alladhi la ilaha illa huwa al-hayyu al-qayyumu wa atoobu ilayh',
          meaning: 'I seek forgiveness from Allah the Magnificent, there is no god but Him, the Ever-Living, the Self-Sustaining, and I repent to Him',
        ),
        Dhikr(
          id: 'evening_protection',
          title: 'دعاء الحفظ المسائي',
          arabicText: 'اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ',
          targetCount: 1,
          category: 'evening_adhkar',
          transliteration: 'Allahumma bika amsayna wa bika asbahna wa bika nahya wa bika namootu wa ilayka an-nushoor',
          meaning: 'O Allah, by You we have reached the evening, by You we have reached the morning, by You we live, by You we die, and to You is the resurrection',
        ),
        Dhikr(
          id: 'aoodhu_kalimat_evening',
          title: 'أعوذ بكلمات الله التامات',
          arabicText: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
          targetCount: 3,
          category: 'evening_adhkar',
          transliteration: 'Aoodhu bi kalimat Allah at-tammati min sharri ma khalaq',
          meaning: 'I seek refuge in the perfect words of Allah from the evil of what He has created',
        ),
        Dhikr(
          id: 'hasbi_allah_evening',
          title: 'حسبي الله لا إله إلا هو',
          arabicText: 'حَسْبِيَ اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
          targetCount: 7,
          category: 'evening_adhkar',
          transliteration: 'Hasbi Allah la ilaha illa huwa alayhi tawakkaltu wa huwa rabbu al-arshi al-azeem',
          meaning: 'Allah is sufficient for me; there is no god but He. In Him I trust, and He is the Lord of the Great Throne',
        ),
      ],
    ),
    DhikrCategory(
      id: 'after_prayer_adhkar',
      title: 'أذكار ما بعد الصلاة',
      description: 'الأذكار المستحبة بعد الانتهاء من الصلاة',
      dhikrs: [
        Dhikr(
          id: 'istighfar_after_prayer',
          title: 'الاستغفار بعد الصلاة',
          arabicText: 'أَسْتَغْفِرُ اللَّهَ',
          targetCount: 3,
          category: 'after_prayer_adhkar',
          transliteration: 'Astaghfiru Allah',
          meaning: 'I seek forgiveness from Allah',
        ),
        Dhikr(
          id: 'subhan_allah_after_prayer',
          title: 'سبحان الله',
          arabicText: 'سُبْحَانَ اللَّهِ',
          targetCount: 33,
          category: 'after_prayer_adhkar',
          transliteration: 'Subhan Allah',
          meaning: 'Glory be to Allah',
        ),
        Dhikr(
          id: 'alhamdulillah_after_prayer',
          title: 'الحمد لله',
          arabicText: 'الْحَمْدُ لِلَّهِ',
          targetCount: 33,
          category: 'after_prayer_adhkar',
          transliteration: 'Alhamdulillah',
          meaning: 'All praise is due to Allah',
        ),
        Dhikr(
          id: 'allahu_akbar_after_prayer',
          title: 'الله أكبر',
          arabicText: 'اللَّهُ أَكْبَرُ',
          targetCount: 34,
          category: 'after_prayer_adhkar',
          transliteration: 'Allahu Akbar',
          meaning: 'Allah is the Greatest',
        ),
        Dhikr(
          id: 'la_ilaha_illa_allah_after_prayer',
          title: 'لا إله إلا الله وحده',
          arabicText: 'لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ',
          targetCount: 1,
          category: 'after_prayer_adhkar',
          transliteration: 'La ilaha illa Allah wahdahu la sharika lah, lahu al-mulku wa lahu al-hamdu wa huwa ala kulli shayin qadeer',
          meaning: 'There is no god but Allah alone, with no partner. His is the dominion and His is the praise, and He is able to do all things',
        ),
        Dhikr(
          id: 'ayat_kursi_after_prayer',
          title: 'آية الكرسي',
          arabicText: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ',
          targetCount: 1,
          category: 'after_prayer_adhkar',
          transliteration: 'Allahu la ilaha illa huwa al-hayyu al-qayyumu...',
          meaning: 'Allah - there is no deity except Him, the Ever-Living, the Self-Sustaining...',
        ),
        Dhikr(
          id: 'qul_huwa_allah_after_prayer',
          title: 'سورة الإخلاص',
          arabicText: 'قُلْ هُوَ اللَّهُ أَحَدٌ ۝ اللَّهُ الصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ',
          targetCount: 1,
          category: 'after_prayer_adhkar',
          transliteration: 'Qul huwa Allahu ahad, Allahu samad...',
          meaning: 'Say: He is Allah, the One! Allah, the Eternal, Absolute...',
        ),
        Dhikr(
          id: 'qul_aoodhu_falaq_after_prayer',
          title: 'سورة الفلق',
          arabicText: 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۝ مِنْ شَرِّ مَا خَلَقَ ۝ وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ ۝ وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ۝ وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ',
          targetCount: 1,
          category: 'after_prayer_adhkar',
          transliteration: 'Qul aoodhu bi rabbi al-falaq...',
          meaning: 'Say: I seek refuge with the Lord of the daybreak...',
        ),
        Dhikr(
          id: 'qul_aoodhu_naas_after_prayer',
          title: 'سورة الناس',
          arabicText: 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ ۝ مَلِكِ النَّاسِ ۝ إِلَٰهِ النَّاسِ ۝ مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ۝ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ۝ مِنَ الْجِنَّةِ وَالنَّاسِ',
          targetCount: 1,
          category: 'after_prayer_adhkar',
          transliteration: 'Qul aoodhu bi rabbi an-naas...',
          meaning: 'Say: I seek refuge with the Lord of mankind...',
        ),
      ],
    ),
    DhikrCategory(
      id: 'general_dhikr',
      title: 'أذكار عامة',
      description: 'أذكار يمكن قولها في أي وقت',
      dhikrs: [
        Dhikr(
          id: 'salawat',
          title: 'الصلاة على النبي',
          arabicText: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ',
          targetCount: 100,
          category: 'general_dhikr',
          transliteration: 'Allahumma salli ala Muhammad wa ala ali Muhammad',
          meaning: 'O Allah, send prayers upon Muhammad and the family of Muhammad',
        ),
        Dhikr(
          id: 'la_hawla_general',
          title: 'لا حول ولا قوة إلا بالله',
          arabicText: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
          targetCount: 100,
          category: 'general_dhikr',
          transliteration: 'La hawla wa la quwwata illa billah',
          meaning: 'There is no power except with Allah',
        ),
        Dhikr(
          id: 'istighfar_general',
          title: 'الاستغفار العام',
          arabicText: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ',
          targetCount: 100,
          category: 'general_dhikr',
          transliteration: 'Astaghfiru Allah al-azeem',
          meaning: 'I seek forgiveness from Allah the Magnificent',
        ),
        Dhikr(
          id: 'subhan_allah_general',
          title: 'سبحان الله وبحمده',
          arabicText: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
          targetCount: 100,
          category: 'general_dhikr',
          transliteration: 'Subhan Allah wa bihamdihi',
          meaning: 'Glory be to Allah and praise be to Him',
        ),
      ],
    ),
    DhikrCategory(
      id: 'sleeping_adhkar',
      title: 'أذكار النوم',
      description: 'الأذكار المستحبة قبل النوم للحفظ والطمأنينة',
      dhikrs: [
        Dhikr(
          id: 'ayat_kursi_sleep',
          title: 'آية الكرسي',
          arabicText: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ',
          targetCount: 1,
          category: 'sleeping_adhkar',
          transliteration: 'Allahu la ilaha illa huwa al-hayyu al-qayyumu...',
          meaning: 'Allah - there is no deity except Him, the Ever-Living, the Self-Sustaining...',
        ),
        Dhikr(
          id: 'last_ayat_baqara',
          title: 'آخر آيتين من سورة البقرة',
          arabicText: 'آمَنَ الرَّسُولُ بِمَا أُنزِلَ إِلَيْهِ مِن رَّبِّهِ وَالْمُؤْمِنُونَ ۚ كُلٌّ آمَنَ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ لَا نُفَرِّقُ بَيْنَ أَحَدٍ مِّن رُّسُلِهِ ۚ وَقَالُوا سَمِعْنَا وَأَطَعْنَا ۖ غُفْرَانَكَ رَبَّنَا وَإِلَيْكَ الْمَصِيرُ ۝ لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا ۚ لَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ ۗ رَبَّنَا لَا تُؤَاخِذْنَا إِن نَّسِينَا أَوْ أَخْطَأْنَا ۚ رَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِن قَبْلِنَا ۚ رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ ۖ وَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا ۚ أَنتَ مَوْلَانَا فَانصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ',
          targetCount: 1,
          category: 'sleeping_adhkar',
          transliteration: 'Amana ar-rasoolu bima unzila ilayhi min rabbihi wal-muminoon...',
          meaning: 'The Messenger has believed in what was revealed to him from his Lord, and [so have] the believers...',
        ),
        Dhikr(
          id: 'bismika_allahumma',
          title: 'باسمك اللهم أموت وأحيا',
          arabicText: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
          targetCount: 1,
          category: 'sleeping_adhkar',
          transliteration: 'Bismika Allahumma amootu wa ahya',
          meaning: 'In Your name, O Allah, I live and die',
        ),
        Dhikr(
          id: 'subhan_allah_sleep',
          title: 'سبحان الله قبل النوم',
          arabicText: 'سُبْحَانَ اللَّهِ',
          targetCount: 33,
          category: 'sleeping_adhkar',
          transliteration: 'Subhan Allah',
          meaning: 'Glory be to Allah',
        ),
        Dhikr(
          id: 'alhamdulillah_sleep',
          title: 'الحمد لله قبل النوم',
          arabicText: 'الْحَمْدُ لِلَّهِ',
          targetCount: 33,
          category: 'sleeping_adhkar',
          transliteration: 'Alhamdulillah',
          meaning: 'All praise is due to Allah',
        ),
        Dhikr(
          id: 'allahu_akbar_sleep',
          title: 'الله أكبر قبل النوم',
          arabicText: 'اللَّهُ أَكْبَرُ',
          targetCount: 34,
          category: 'sleeping_adhkar',
          transliteration: 'Allahu Akbar',
          meaning: 'Allah is the Greatest',
        ),
      ],
    ),
    DhikrCategory(
      id: 'istighfar',
      title: 'الاستغفار والتوبة',
      description: 'أذكار الاستغفار والتوبة لتطهير القلب والنفس',
      dhikrs: [
        Dhikr(
          id: 'istighfar_simple',
          title: 'الاستغفار البسيط',
          arabicText: 'أَسْتَغْفِرُ اللَّهَ',
          targetCount: 100,
          category: 'istighfar',
          transliteration: 'Astaghfiru Allah',
          meaning: 'I seek forgiveness from Allah',
        ),
        Dhikr(
          id: 'istighfar_complete',
          title: 'الاستغفار الكامل',
          arabicText: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ',
          targetCount: 100,
          category: 'istighfar',
          transliteration: 'Astaghfiru Allah al-azeem alladhi la ilaha illa huwa al-hayyu al-qayyumu wa atoobu ilayh',
          meaning: 'I seek forgiveness from Allah the Magnificent, there is no god but Him, the Ever-Living, the Self-Sustaining, and I repent to Him',
        ),
        Dhikr(
          id: 'sayyid_istighfar',
          title: 'سيد الاستغفار',
          arabicText: 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَٰهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَىٰ عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي، فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
          targetCount: 1,
          category: 'istighfar',
          transliteration: 'Allahumma anta rabbi la ilaha illa anta, khalaqtani wa ana abduka...',
          meaning: 'O Allah, You are my Lord, there is no god but You. You created me and I am Your servant...',
        ),
        Dhikr(
          id: 'rabbigh_firli',
          title: 'رب اغفر لي',
          arabicText: 'رَبِّ اغْفِرْ لِي',
          targetCount: 100,
          category: 'istighfar',
          transliteration: 'Rabbi ghfir li',
          meaning: 'My Lord, forgive me',
        ),
      ],
    ),
    DhikrCategory(
      id: 'salawat_nabi',
      title: 'الصلاة على النبي',
      description: 'صيغ مختلفة للصلاة والسلام على سيدنا محمد ﷺ',
      dhikrs: [
        Dhikr(
          id: 'salawat_simple',
          title: 'الصلاة على النبي البسيطة',
          arabicText: 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ',
          targetCount: 100,
          category: 'salawat_nabi',
          transliteration: 'Allahumma salli wa sallim ala nabiyyina Muhammad',
          meaning: 'O Allah, send prayers and peace upon our Prophet Muhammad',
        ),
        Dhikr(
          id: 'salawat_ibrahimiyya',
          title: 'الصلاة الإبراهيمية',
          arabicText: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ، كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ، إِنَّكَ حَمِيدٌ مَجِيدٌ. اللَّهُمَّ بَارِكْ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ، كَمَا بَارَكْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ، إِنَّكَ حَمِيدٌ مَجِيدٌ',
          targetCount: 10,
          category: 'salawat_nabi',
          transliteration: 'Allahumma salli ala Muhammad wa ala ali Muhammad, kama sallayta ala Ibrahim...',
          meaning: 'O Allah, send prayers upon Muhammad and the family of Muhammad, as You sent prayers upon Ibrahim...',
        ),
        Dhikr(
          id: 'salawat_friday',
          title: 'الصلاة على النبي يوم الجمعة',
          arabicText: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ عَبْدِكَ وَرَسُولِكَ النَّبِيِّ الْأُمِّيِّ',
          targetCount: 80,
          category: 'salawat_nabi',
          transliteration: 'Allahumma salli ala Muhammad abdika wa rasoolika an-nabiyyi al-ummiyy',
          meaning: 'O Allah, send prayers upon Muhammad, Your servant and messenger, the unlettered Prophet',
        ),
      ],
    ),
    DhikrCategory(
      id: 'tasbeeh_tahmeed',
      title: 'التسبيح والتحميد',
      description: 'أذكار التسبيح والتحميد والتكبير والتهليل',
      dhikrs: [
        Dhikr(
          id: 'subhan_allah_azeem',
          title: 'سبحان الله العظيم',
          arabicText: 'سُبْحَانَ اللَّهِ الْعَظِيمِ',
          targetCount: 100,
          category: 'tasbeeh_tahmeed',
          transliteration: 'Subhan Allah al-azeem',
          meaning: 'Glory be to Allah the Magnificent',
        ),
        Dhikr(
          id: 'subhan_allah_bihamdihi',
          title: 'سبحان الله وبحمده',
          arabicText: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
          targetCount: 100,
          category: 'tasbeeh_tahmeed',
          transliteration: 'Subhan Allah wa bihamdihi',
          meaning: 'Glory be to Allah and praise be to Him',
        ),
        Dhikr(
          id: 'subhan_allah_azeem_bihamdihi',
          title: 'سبحان الله العظيم وبحمده',
          arabicText: 'سُبْحَانَ اللَّهِ الْعَظِيمِ وَبِحَمْدِهِ',
          targetCount: 100,
          category: 'tasbeeh_tahmeed',
          transliteration: 'Subhan Allah al-azeem wa bihamdihi',
          meaning: 'Glory be to Allah the Magnificent and praise be to Him',
        ),
        Dhikr(
          id: 'la_ilaha_illa_allah_wahdahu',
          title: 'لا إله إلا الله وحده',
          arabicText: 'لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ',
          targetCount: 100,
          category: 'tasbeeh_tahmeed',
          transliteration: 'La ilaha illa Allah wahdahu la sharika lah, lahu al-mulku wa lahu al-hamdu wa huwa ala kulli shayin qadeer',
          meaning: 'There is no god but Allah alone, with no partner. His is the dominion and His is the praise, and He is able to do all things',
        ),
        Dhikr(
          id: 'la_hawla_wa_la_quwwata',
          title: 'لا حول ولا قوة إلا بالله',
          arabicText: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ الْعَلِيِّ الْعَظِيمِ',
          targetCount: 100,
          category: 'tasbeeh_tahmeed',
          transliteration: 'La hawla wa la quwwata illa billah al-aliyy al-azeem',
          meaning: 'There is no power except with Allah, the Most High, the Magnificent',
        ),
      ],
    ),
    DhikrCategory(
      id: 'protection_adhkar',
      title: 'أذكار الحفظ والحماية',
      description: 'أذكار للحماية من الشر والأذى والوقاية من كل سوء',
      dhikrs: [
        Dhikr(
          id: 'aoodhu_kalimat_allah',
          title: 'أعوذ بكلمات الله التامات',
          arabicText: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
          targetCount: 3,
          category: 'protection_adhkar',
          transliteration: 'Aoodhu bi kalimat Allah at-tammati min sharri ma khalaq',
          meaning: 'I seek refuge in the perfect words of Allah from the evil of what He has created',
        ),
        Dhikr(
          id: 'aoodhu_billah_shaytan',
          title: 'أعوذ بالله من الشيطان الرجيم',
          arabicText: 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ',
          targetCount: 3,
          category: 'protection_adhkar',
          transliteration: 'Aoodhu billahi min ash-shaytani ar-rajeem',
          meaning: 'I seek refuge with Allah from Satan the accursed',
        ),
        Dhikr(
          id: 'hasbi_allah_protection',
          title: 'حسبي الله لا إله إلا هو',
          arabicText: 'حَسْبِيَ اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
          targetCount: 7,
          category: 'protection_adhkar',
          transliteration: 'Hasbi Allah la ilaha illa huwa alayhi tawakkaltu wa huwa rabbu al-arshi al-azeem',
          meaning: 'Allah is sufficient for me; there is no god but He. In Him I trust, and He is the Lord of the Great Throne',
        ),
        Dhikr(
          id: 'bismillah_protection',
          title: 'بسم الله الذي لا يضر',
          arabicText: 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
          targetCount: 3,
          category: 'protection_adhkar',
          transliteration: 'Bismillah alladhi la yadurru ma asmih shayun fil-ardi wa la fis-samai wa huwa as-samee al-aleem',
          meaning: 'In the name of Allah with whose name nothing on earth or in heaven can cause harm, and He is the All-Hearing, All-Knowing',
        ),
      ],
    ),
    DhikrCategory(
      id: 'friday_adhkar',
      title: 'أذكار يوم الجمعة',
      description: 'الأذكار المستحبة في يوم الجمعة المبارك',
      dhikrs: [
        Dhikr(
          id: 'salawat_friday_special',
          title: 'الصلاة على النبي يوم الجمعة',
          arabicText: 'اللَّهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلَى نَبِيِّنَا مُحَمَّدٍ',
          targetCount: 80,
          category: 'friday_adhkar',
          transliteration: 'Allahumma salli wa sallim wa barik ala nabiyyina Muhammad',
          meaning: 'O Allah, send prayers, peace, and blessings upon our Prophet Muhammad',
        ),
        Dhikr(
          id: 'surah_kahf_reading',
          title: 'قراءة سورة الكهف',
          arabicText: 'الْحَمْدُ لِلَّهِ الَّذِي أَنزَلَ عَلَىٰ عَبْدِهِ الْكِتَابَ وَلَمْ يَجْعَل لَّهُ عِوَجًا',
          targetCount: 1,
          category: 'friday_adhkar',
          transliteration: 'Al-hamdu lillahi alladhi anzala ala abdihi al-kitab wa lam yajal lahu iwajan',
          meaning: 'Praise be to Allah who revealed the Book to His servant and made no crookedness therein',
        ),
        Dhikr(
          id: 'dua_friday',
          title: 'دعاء يوم الجمعة',
          arabicText: 'اللَّهُمَّ بَارِكْ لَنَا فِيمَا رَزَقْتَنَا، وَقِنَا عَذَابَ النَّارِ',
          targetCount: 3,
          category: 'friday_adhkar',
          transliteration: 'Allahumma barik lana feema razaqtana, wa qina adhab an-nar',
          meaning: 'O Allah, bless us in what You have provided us, and protect us from the punishment of the Fire',
        ),
      ],
    ),
    DhikrCategory(
      id: 'travel_adhkar',
      title: 'أذكار السفر',
      description: 'الأذكار والأدعية المستحبة عند السفر والانتقال',
      dhikrs: [
        Dhikr(
          id: 'travel_dua',
          title: 'دعاء السفر',
          arabicText: 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَٰذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ، وَإِنَّا إِلَىٰ رَبِّنَا لَمُنقَلِبُونَ',
          targetCount: 3,
          category: 'travel_adhkar',
          transliteration: 'Subhan alladhi sakhkhara lana hadha wa ma kunna lahu muqrineen, wa inna ila rabbina lamunqaliboon',
          meaning: 'Glory be to Him who has subjected this to us, and we could never have it [by our efforts], and indeed we, to our Lord, will [surely] return',
        ),
        Dhikr(
          id: 'travel_protection',
          title: 'الحماية في السفر',
          arabicText: 'اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَٰذَا الْبِرَّ وَالتَّقْوَىٰ، وَمِنَ الْعَمَلِ مَا تَرْضَىٰ',
          targetCount: 1,
          category: 'travel_adhkar',
          transliteration: 'Allahumma inna nasaluka fi safarina hadha al-birra wat-taqwa, wa min al-amali ma tarda',
          meaning: 'O Allah, we ask You for righteousness and piety in this journey of ours, and deeds that are pleasing to You',
        ),
        Dhikr(
          id: 'returning_home',
          title: 'دعاء العودة من السفر',
          arabicText: 'آيِبُونَ تَائِبُونَ عَابِدُونَ سَاجِدُونَ لِرَبِّنَا حَامِدُونَ',
          targetCount: 3,
          category: 'travel_adhkar',
          transliteration: 'Ayiboon taiboon abidoon sajidoon li rabbina hamidoon',
          meaning: 'We return, repent, worship, prostrate, and praise our Lord',
        ),
      ],
    ),
    DhikrCategory(
      id: 'eating_adhkar',
      title: 'أذكار الطعام والشراب',
      description: 'الأذكار والأدعية قبل وبعد تناول الطعام والشراب',
      dhikrs: [
        Dhikr(
          id: 'bismillah_eating',
          title: 'بسم الله قبل الطعام',
          arabicText: 'بِسْمِ اللَّهِ',
          targetCount: 1,
          category: 'eating_adhkar',
          transliteration: 'Bismillah',
          meaning: 'In the name of Allah',
        ),
        Dhikr(
          id: 'alhamdulillah_after_eating',
          title: 'الحمد لله بعد الطعام',
          arabicText: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَٰذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ',
          targetCount: 1,
          category: 'eating_adhkar',
          transliteration: 'Alhamdulillah alladhi atamani hadha wa razaqaneehi min ghayri hawlin minnee wa la quwwah',
          meaning: 'Praise be to Allah who fed me this and provided it for me without any effort or power from me',
        ),
        Dhikr(
          id: 'dua_for_host',
          title: 'دعاء لأهل البيت',
          arabicText: 'اللَّهُمَّ بَارِكْ لَهُمْ فِيمَا رَزَقْتَهُمْ وَاغْفِرْ لَهُمْ وَارْحَمْهُمْ',
          targetCount: 1,
          category: 'eating_adhkar',
          transliteration: 'Allahumma barik lahum feema razaqtahum waghfir lahum warhum',
          meaning: 'O Allah, bless them in what You have provided them, forgive them, and have mercy on them',
        ),
      ],
    ),
    DhikrCategory(
      id: 'weather_adhkar',
      title: 'أذكار الطقس والطبيعة',
      description: 'الأذكار عند رؤية المطر والرعد والرياح وظواهر الطبيعة',
      dhikrs: [
        Dhikr(
          id: 'rain_dua',
          title: 'دعاء عند المطر',
          arabicText: 'اللَّهُمَّ صَيِّبًا نَافِعًا',
          targetCount: 3,
          category: 'weather_adhkar',
          transliteration: 'Allahumma sayyiban nafian',
          meaning: 'O Allah, make it beneficial rain',
        ),
        Dhikr(
          id: 'thunder_dua',
          title: 'دعاء عند سماع الرعد',
          arabicText: 'سُبْحَانَ الَّذِي يُسَبِّحُ الرَّعْدُ بِحَمْدِهِ وَالْمَلَائِكَةُ مِنْ خِيفَتِهِ',
          targetCount: 1,
          category: 'weather_adhkar',
          transliteration: 'Subhan alladhi yusabbihu ar-radu bihamdihi wal-malaikatu min kheefatih',
          meaning: 'Glory be to Him whom thunder praises with His praise and the angels from fear of Him',
        ),
        Dhikr(
          id: 'wind_dua',
          title: 'دعاء عند هبوب الريح',
          arabicText: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَهَا وَخَيْرَ مَا فِيهَا وَخَيْرَ مَا أُرْسِلَتْ بِهِ، وَأَعُوذُ بِكَ مِنْ شَرِّهَا وَشَرِّ مَا فِيهَا وَشَرِّ مَا أُرْسِلَتْ بِهِ',
          targetCount: 1,
          category: 'weather_adhkar',
          transliteration: 'Allahumma inni asaluka khayraha wa khayra ma feeha wa khayra ma ursilat bih...',
          meaning: 'O Allah, I ask You for its good and the good of what is in it and the good of what it was sent with...',
        ),
      ],
    ),
  ];

  static Dhikr? getDhikrById(String id) {
    for (final category in categories) {
      try {
        return category.dhikrs.firstWhere((dhikr) => dhikr.id == id);
      } catch (e) {
        continue;
      }
    }
    return null;
  }
}

void main() {
  runApp(const ProviderScope(child: SebhaApp()));
}

class SebhaApp extends ConsumerWidget {
  const SebhaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final lightTheme = ref.watch(themeProvider);
    final darkTheme = ref.watch(darkThemeProvider);

    return MaterialApp(
      title: 'السبحة الرقمية',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _getThemeMode(settings.themeMode),
      locale: Locale(settings.languageCode),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
        Locale('ur'),
      ],
      routes: {
        '/': (context) => const CategorySelectionScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/statistics': (context) => const StatisticsScreen(),
        '/goals': (context) => const goals.GoalsScreen(),
        '/custom-dhikr': (context) => const CustomDhikrScreen(),
        '/advanced': (context) => const AdvancedFeaturesScreen(),
      },
      initialRoute: settings.onboardingCompleted ? '/' : '/onboarding',
    );
  }

  ThemeMode _getThemeMode(app_models.ThemeMode themeMode) {
    switch (themeMode) {
      case app_models.ThemeMode.light:
        return ThemeMode.light;
      case app_models.ThemeMode.dark:
        return ThemeMode.dark;
      case app_models.ThemeMode.system:
        return ThemeMode.system;
    }
  }
}

class TasbihScreen extends ConsumerStatefulWidget {
  const TasbihScreen({super.key});

  @override
  ConsumerState<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends ConsumerState<TasbihScreen> {
  int _count = 0;
  bool _isLoading = true;
  Dhikr? _selectedDhikr;

  @override
  void initState() {
    super.initState();
    _loadCount();
    _initializeShortcuts();
    _initializeNotifications();
  }

  void _initializeShortcuts() {
    final shortcutsNotifier = ref.read(shortcutsProvider.notifier);
    shortcutsNotifier.initializeShortcutHandler((String shortcutType) {
      shortcutsNotifier.handleShortcut(shortcutType, (Map<String, dynamic> dhikrData) {
        final dhikr = Dhikr(
          id: dhikrData['id'],
          title: dhikrData['title'],
          arabicText: dhikrData['arabicText'],
          targetCount: dhikrData['targetCount'],
          category: dhikrData['category'],
          transliteration: dhikrData['transliteration'],
          meaning: dhikrData['meaning'],
        );
        setState(() {
          _selectedDhikr = dhikr;
          _count = 0;
        });
        _saveCount();
      });
    });
  }

  void _initializeNotifications() {
    // Initialize notifications when app starts
    final notificationNotifier = ref.read(notificationSettingsProvider.notifier);
    notificationNotifier.initializeNotifications();
  }

  Future<void> _loadCount() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedDhikrId = prefs.getString('selected_dhikr_id');

    // Load current session if exists
    final currentSession = ref.read(sessionProvider);

    setState(() {
      _selectedDhikr = selectedDhikrId != null
          ? DhikrData.getDhikrById(selectedDhikrId)
          : DhikrData.categories.first.dhikrs.first;

      // Use session count if session exists, otherwise load from preferences
      _count = currentSession?.currentCount ?? prefs.getInt('tasbih_count') ?? 0;
      _isLoading = false;
    });

    // Start new session if none exists and dhikr is selected
    if (currentSession == null && _selectedDhikr != null) {
      await ref.read(sessionProvider.notifier).startSession(_convertToNewDhikr(_selectedDhikr!));
    }
  }

  Future<void> _saveCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tasbih_count', _count);
    if (_selectedDhikr != null) {
      await prefs.setString('selected_dhikr_id', _selectedDhikr!.id);
    }
  }

  void _incrementCounter() async {
    setState(() {
      _count++;
    });

    // Update session count
    await ref.read(sessionProvider.notifier).incrementCount();

    // Update achievements and goals
    _updateAchievements();
    _updateGoals();

    // Update widget
    final widgetNotifier = ref.read(widgetProvider.notifier);
    await widgetNotifier.updateWidget(
      currentCount: _count,
      dhikrName: _selectedDhikr?.title ?? 'سبحان الله',
      targetCount: _selectedDhikr?.targetCount ?? 33,
      targetReached: _selectedDhikr != null && _count >= _selectedDhikr!.targetCount,
    );

    // Show progress notification for long sessions
    final notificationNotifier = ref.read(notificationSettingsProvider.notifier);
    if (_selectedDhikr != null && _selectedDhikr!.targetCount > 10) {
      await notificationNotifier.showProgressNotification(
        _count,
        _selectedDhikr!.targetCount,
        _selectedDhikr!.title,
      );
    }

    // Get audio and vibration settings
    final settings = ref.read(settingsProvider);
    final audioController = ref.read(audioControlProvider);

    // Play audio if enabled
    if (settings.soundEnabled && _selectedDhikr != null) {
      await audioController.playDhikrAudio(_selectedDhikr!.id);
    }

    // Vibrate if enabled
    if (settings.vibrationEnabled) {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 50);
      }
    }

    await _saveCount();

    // Check if target reached and celebrate
    final currentSession = ref.read(sessionProvider);
    final targetReached = (currentSession != null && currentSession.hasReachedTarget) ||
                         (_selectedDhikr != null && _count >= _selectedDhikr!.targetCount);

    if (targetReached) {
      // print('🎯 Target reached for ${_selectedDhikr?.title} in category ${_selectedDhikr?.category}');
      _celebrateCompletion();
    }
  }

  void _resetCounter() async {
    setState(() {
      _count = 0;
    });

    // Reset session
    await ref.read(sessionProvider.notifier).resetSession();
    await _saveCount();

    // Clear progress notification
    final notificationNotifier = ref.read(notificationSettingsProvider.notifier);
    await notificationNotifier.clearProgressNotification();
  }

  // Convert old dhikr model to new model
  new_models.Dhikr _convertToNewDhikr(Dhikr oldDhikr) {
    return new_models.Dhikr.create(
      titleKey: oldDhikr.title,
      arabicText: oldDhikr.arabicText,
      targetCount: oldDhikr.targetCount,
      categoryId: oldDhikr.category,
      transliteration: oldDhikr.transliteration,
      meaningKey: oldDhikr.meaning,
    );
  }

  // Update achievements based on usage
  void _updateAchievements() {
    final achievementsNotifier = ref.read(achievementsProvider.notifier);
    final notificationNotifier = ref.read(notificationSettingsProvider.notifier);

    // Update first session achievement
    if (_count == 1) {
      achievementsNotifier.updateProgress('first_session', 1);
      notificationNotifier.showAchievementNotification(
        'بداية رائعة!',
        'تهانينا على بداية رحلتك مع الذكر',
      );
    }

    // Update count-based achievements
    achievementsNotifier.updateProgress('hundred_count', _count);

    // Show achievement notifications for milestones
    if (_count % 100 == 0 && _count > 0) {
      notificationNotifier.showAchievementNotification(
        'إنجاز متميز!',
        'لقد وصلت إلى $_count من الذكر. بارك الله فيك!',
      );
    }

    // Update session-based achievements would need session history
    // This is a simplified version
  }

  // Update goals based on usage
  void _updateGoals() {
    final goals = ref.read(activeGoalsProvider);
    final goalsNotifier = ref.read(goalsProvider.notifier);
    final currentSession = ref.read(sessionProvider);

    for (final goal in goals) {
      switch (goal.type) {
        case GoalType.dailySessions:
          // Update when a session is completed
          if (currentSession != null && currentSession.isCompleted) {
            int currentProgress = goal.currentProgress + 1;
            goalsNotifier.updateGoalProgress(goal.id, currentProgress);
          }
          break;
        case GoalType.weeklyCount:
          // Update weekly count goals (only count if this is the right dhikr or any dhikr)
          if (goal.dhikrId == null || goal.dhikrId == _selectedDhikr?.id) {
            int newProgress = goal.currentProgress + 1;
            goalsNotifier.updateGoalProgress(goal.id, newProgress);
          }
          break;
        case GoalType.monthlyTime:
          // This would need time tracking - skip for now
          break;
        case GoalType.consecutiveDays:
          // This needs daily tracking - handled separately when sessions are completed
          break;
        case GoalType.specificDhikr:
          // Update if this matches the specific dhikr
          if (goal.dhikrId == _selectedDhikr?.id) {
            int newProgress = goal.currentProgress + 1;
            goalsNotifier.updateGoalProgress(goal.id, newProgress);
          }
          break;
        case GoalType.totalCount:
          // Update total count goals
          int newProgress = goal.currentProgress + 1;
          goalsNotifier.updateGoalProgress(goal.id, newProgress);
          break;
      }

      // Check if goal was just completed and show notification
      if (goal.currentProgress < goal.target && goal.currentProgress + 1 >= goal.target) {
        final notificationNotifier = ref.read(notificationSettingsProvider.notifier);
        notificationNotifier.showCustomNotification(
          title: '🎯 هدف مكتمل!',
          body: 'تهانينا! لقد أكملت هدف "${goal.title}"',
          payload: 'goal_completed_${goal.id}',
        );
      }
    }
  }

  // Celebrate completion
  void _celebrateCompletion() {
    final notificationController = ref.read(notificationControllerProvider);
    final audioController = ref.read(audioControlProvider);

    notificationController.celebrateCompletion();
    audioController.playCompletionSound();

    // Check if this is a sequential category (morning, evening, or after-prayer) and auto-advance
    if (_selectedDhikr != null &&
        (_selectedDhikr!.category == 'morning_adhkar' ||
         _selectedDhikr!.category == 'evening_adhkar' ||
         _selectedDhikr!.category == 'after_prayer_adhkar')) {
      _autoAdvanceToNextDhikr();
    } else {
      // Show completion dialog for other categories
      _showCompletionDialog();
    }
  }

  // Auto advance to next dhikr in morning/evening categories
  void _autoAdvanceToNextDhikr() {
    if (_selectedDhikr == null) return;

    // print('🔄 Auto-advancing from ${_selectedDhikr!.title} in category ${_selectedDhikr!.category}');

    final currentCategory = DhikrData.categories.firstWhere(
      (category) => category.id == _selectedDhikr!.category,
    );

    final currentIndex = currentCategory.dhikrs.indexWhere(
      (dhikr) => dhikr.id == _selectedDhikr!.id,
    );

    // print('📍 Current dhikr index: $currentIndex of ${currentCategory.dhikrs.length}');

    if (currentIndex >= 0 && currentIndex < currentCategory.dhikrs.length - 1) {
      // Move to next dhikr in the same category
      final nextDhikr = currentCategory.dhikrs[currentIndex + 1];

      // print('➡️ Moving to next dhikr: ${nextDhikr.title}');

      setState(() {
        _selectedDhikr = nextDhikr;
        _count = 0;
      });
      _saveCount();

      // Start new session with next dhikr
      ref.read(sessionProvider.notifier).startSession(_convertToNewDhikr(nextDhikr));
    } else {
      // This was the last dhikr in the category
      // print('🎊 Reached end of category');
      _showCategoryCompletionDialog();
    }
  }

  // Show completion dialog for regular dhikr
  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text('🎉 ${l10n.targetCompleted}'),
          content: Text(l10n.congratulations),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startNewSession();
              },
              child: Text(l10n.startNewSession),
            ),
          ],
        );
      },
    );
  }

  // Show completion dialog when entire category is finished
  void _showCategoryCompletionDialog() {
    final categoryName = _selectedDhikr?.category == 'morning_adhkar'
        ? 'أذكار الصباح'
        : _selectedDhikr?.category == 'evening_adhkar'
            ? 'أذكار المساء'
            : 'أذكار ما بعد الصلاة';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('🎊 تم إكمال الفئة'),
          content: Text('تهانينا! لقد أكملت جميع $categoryName'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إنهاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showDhikrSelection();
              },
              child: const Text('اختر فئة أخرى'),
            ),
          ],
        );
      },
    );
  }

  // Start new session with same dhikr
  void _startNewSession() async {
    if (_selectedDhikr != null) {
      await ref.read(sessionProvider.notifier).startSession(_convertToNewDhikr(_selectedDhikr!));
      setState(() {
        _count = 0;
      });
    }
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('إعادة تعيين العداد'),
          content: const Text('هل تريد إعادة تعيين العداد إلى الصفر؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetCounter();
              },
              child: const Text('إعادة تعيين'),
            ),
          ],
        );
      },
    );
  }

  void _showDhikrSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DhikrSelectionScreen(
          currentDhikr: _selectedDhikr,
          onDhikrSelected: (dhikr) {
            setState(() {
              _selectedDhikr = dhikr;
              _count = 0;
            });
            _saveCount();
            // Add to recently used
            ref.read(dhikrRecentlyUsedProvider.notifier).addToRecentlyUsed(dhikr.id);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'السبحة الرقمية',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            onPressed: _showDhikrSelection,
            icon: const Icon(Icons.list, color: Colors.white),
            tooltip: 'اختر الذكر',
          ),
          IconButton(
            onPressed: _showResetDialog,
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'إعادة تعيين',
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: const Icon(Icons.settings, color: Colors.white),
            tooltip: 'الإعدادات',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'statistics':
                  Navigator.pushNamed(context, '/statistics');
                  break;
                case 'goals':
                  Navigator.pushNamed(context, '/goals');
                  break;
                case 'custom':
                  Navigator.pushNamed(context, '/custom-dhikr');
                  break;
                case 'advanced':
                  Navigator.pushNamed(context, '/advanced');
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              final l10n = AppLocalizations.of(context)!;
              return [
                PopupMenuItem(
                  value: 'statistics',
                  child: Row(
                    children: [
                      const Icon(Icons.analytics),
                      const SizedBox(width: 8),
                      Text(l10n.statistics),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'goals',
                  child: Row(
                    children: [
                      const Icon(Icons.track_changes),
                      const SizedBox(width: 8),
                      const Text('الأهداف'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'custom',
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 8),
                      Text(l10n.customDhikr),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'advanced',
                  child: Row(
                    children: [
                      const Icon(Icons.extension),
                      const SizedBox(width: 8),
                      Text(l10n.advancedFeatures),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              if (_selectedDhikr != null) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        _selectedDhikr!.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _selectedDhikr!.arabicText,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: null,
                      ),
                      if (_selectedDhikr!.meaning != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _selectedDhikr!.meaning!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: null,
                        ),
                      ],
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          'الهدف: ${_selectedDhikr!.targetCount}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (_selectedDhikr != null && _count >= _selectedDhikr!.targetCount) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    '✓ تم إكمال الهدف',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 40),
              GestureDetector(
                onTap: _incrementCounter,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
                        spreadRadius: 5,
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$_count',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _selectedDhikr?.title ?? 'سبح',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _showDhikrSelection,
                icon: const Icon(Icons.list),
                label: const Text('تغيير نوع الذكر'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 80), // Extra space for floating action button
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickSettings,
        tooltip: 'Quick Settings',
        child: const Icon(Icons.tune),
      ),
    );
  }

  void _showQuickSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const QuickSettingsPanel(),
    ).then((result) {
      if (result == 'reset') {
        _resetCounter();
      } else if (result == 'select_dhikr') {
        _showDhikrSelection();
      }
    });
  }

}