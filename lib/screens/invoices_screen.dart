import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invi/blocs/invoices_bloc/InvoiceBloc.dart';
import 'package:invi/blocs/invoices_bloc/invoices_state.dart';
import 'package:invi/blocs/invoices_bloc/invoice_event.dart';


class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
     context.read<InvoiceBloc>().add(LoadInvoicesEvent());

    return Scaffold(
      appBar: AppBar(
        title: Text("Invoices"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigate to Create Invoice screen
            },
          ),
        ],
      ),
      body: BlocConsumer<InvoiceBloc, InvoiceState>(
        listener: (context, state) {
          // You can add listeners here if needed (e.g., showing a snackbar on error)
          if (state is InvoiceErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is InvoiceLoadingState) {
            // Show loading indicator while invoices are being loaded
            return Center(child: CircularProgressIndicator());
          }

          if (state is InvoiceLoadedState) {
            // Show list of invoices when loaded successfully
            final invoices = state.invoices;
            return ListView.builder(
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                final invoice = invoices[index];
                return ListTile(
                  title: Text(invoice.clientName),
                  subtitle: Text("Amount: \$${invoice.amount}"),
                  trailing: Text(
                    "${invoice.date.day}/${invoice.date.month}/${invoice.date.year}",
                  ),
                  onTap: () {
                    // Handle invoice tap, e.g., navigate to invoice detail screen
                  },
                  onLongPress: () {
                    // Handle invoice long press, e.g., delete the invoice
                    _showDeleteConfirmationDialog(context, invoice.id);
                  },
                );
              },
            );
          }

          if (state is InvoiceErrorState) {
            // Show an error message if something goes wrong
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 50),
                  SizedBox(height: 10),
                  Text(
                    'Failed to load invoices',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Retry loading invoices
                      context.read<InvoiceBloc>().add(LoadInvoicesEvent());
                    },
                    child: Text("Retry"),
                  ),
                ],
              ),
            );
          }

          // Return a default widget if no known state
          return Center(child: Text("No invoices found"));
        },
      ),
    );
  }

  // Helper function to show delete confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context, String invoiceId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Invoice"),
          content: Text("Are you sure you want to delete this invoice?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Trigger delete invoice event in BLoC
                context.read<InvoiceBloc>().add(DeleteInvoiceEvent(invoiceId));
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
