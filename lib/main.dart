

import 'package:flutter/material.dart';

void main() {
  runApp(TipCalculatorApp());
}

class TipCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tip Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: TipCalculatorScreen(),
    );
  }
}

class TipCalculatorScreen extends StatefulWidget {
  @override
  _TipCalculatorScreenState createState() => _TipCalculatorScreenState();
}

class _TipCalculatorScreenState extends State<TipCalculatorScreen> {
  double _billAmount = 0.0;
  double _tipPercentage = 15.0;
  double _tipAmount = 0.0;
  double _totalAmount = 0.0;
  int _splitBy = 1;
  bool _roundTotal = false;

  final List<String> _serviceRatings = ['Poor', 'Good', 'Excellent'];
  String _selectedRating = 'Good';

  void _calculateTipAndTotal() {
    setState(() {
      _tipAmount = (_billAmount * _tipPercentage) / 100;
      _totalAmount = _billAmount + _tipAmount;

      if (_roundTotal) {
        _totalAmount = _totalAmount.ceilToDouble();
      }
    });
  }

  void _updateTipBasedOnRating(String rating) {
    setState(() {
      if (rating == 'Poor') {
        _tipPercentage = 10;
      } else if (rating == 'Good') {
        _tipPercentage = 15;
      } else if (rating == 'Excellent') {
        _tipPercentage = 20;
      }
      _calculateTipAndTotal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Tip Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Bill Amount (\$)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _billAmount = double.tryParse(value) ?? 0.0;
                  _calculateTipAndTotal();
                });
              },
            ),
            SizedBox(height: 20),

            // Service Rating Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Service Rating:'),
                DropdownButton<String>(
                  value: _selectedRating,
                  items: _serviceRatings.map((String rating) {
                    return DropdownMenuItem<String>(
                      value: rating,
                      child: Text(rating),
                    );
                  }).toList(),
                  onChanged: (String? newRating) {
                    if (newRating != null) {
                      _selectedRating = newRating;
                      _updateTipBasedOnRating(newRating);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            // Tip percentage and tip amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tip Percentage: ${_tipPercentage.toInt()}%'),
                Text('${_tipAmount.toStringAsFixed(2)} \$'),
              ],
            ),
            Slider(
              value: _tipPercentage,
              min: 0,
              max: 30,
              divisions: 30,
              label: '${_tipPercentage.toInt()}%',
              onChanged: (newValue) {
                setState(() {
                  _tipPercentage = newValue;
                  _calculateTipAndTotal();
                });
              },
            ),
            SizedBox(height: 20),

            // Split Bill Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Split By:'),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (_splitBy > 1) {
                            _splitBy--;
                          }
                        });
                      },
                    ),
                    Text('$_splitBy'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _splitBy++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),

            // Rounding Option
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Round Total:'),
                Switch(
                  value: _roundTotal,
                  onChanged: (value) {
                    setState(() {
                      _roundTotal = value;
                      _calculateTipAndTotal();
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            // Display Total Amount and Amount Per Person
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Amount:'),
                Text('\$${_totalAmount.toStringAsFixed(2)}'),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Amount Per Person:'),
                Text('\$${(_totalAmount / _splitBy).toStringAsFixed(2)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
