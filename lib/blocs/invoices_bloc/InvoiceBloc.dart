import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invi/api/invoice_api.dart';
import 'package:invi/blocs/invoices_bloc/invoice_event.dart';
import 'package:invi/blocs/invoices_bloc/invoices_state.dart';
import 'package:invi/models/invoice.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc() : super(InvoiceInitialState([])) {
    on<LoadInvoicesEvent>((event, emit) async {
      emit(InvoiceLoadingState(state.invoices));
      try {
        List<Invoice> invoices = (await InvoiceApi.fetchInvoices()).cast<Invoice>();

        emit(InvoiceLoadedState(invoices));
      } catch (e) {
        emit(InvoiceErrorState(e.toString(), state.invoices));
      }
    });
    on<CreateInvoiceEvent>((event, emit)  async{
      emit(InvoiceLoadingState(state.invoices));
      try {
        int id = await InvoiceApi.saveInvoice(event.invoice);
        final currentInvoices = List<Invoice>.from(state.invoices);
        currentInvoices.add(event.invoice.copyWith(id: id));
        emit(InvoiceLoadedState(currentInvoices));
      } catch (e) {
        emit(InvoiceErrorState(e.toString(), state.invoices));
      }
    });
    on<DeleteInvoiceEvent>((event, emit) async {
      final currentInvoices = List<Invoice>.from(state.invoices);
      try {
        await Future.delayed(Duration(seconds: 2));
        currentInvoices.removeWhere((element) => element.id == event.invoiceId);
        emit(InvoiceLoadedState(currentInvoices));
      } catch (err) {
        emit(InvoiceLoadedState(currentInvoices));
      }
    });
  }
}
