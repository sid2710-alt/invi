import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invi/blocs/invoices_bloc/InvoiceBloc.dart';
import 'package:invi/blocs/invoices_bloc/invoice_event.dart';
import 'package:invi/models/invoice.dart';
import 'package:invi/models/Item.dart';

class AddInvoiceScreen extends StatefulWidget {
  const AddInvoiceScreen({super.key});

  @override
  AddInvoiceScreenState createState() => AddInvoiceScreenState();
}

class AddInvoiceScreenState extends State<AddInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _itemDescriptionController = TextEditingController();
  DateTime? _selectedDate;

  final List<InvoiceItem> _items = [];

  @override
  void dispose() {
    _clientNameController.dispose();
    _amountController.dispose();
    _itemNameController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _dateController.dispose();
    _itemDescriptionController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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

  void _addItem() {
    if (_itemNameController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty &&
        _unitPriceController.text.isNotEmpty) {
      final String itemName = _itemNameController.text;
      final int quantity = int.parse(_quantityController.text);
      final double unitPrice = double.parse(_unitPriceController.text);
      final String itemDescription = _itemDescriptionController.text;

      setState(() {
        _items.add(InvoiceItem(name: itemName, quantity: quantity, unitPrice: unitPrice, description: itemDescription));
      });

      // Clear item input fields
      _itemNameController.clear();
      _quantityController.clear();
      _unitPriceController.clear();
      _itemDescriptionController.clear();
    }
  }

  void _addInvoice() {
    if (_formKey.currentState!.validate() && _items.isNotEmpty) {
      final String clientName = _clientNameController.text;
      final DateTime date = _selectedDate ?? DateTime.now();

      final newInvoice = Invoice(
        id: DateTime.now().millisecondsSinceEpoch,
        clientName: clientName,
        date: date,
        items: _items,
      );
      context.read<InvoiceBloc>().add(CreateInvoiceEvent(newInvoice));
      Navigator.pop(context); // Return to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Invoice'),
      ),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter client name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
            
                TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                readOnly: true,
                canRequestFocus: false,
                onTap: _pickDate,),
              
              // IconButton(
              //       onPressed: _pickDate,
              //       icon: Icon(Icons.edit_calendar),
              //     ) 
              //],),
              
              Divider(),
              Text(
                'Add Items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _itemNameController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _unitPriceController,
                decoration: InputDecoration(labelText: 'Unit Price'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _itemDescriptionController,
                decoration: InputDecoration(labelText: 'Item Description'),
                keyboardType: TextInputType.text,
                maxLines: 3,
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _addItem,
                child: Text('Add Item'),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text('Quantity: ${item.quantity}, Unit Price: ${item.unitPrice.toStringAsFixed(2)}'),
                      trailing: Text('Total: ${item.totalPrice.toStringAsFixed(2)}'),
                    );
                  },
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: _addInvoice,
                child: Text('Add Invoice'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
