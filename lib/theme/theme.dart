import 'package:flutter/material.dart';

final dartTheme = ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 30, 30, 30),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 30, 30, 30),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          )
        ),
        textTheme: TextTheme(
          bodyMedium: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20
          ),
          labelSmall: TextStyle(
            color: Colors.white60 ,
            fontWeight: FontWeight.w700,
            fontSize: 14
          ),
        ),
        listTileTheme: ListTileThemeData(
          iconColor: Colors.white
        )
      );