import 'package:flutter/material.dart';

class SizeConfig {
  // class MediaQuery adalah class yang berfungsi untuk membuat aplikasi menjadi responsive
  // dengan cara mengambil ukuran aktual pada layar platform
  static MediaQueryData _mediaQueryData = MediaQueryData.fromView(
    // ignore: deprecated_member_use
    WidgetsBinding.instance.window
  );
  // variabel untuk menampung default size dari aplikasi 
  // sebelum di deploy ke platform yang spesifik dan 
  // mendapatkan ukuran aktual dari platform tersebut 
  // (misal: di deploy dari android)
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;
  static double defaultSize = 0.0;

  // fungsi dari function ini adalah untuk pemanggilan awal ketika aplikasi dijalankan
  // dan untuk mendapatkan ukuran dari layar platform
  void init(BuildContext context) {
    // berfugsi untuk mengambil ukuran aktual dari platformn
    // karena di dalam variabel _mediaQueryData..
    // di dalam nya memanggil class Media Query
    // yang class Media Query itu sendiri berfungsi untuk
    // mengambil ukuran aktual dari platform
    _mediaQueryData= MediaQuery.of(context);
    // untuk mengambil hanya data ukuran width saja
    screenWidth = _mediaQueryData.size.width;
    // untuk mengambil hanya data ukuran height saja
    screenHeight = _mediaQueryData.size.height;
  }
}
// menggunakan size standard handphone (Iphone X, 812 x 375)
double getProporsionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // ini adalah perhitungan untuk menghasilkan nilai dan ukuran objek yang responsif sesuai dengan platform
  return (inputHeight / 812.0) * screenHeight;
}

double getProporsionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  return (inputWidth / 375.0) * screenWidth;
}