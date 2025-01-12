import 'package:invi/models/invoice.dart';

abstract class InvoiceEvent {}

class LoadInvoicesEvent extends InvoiceEvent {}

class CreateInvoiceEvent extends InvoiceEvent {
  final Invoice invoice;

  CreateInvoiceEvent(this.invoice);
}

class DeleteInvoiceEvent extends InvoiceEvent {
  final int invoiceId;

  DeleteInvoiceEvent(this.invoiceId);
}
