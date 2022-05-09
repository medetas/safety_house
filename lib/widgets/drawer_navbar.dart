// import 'package:eurasia_pass/presentation/screens/pass_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safety_house/constants/strings.dart';
import 'package:safety_house/logic/cubit/session_logic/session_cubit.dart';
import 'package:safety_house/models/profile.dart';
import 'package:safety_house/repositories/profile_repository.dart';
import 'package:safety_house/screens/home_screen.dart';
import 'package:safety_house/screens/profile_screen.dart';
import 'package:safety_house/widgets/loading_view.dart';
import 'package:safety_house/widgets/page_error.dart';

//bottom navbar with 4 tabs
class CustomDrawerNavigation extends StatefulWidget {
  const CustomDrawerNavigation({Key? key}) : super(key: key);

  @override
  _CustomDrawerNavigationState createState() => _CustomDrawerNavigationState();
}

class _CustomDrawerNavigationState extends State<CustomDrawerNavigation> {
  var _currentTab = Tabs.home;
  final _navigatorKeys = {
    Tabs.home: GlobalKey<NavigatorState>(),
    Tabs.profile: GlobalKey<NavigatorState>(),
    Tabs.history: GlobalKey<NavigatorState>(),
    Tabs.map: GlobalKey<NavigatorState>(),
    Tabs.settings: GlobalKey<NavigatorState>(),
    Tabs.about: GlobalKey<NavigatorState>(),
  };

  void _selectTab(Tabs tabItem) {
    keyDrawer.currentState!.openEndDrawer();

    if (tabItem == _currentTab) {
      // pop to first route
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ProfileRepository().fetchProfile(),
      builder: (context, AsyncSnapshot<ProfileModel> snapshot) {
        if (snapshot.hasData) {
          return WillPopScope(
            onWillPop: () async {
              final isFirstRouteInCurrentTab =
                  !await _navigatorKeys[_currentTab]!.currentState!.maybePop();
              if (isFirstRouteInCurrentTab) {
                // if not on the 'main' tab
                if (_currentTab != Tabs.home) {
                  // select 'main' tab
                  _selectTab(Tabs.home);
                  // back button handled by app
                  return false;
                }
              }
              // let system handle back button if we're on the first route
              return isFirstRouteInCurrentTab;
            },
            child: Scaffold(
              appBar: AppBar(
                elevation: 2,
                leading: IconButton(
                  onPressed: () {
                    if (keyDrawer.currentState!.isDrawerOpen) {
                      keyDrawer.currentState!.openEndDrawer();
                    } else {
                      keyDrawer.currentState!.openDrawer();
                    }
                  },
                  icon: Icon(Icons.menu),
                ),
              ),
              body: Scaffold(
                key: keyDrawer,
                drawer: DrawerNavigation(
                  currentTab: _currentTab,
                  onSelectTab: _selectTab,
                ),
                body: Stack(fit: StackFit.expand, children: <Widget>[
                  //tabs
                  _buildOffstageNavigator(Tabs.home, snapshot.data!),
                  _buildOffstageNavigator(Tabs.profile, snapshot.data!),
                  _buildOffstageNavigator(Tabs.history, snapshot.data!),
                  _buildOffstageNavigator(Tabs.map, snapshot.data!),
                  _buildOffstageNavigator(Tabs.settings, snapshot.data!),
                  _buildOffstageNavigator(Tabs.about, snapshot.data!),
                ]),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(body: CustomPageError());
        }
        return Scaffold(body: CustomPageLoader());
      },
    );
  }

//tab
  Widget _buildOffstageNavigator(Tabs tabItem, ProfileModel userInfo) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
        userInfo: userInfo,
      ),
    );
  }
}

//bottom navbar
class DrawerNavigation extends StatelessWidget {
  const DrawerNavigation({
    Key? key,
    required this.currentTab,
    required this.onSelectTab,
  }) : super(key: key);
  final Tabs currentTab;
  final ValueChanged<Tabs> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.separated(
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return TextButton(
            onPressed: () {
              if (index == menu.length - 1) {
                BlocProvider.of<SessionCubit>(context).signOut();
              } else {
                onSelectTab(Tabs.values[index]);
              }
            },
            style: ButtonStyle(alignment: Alignment.centerLeft),
            child: Text(
              '${menu[index]}',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: menu.length,
      ),
    );
  }
}

class TabNavigatorRoutes {
  static const String root = '/';
}

class TabNavigator extends StatelessWidget {
  const TabNavigator({
    Key? key,
    required this.navigatorKey,
    required this.tabItem,
    required this.userInfo,
  }) : super(key: key);
  final GlobalKey<NavigatorState>? navigatorKey;
  final Tabs tabItem;
  final ProfileModel userInfo;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, Tabs tab) {
    return {
      TabNavigatorRoutes.root: (context) {
        switch (tab) {
          case Tabs.home:
            return HomeScreen(userInfo: userInfo);
          case Tabs.profile:
            return ProfileScreen(userInfo: userInfo);
          case Tabs.history:
            return ProfileScreen(userInfo: userInfo);
          case Tabs.map:
            return ProfileScreen(userInfo: userInfo);
          case Tabs.settings:
            return ProfileScreen(userInfo: userInfo);
          case Tabs.about:
            return ProfileScreen(userInfo: userInfo);
          default:
            return HomeScreen(
              userInfo: userInfo,
            );
        }
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context, tabItem);
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name!]!(context),
        );
      },
    );
  }
}
