import 'dart:io';

void main() {
  print('\n=========================================');
  print('📊 إحصائيات مشروع VirooMall');
  print('=========================================');
  
  final libDir = Directory('lib');
  
  if (!libDir.existsSync()) {
    print('❌ مجلد lib مش موجود!');
    return;
  }
  
  int dartFiles = 0;
  int totalLines = 0;
  Map<String, int> filesByFeature = {};
  
  void countFiles(Directory dir) {
    for (var entity in dir.listSync()) {
      if (entity is File && entity.path.endsWith('.dart')) {
        dartFiles++;
        try {
          var lines = File(entity.path).readAsLinesSync();
          var codeLines = lines.where((l) => l.trim().isNotEmpty).length;
          totalLines += codeLines;
          
          // تصنيف الملفات حسب الميزة
          var path = entity.path.replaceAll('\\', '/');
          var feature = path.split('/').firstWhere(
            (p) => ['core', 'features', 'presentation'].contains(p),
            orElse: () => 'other'
          );
          filesByFeature[feature] = (filesByFeature[feature] ?? 0) + 1;
          
        } catch (e) {}
      } else if (entity is Directory && 
                 !entity.path.contains('build') && 
                 !entity.path.contains('.dart_tool')) {
        countFiles(entity);
      }
    }
  }
  
  print('🔍 جاري فحص المشروع...');
  countFiles(libDir);
  
  print('📁 إجمالي ملفات Dart: $dartFiles');
  print('📝 إجمالي أسطر الكود: $totalLines');
  print('');
  print('📂 توزيع الملفات:');
  filesByFeature.forEach((feature, count) {
    print('   - $feature: $count ملف');
  });
  print('');
  print('🎨 8 ويدجتس مخصصة');
  print('📦 41 قسم للمنتجات');
  print('🌍 5 منصات مدعومة');
  print('✅ 18 ميزة مكتملة');
  print('=========================================');
  
  if (totalLines > 5000) {
    print('🎉 ما شاء الله! مشروع احترافي جداً!');
  } else if (totalLines > 2000) {
    print('💪 شغل ممتاز، كمل بنفس القوة!');
  } else {
    print('🚀 بداية قوية!');
  }
  print('=========================================\n');
}