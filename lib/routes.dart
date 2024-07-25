import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mid/screens/HomeScreen.dart';
import 'package:mid/screens/details_screen.dart';
import 'package:mid/screens/settings_screen.dart';

class Routes {
  static GoRouter generateRoutes() {
    return GoRouter(routes: <RouteBase>[
      GoRoute(
        path: "/",
        builder: (BuildContext context, GoRouterState state) {
          return const Home(); //home Screen
        },
      ),
      GoRoute(
          path: '/settings',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingsScreen(); //
          }),
      GoRoute(
        path: "/details/:id",
        name: "details",
        builder: (context, state) {
          return DetailsScreen(id: int.parse(state.pathParameters['id']!));
        },
      ),
    ]);
  }
}
