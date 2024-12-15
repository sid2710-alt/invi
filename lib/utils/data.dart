Map<String, dynamic> clients = {
  "1": {"id": "1", "name": "John Doe", "email": "john@example.com", "phone": "1234567890"},
  "2": {"id": "2", "name": "Jane Smith", "email": "jane@example.com", "phone": "0987654321"},
};

Map<String, dynamic> invoices = {
  "101": {
    "id": "101",
    "clientId": "1",
    "items": [
      {"description": "Web Development", "quantity": 1, "price": 5000},
      {"description": "Hosting", "quantity": 1, "price": 200}
    ],
    "total": 5200,
    "date": "2024-12-15",
    "status": "unpaid"
  }
};
Map<String, dynamic> templates = {
  "basic": {
    "id": "basic",
    "name": "Basic Template",
    "fields": ["name", "email", "items", "total"]
  },
};
