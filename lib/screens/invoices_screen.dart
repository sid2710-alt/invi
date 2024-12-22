import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
              context.go('/add-invoice');
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
                return Card(
                  child: ListTile(
                    title: Text(invoice.clientName),
                    subtitle: Text(
                        "Amount: \$${invoice.totalAmount.toStringAsFixed(2)}"),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'send') {
                          // Trigger send action
                          print("Send Invoice: ${invoice.id}");
                        } else if (value == 'download') {
                          // Trigger download action
                          print("Download Invoice: ${invoice.id}");
                        } else if (value == 'delete') {
                          // Trigger delete action
                          context.read<InvoiceBloc>().add(
                                DeleteInvoiceEvent(invoice.id),
                              );
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 'send',
                          child: Text('Send Invoice'),
                        ),
                        PopupMenuItem(
                          value: 'download',
                          child: Text('Download as PDF'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete Invoice'),
                        ),
                      ],
                    ),
                  ),
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
                  const Text(
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
}
