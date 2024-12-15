import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invi/blocs/navigator_bloc/navgation_state.dart';
import 'package:invi/blocs/navigator_bloc/navigator_bloc.dart';
import 'package:invi/blocs/navigator_bloc/navigator_event.dart';
import 'package:invi/screens/clients_screen.dart';
import 'package:invi/screens/invoices_screen.dart';
import 'package:invi/screens/templates_screen.dart';// Import the BLoC

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationBloc(), // Provide the Navigation BLoC
      child: Scaffold(
        appBar: AppBar(
          title: Text('Invoice Generator'),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // Navigate to settings screen (if needed)
              },
            ),
          ],
        ),
        body: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            return _pages[state.selectedIndex]; // Display the selected page
          },
        ),
        bottomNavigationBar: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            return BottomNavigationBar(
              currentIndex: state.selectedIndex, // Use the current index
              onTap: (index) {
                context.read<NavigationBloc>().add(SelectTabEvent(index)); // Trigger event
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt),
                  label: 'Invoices',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Clients',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.note),
                  label: 'Templates',
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  final List<Widget> _pages = [
    InvoicesScreen(),
    ClientsScreen(),
    TemplatesScreen(),
  ];

   HomeScreen({super.key});
}
