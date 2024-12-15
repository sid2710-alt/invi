import 'package:invi/models/Invoice.dart';

abstract class InvoiceEvent {}

class LoadInvoicesEvent extends InvoiceEvent {}

class CreateInvoiceEvent extends InvoiceEvent {
  final Invoice invoice;

  CreateInvoiceEvent(this.invoice);
}

class DeleteInvoiceEvent extends InvoiceEvent {
  final String invoiceId;

  DeleteInvoiceEvent(this.invoiceId);
}
