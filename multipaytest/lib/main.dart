import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:multipay/multipay.dart';
import 'package:multipaytest/app_provider.dart';
import 'package:multipaytest/futuristic.dart';
import 'package:multipaytest/home_page.dart';
import 'package:multipaytest/loading_component.dart';
import 'package:multipaytest/page_args.dart';
import 'package:multipaytest/page_manager.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MyApp(),
    ),
  );
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyApp> {
  late Locale _locale = const Locale("es", '');
  MultiPayClientModel client = MultiPayClientModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', ''),
        Locale('en', ''),
      ],
      navigatorKey: PageManager().navigatorKey,
      locale: _locale,
      onGenerateRoute: (settings) {
        return PageManager().getRoute(settings);
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Gotham Rounded',
        scrollbarTheme: ScrollbarThemeData(
          trackColor: MaterialStateProperty.all(Colors.grey),
          thumbColor: MaterialStateProperty.all(const Color(0xFF9B9B9B)),
          trackBorderColor: MaterialStateProperty.all(Colors.grey),
          // showTrackOnHover: true,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      title: 'Proteo Bingo',
      home: _home(),
    );
  }

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  _home() {
    return Futuristic<void>(
      futureBuilder: () => _initApp(client),
      busyBuilder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.37,
          child: loadingComponent(true)),
      dataBuilder: (context, data) => _initPage(client),
    );
  }

  _initPage(MultiPayClientModel client) {
    return HomePage(PageArgs(
      client: client,
    ));
  }

  _initApp(MultiPayClientModel client) async {
    await client.setMercadoPagoCredentials(
      publicKey: "TEST-fb900cb7-f5df-4629-b7ae-e233ce73ba68",
      sandbox: true,
    );

    client.setUalaBisCredentials(
      userName: "new_user_1631906477",
      clientId: "5qqGKGm4EaawnAH0J6xluc6AWdQBvLW3",
      clientSecret:
          "cVp1iGEB-DE6KtL4Hi7tocdopP2pZxzaEVciACApWH92e8_Hloe8CD5ilM63NppG",
      grantType: "client_credentials",
    );
  }
}
