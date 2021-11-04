import 'package:flutter/material.dart';
import 'package:notsepeti/pages/notlistesi.dart';
import 'package:notsepeti/utils/database_helper.dart';


void main()=>runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DatabaseHelper databaseHelper=DatabaseHelper();
    databaseHelper.kategorileriGetir();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      home: const NotListesi()
    );
  }
}