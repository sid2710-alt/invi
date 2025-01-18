import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invi/blocs/invoices_bloc/InvoiceBloc.dart';
import 'package:invi/blocs/invoices_bloc/invoice_event.dart';
import 'package:invi/models/invoice.dart';
import 'package:invi/models/Item.dart';

class UpsertInvoiceScreen extends StatefulWidget {
  final Invoice? existingInvoice;

  const UpsertInvoiceScreen({super.key, this.existingInvoice});

  @override
  UpsertInvoiceScreenState createState() => UpsertInvoiceScreenState();
}

class UpsertInvoiceScreenState extends State<UpsertInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _clientNameController;
  late TextEditingController _dateController;
  late List<InvoiceItem> _items;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.existingInvoice != null) {
      _clientNameController = TextEditingController(text: widget.existingInvoice!.clientName);
      _dateController = TextEditingController(text: widget.existingInvoice!.date.toString().split(" ")[0]);
      _items = List.from(widget.existingInvoice!.items);
      _selectedDate = widget.existingInvoice!.date;
    } else {
      _clientNameController = TextEditingController();
      _dateController = TextEditingController();
      _items = [];
      _selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = pickedDate.toString().split(" ")[0];
      });
    }
  }

  void _showItemSheet({InvoiceItem? item, int? index}) {
    final TextEditingController itemNameController = TextEditingController(text: item?.name ?? '');
    final TextEditingController quantityController = TextEditingController(text: item?.quantity.toString() ?? '');
    final TextEditingController unitPriceController = TextEditingController(text: item?.unitPrice.toString() ?? '');
    final TextEditingController itemDescriptionController = TextEditingController(text: item?.description ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16.0, right: 16.0, top: 16.0),
          child: Wrap(
            children: [
              TextFormField(controller: itemNameController, decoration: InputDecoration(labelText: 'Item Name')),
              TextFormField(controller: quantityController, decoration: InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
              TextFormField(controller: unitPriceController, decoration: InputDecoration(labelText: 'Unit Price'), keyboardType: TextInputType.number),
              TextFormField(controller: itemDescriptionController, decoration: InputDecoration(labelText: 'Item Description'), maxLines: 3),
              ElevatedButton(
                onPressed: () {
                  final String name = itemNameController.text;
                  final int quantity = int.parse(quantityController.text);
                  final double unitPrice = double.parse(unitPriceController.text);
                  final String description = itemDescriptionController.text;

                  setState(() {
                    if (item != null && index != null) {
                      _items[index] = InvoiceItem(name: name, quantity: quantity, unitPrice: unitPrice, description: description);
                    } else {
                      _items.add(InvoiceItem(name: name, quantity: quantity, unitPrice: unitPrice, description: description));
                    }
                  });

                  Navigator.pop(context);
                },
                child: Text(item != null ? 'Update Item' : 'Add Item'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _upsertInvoice() {
    if (_formKey.currentState!.validate() && _items.isNotEmpty) {
      final String clientName = _clientNameController.text;
      final DateTime date = _selectedDate ?? DateTime.now();

      final updatedInvoice = Invoice(
        id: widget.existingInvoice?.id ?? DateTime.now().millisecondsSinceEpoch,
        clientName: clientName,
        date: date,
        items: _items,
      );

      if (widget.existingInvoice != null) {
        context.read<InvoiceBloc>().add(UpdateInvoiceEvent(updatedInvoice));
      } else {
        context.read<InvoiceBloc>().add(CreateInvoiceEvent(updatedInvoice));
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.existingInvoice != null ? 'Edit Invoice' : 'Add Invoice')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _clientNameController,
                decoration: InputDecoration(labelText: 'Client Name'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter client name' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                readOnly: true,
                onTap: _pickDate,
              ),
              Divider(),
              Text('Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text('Quantity: ${item.quantity}, Unit Price: ${item.unitPrice.toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Total: ${item.totalPrice.toStringAsFixed(2)}'),
                          IconButton(icon: Icon(Icons.edit), onPressed: () => _showItemSheet(item: item, index: index), tooltip: 'Edit Item'),
                        ],
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () => _showItemSheet(),
                child: Text('Add Item'),
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _upsertInvoice,
                child: Text(widget.existingInvoice != null ? 'Update Invoice' : 'Save Invoice'),
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
