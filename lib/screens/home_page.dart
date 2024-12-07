import 'package:flutter/material.dart';
import '../services/currency_service.dart';
import '../widgets/amount_input.dart';
import '../widgets/currency_dropdown.dart';
import '../utils/constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _amountController = TextEditingController();

  String _fromCurrency = 'EUR';
  String _toCurrency = 'USD';
  String? _convertedValue;
  bool _isLoading = false;

  Future<void> _convertCurrency() async {
    final amount = _amountController.text;
    if (amount.isEmpty) {
      _showDialog('Error', 'Por favor, ingresa un monto válido.');
      return;
    }

    if (_fromCurrency == _toCurrency) {
      _showDialog(
          'Error', 'La moneda de origen y destino no pueden ser iguales.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final convertedValue = await CurrencyService.convertCurrency(
        amount, _fromCurrency, _toCurrency);

    setState(() {
      _isLoading = false;
      _convertedValue = convertedValue;
    });

    if (convertedValue != null) {
      _showDialog('Resultado',
          '$amount $_fromCurrency = $_convertedValue $_toCurrency');
    } else {
      _showDialog('Error', 'Error al convertir la moneda.');
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversor de Moneda'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Cantidad',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    AmountInput(controller: _amountController),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Moneda de Origen',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    CurrencyDropdown(
                      selectedValue: _fromCurrency,
                      items: currencies,
                      onChanged: (newValue) {
                        setState(() {
                          _fromCurrency = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Moneda de Destino',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    CurrencyDropdown(
                      selectedValue: _toCurrency,
                      items: currencies,
                      onChanged: (newValue) {
                        setState(() {
                          _toCurrency = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _convertCurrency,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Convertir'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
