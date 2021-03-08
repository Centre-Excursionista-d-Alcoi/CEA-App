import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('ca', 'ES')],
        path: 'assets/translations',
        // <-- change the path of the translation files
        fallbackLocale: Locale('ca', 'ES'),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class NotificationItem {
  NotificationItem({
    this.title,
    this.message,
    this.icon,
    this.isExpanded = false,
  });

  String title;
  String message;
  int icon;
  bool isExpanded;
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  List<NotificationItem> _notifications = [
    NotificationItem(
      icon: 1,
      title: "Secció d'Escalada",
      message: "Reunió el pròxim 23 de març de 2021.",
    ),
    NotificationItem(
      icon: 2,
      title: "Secció d'Escalada",
      message: "Paco Franco ha agafat una corda de 30 metres del magatzem.",
    ),
    NotificationItem(
      icon: 1,
      title: "General",
      message:
          "Ha arribat la teua federativa. Per favor, passa pel CEA en horari d'oficina a recollir-la.",
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: <Widget>[
        SingleChildScrollView(
          child: Container(
            child: ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _notifications[index].isExpanded = !isExpanded;
                });
              },
              children:
                  _notifications.map<ExpansionPanel>((NotificationItem item) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    print(item.icon);
                    return ListTile(
                      leading: <Icon>[
                        Icon(Icons.close_rounded),
                        Icon(Icons.people_rounded),
                        Icon(Icons.book_rounded),
                      ][item.icon == null ? 0 : item.icon],
                      title: Text(item.title),
                    );
                  },
                  body: ListTile(
                    title: Text(item.message),
                    trailing: Icon(Icons.delete_rounded),
                    onTap: () {
                      setState(() {
                        _notifications
                            .removeWhere((currentItem) => item == currentItem);
                      });
                    },
                  ),
                  isExpanded: item.isExpanded,
                );
              }).toList(),
            ),
          ),
        ),
        Center(
          child: Text("Calendar"),
        ),
        Center(
          child: Text("Card"),
        ),
        Center(
          child: Text("Settings"),
        ),
      ][_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_rounded),
            label: tr("item_notifications"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: tr("item_calendar"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: tr("item_card"),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightGreen[600],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      appBar: AppBar(title: const Text('Centre Excursionista d\'Alcoi')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightGreen[500],
              ),
              child: Wrap(
                direction: Axis.vertical,
                children: [
                  Text(
                    'CEA App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Text('info_version').tr(),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.add_rounded),
              title: Text('side_item_new_event').tr(),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.qr_code_scanner_rounded),
              title: Text('side_item_scanner').tr(),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings_rounded),
              title: Text('side_item_settings').tr(),
            ),
          ],
        ),
      ),
    );
  }
}
