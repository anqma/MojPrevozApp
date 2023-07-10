import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moj_prevoz/home/prebaraj_prevoz.dart';
import 'package:moj_prevoz/home/ponudeni_prevozi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moj_prevoz/widgets/login_widget.dart';

import 'blocs/list_bloc.dart';
import 'blocs/list_event.dart';
import 'dodadi_prevoz.dart';

import 'home/list_detail_screen.dart';
import 'home/profil.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

Color myColor = Color.fromARGB(255, 59, 60, 153);
Color myColorLight = Color.fromARGB(255, 142, 168, 242);

MaterialColor myPurple = MaterialColor(
  myColor.value,
  <int, Color>{
    50: myColor.withOpacity(0.1),
    100: myColor.withOpacity(0.2),
    200: myColor.withOpacity(0.3),
    300: myColor.withOpacity(0.4),
    400: myColor.withOpacity(0.5),
    500: myColor.withOpacity(0.6),
    600: myColor.withOpacity(0.7),
    700: myColor.withOpacity(0.8),
    800: myColor.withOpacity(0.9),
    900: myColor.withOpacity(1.0),
  },
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Bar Example',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          } else if (snapshot.hasData) {
            return MainScreen();
          } else {
            return LoginWidget();
          }
        },
      ),
      routes: {
        '/prebaraj_prevoz': (context) => PrebarajPrevoz(),
        '/dodadi_prevoz': (context) => DodadiPrevoz(),
        '/ponudeni_prevozi': (context) => PonudeniPrevozi(),
        '/list_detail': (context) => ListDetailScreen()
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: myPurple)
            .copyWith(secondary: myPurple),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    PonudeniPrevozi(),
    PrebarajPrevoz(),
    DodadiPrevoz(),
    ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListBloc>(
      create: (BuildContext context) => ListBloc()..add(ListInitializedEvent()),
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          backgroundColor: myColorLight,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: FaIcon(
                FontAwesomeIcons.car,
                color: Colors.white,
              ),
              label: 'Сите превози',
            ),
            NavigationDestination(
              icon: FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                color: Colors.white,
              ),
              label: 'Пребарај',
            ),
            NavigationDestination(
              icon: FaIcon(
                FontAwesomeIcons.plus,
                color: Colors.white,
              ),
              label: 'Додади превоз',
            ),
            NavigationDestination(
              icon: FaIcon(
                FontAwesomeIcons.solidUser,
                color: Colors.white,
              ),
              label: 'Профил',
            ),
          ],
        ),
        body: IndexedStack(
          index: currentPageIndex,
          children: _widgetOptions,
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Welcome, user!'),
      ),
    );
  }
}
