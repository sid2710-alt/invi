import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:invi/blocs/invoices_bloc/InvoiceBloc.dart';
import 'package:invi/blocs/navigator_bloc/navigator_bloc.dart';
import 'package:invi/screens/home_screen.dart';
import 'package:invi/screens/invoice_add_screen.dart';

class AppShell extends StatelessWidget {
  // Define the GoRouter
  final GoRouter _router = GoRouter(
    initialLocation: '/home', // Set the initial route
    routes: [
      // Home route
      GoRoute(
        path: '/home',
        builder: (context, state) {
          return HomeScreen(); // Your home screen widget
        },
      ),
      // Add Invoice route
      GoRoute(
        path: '/add-invoice',
        builder: (context, state) {
          return const AddInvoiceScreen(); // Add invoice screen widget
        },
      ),
    ],
  );

  AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
     providers: [
      BlocProvider(create: (context)=> InvoiceBloc()),
      BlocProvider(create: (context)=> NavigationBloc())
     ],
     child: MaterialApp.router(
      title: 'Invoice Generator',
      routerConfig: _router, // Pass the GoRouter configuration
    ));
  }
}