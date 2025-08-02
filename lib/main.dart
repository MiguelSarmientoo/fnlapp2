import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fnlapp/Login/login.dart';
import 'package:fnlapp/Preguntas/index.dart';
import 'package:fnlapp/Main/cargarprograma.dart';
import 'package:fnlapp/Main/home.dart';
import '../Util/api_service.dart';
import 'package:fnlapp/SplashScreen/splashscreen.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:fnlapp/route_decider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Funcy FNL',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Define tus rutas
      initialRoute: '/splash',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
          case '/splash':
            return MaterialPageRoute(builder: (_) => SplashScreen());
          case '/login':
            return MaterialPageRoute(builder: (_) => LoginScreen());
          case '/home':
          case '/index':
            return MaterialPageRoute(
              builder: (_) => RouteWrapper(routeName: settings.name ?? '/'),
              settings: settings,
            );
          default:
            return MaterialPageRoute(builder: (_) => SplashScreen());
        }
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
}
