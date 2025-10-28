import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:peekit_app/bindings/app_bindings.dart';
import 'package:peekit_app/routes/app_pages.dart';
import 'package:peekit_app/utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // load environment variable first before the app
  await dotenv.load(fileName: '.env');
  runApp(PeekitApp());
}

class PeekitApp extends StatelessWidget {
  const PeekitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Peekit',
      theme: ThemeData(
        fontFamily: 'Plus Jakarta Sans',
        primarySwatch: Colors.blue,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          )
        )
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: AppBindings(),
      debugShowCheckedModeBanner: false, // menghilangkan merah
    );
  }
}