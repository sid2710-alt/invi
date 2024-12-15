import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invi/blocs/invoices_bloc/invoice_event.dart';
import 'package:invi/blocs/invoices_bloc/invoices_state.dart';
import 'package:invi/models/Invoice.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc() : super(InvoiceInitialState([])) {
    on<LoadInvoicesEvent>((event, emit) async {
      emit(InvoiceLoadingState(state.invoices));
      try {
        await Future.delayed(Duration(seconds: 2));
        List<Invoice> invoices = [
          Invoice(
              id: '1',
              clientName: 'Client A',
              amount: 100.0,
              date: DateTime.now()),
          Invoice(
              id: '2',
              clientName: 'Client B',
              amount: 200.0,
              date: DateTime.now().subtract(Duration(days: 1))),
        ];
        emit(InvoiceLoadedState(invoices));
      } catch (e) {
        emit(InvoiceErrorState(e.toString(), state.invoices));
      }
    });
    on<CreateInvoiceEvent>((event, emit) {
      /// push to a new screen
      /// get a new invoice from there
      /// add invoice to current list
      /// emit state
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
