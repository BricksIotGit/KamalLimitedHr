import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../styling/images.dart';
import '../../styling/size_config.dart';
import 'Home.dart';

class DateDifference extends StatefulWidget {
  @override
  _DateDifferenceState createState() => _DateDifferenceState();
}

class _DateDifferenceState extends State<DateDifference> {
   DateTime? _firstDate;
   DateTime? _secondDate;
  int _differenceInDays = 0;

  Future<void> _pickFirstDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _firstDate) {
      setState(() {
        _firstDate = pickedDate;
        _differenceInDays = _calculateDifference()!;
      });
    }
  }

  Future<void> _pickSecondDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _secondDate) {
      setState(() {
        _secondDate = pickedDate;
        _differenceInDays = _calculateDifference()!;
      });
    }
  }

  int? _calculateDifference() {
    if (_firstDate != null && _secondDate != null) {
      return _secondDate?.difference(_firstDate!).inDays;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date Difference'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  // Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Home()));
                },
                child: Image(
                  width: 10 * SizeConfig.widthMultiplier,
                  image: AssetImage(Images.back_arrow_ic),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton (
                  onPressed: _pickFirstDate,
                  child: Text(
                    _firstDate == null
                        ? 'Select first date'
                        : DateFormat('dd-MMM-yyyy').format(_firstDate!),
                  ),
                ),
                TextButton (
                  onPressed: _pickSecondDate,
                  child: Text(
                    _secondDate == null
                        ? 'Select second date'
                        : DateFormat('dd-MMM-yyyy').format(_secondDate!),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              _differenceInDays == 0
                  ? 'Please select two dates'
                  : 'Difference: $_differenceInDays days',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
