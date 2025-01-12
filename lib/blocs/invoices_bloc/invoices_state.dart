import 'package:invi/models/invoice.dart';

abstract class InvoiceState {
  final List<Invoice> invoices;

  InvoiceState(this.invoices);
}

class InvoiceInitialState extends InvoiceState {
  InvoiceInitialState(super.invoices);
}

class InvoiceLoadingState extends InvoiceState {
   InvoiceLoadingState(super.invoices);
}

class InvoiceLoadedState extends InvoiceState {
  InvoiceLoadedState(super.invoices);
}

class InvoiceErrorState extends InvoiceState {
  final String message;
  InvoiceErrorState(this.message, super.invoices);
}
