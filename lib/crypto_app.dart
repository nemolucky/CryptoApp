import 'package:crypto_app/router/router.dart';
import 'package:crypto_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';


class CryptoApp extends StatefulWidget {
  const CryptoApp({super.key});

  @override
  State<CryptoApp> createState() => _CryptoAppState();
}

class _CryptoAppState extends State<CryptoApp> {
  final _appRouter = AppRouter();


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme:dartTheme,
      routerConfig: _appRouter.config(
        navigatorObservers: () => [
          TalkerRouteObserver(GetIt.I<Talker>()),
        ]
      ),
    );
  }
}