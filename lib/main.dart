import 'dart:async';
import 'package:crypto_app/crypto_app.dart';
import 'package:crypto_app/firebase_options.dart';
import 'package:crypto_app/repositories/crypto_coins/crypto_coins.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_settings.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() async {
  runZonedGuarded(() async {
    // Инициализация базовых компонентов Flutter
    WidgetsFlutterBinding.ensureInitialized();
    
    // Настройка Talker (логирование)
    final talker = TalkerFlutter.init();
    GetIt.I.registerSingleton(talker);
    GetIt.I<Talker>().debug("Talker started...");

    await Hive.initFlutter();

    const cryptoCoinsBoxName = 'crypto_coins_box';

    Hive.registerAdapter(CryptoCoinAdapter());
    Hive.registerAdapter(CryptoCoinDetailAdapter());

    final cryptoCoinsBox = await Hive.openBox<CryptoCoin>(cryptoCoinsBoxName);
    
    // Инициализация Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Настройка Dio с интерцептором
    final dio = Dio();
    dio.interceptors.add(TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printResponseData: false,
      ),
    ));
    
    // Настройка Bloc Observer
    Bloc.observer = TalkerBlocObserver(
      talker: talker,
      settings: const TalkerBlocLoggerSettings(
        printEventFullData: false,
        printStateFullData: false,
      ),
    );
    
    // Регистрация репозитория
    GetIt.I.registerLazySingleton<AbstractCoinsRepository>(
      () => CryptoCoinsRepository(
        dio: dio,
        cryptoCoinsBox: cryptoCoinsBox,
        ),
    );
    
    // Обработка ошибок Flutter
    FlutterError.onError = (details) {
      GetIt.I<Talker>().handle(details.exception, details.stack);
    };
    
    // Запуск приложения
    runApp(const CryptoApp());
  }, 
  // Обработчик ошибок зоны
  (error, stackTrace) {
    GetIt.I<Talker>().handle(error, stackTrace);
  });
}



