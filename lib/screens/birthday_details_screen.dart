import 'package:birthday_app_sql/models/birthday.dart';
import 'package:birthday_app_sql/utility/database_helper.dart';
import 'package:flutter/material.dart';

class BirthdayDetail extends StatefulWidget {
  final Birthday bday;
  final String appBarTitle;
  BirthdayDetail(this.bday, this.appBarTitle);
  @override
  _BirthdayDetailState createState() => _BirthdayDetailState();
}

class _BirthdayDetailState extends State<BirthdayDetail> {
  DatabaseHelper helper = DatabaseHelper();
  TextEditingController nameController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    nameController.text = widget.bday.name;
    if (widget.bday.date == '') {
      yearController.text = widget.bday.date; // 2000-02-04
      monthController.text = widget.bday.date;
      dayController.text = widget.bday.date;
    } else {
      yearController.text = widget.bday.date.substring(0, 4); // 2000-02-04
      monthController.text = widget.bday.date.substring(5, 7);
      dayController.text = widget.bday.date.substring(8);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                onChanged: (value) {
                  widget.bday.name = nameController.text;
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: yearController,
                      decoration: InputDecoration(
                        labelText: 'Year',
                        hintText: 'YYYY',
                      ),
                      onChanged: (value) {
                        //widget.bday.date = yearController.text;
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Text('/'),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: monthController,
                      decoration: InputDecoration(
                        labelText: 'Month',
                        hintText: 'MM',
                      ),
                      onChanged: (value) {
                        //widget.bday.date = monthController.text;
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Text('/'),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: dayController,
                      decoration: InputDecoration(
                        labelText: 'Day',
                        hintText: 'DD',
                      ),
                      onChanged: (value) {
                        //widget.bday.date = dayController.text;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text("Save"),
                  onPressed: () {
                    _save();
                  },
                ),
                RaisedButton(
                  child: Text("Delete"),
                  onPressed: () {
                    _delete();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //--------------------------------------------------------------------------------------------------------------------------
  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _save() async {
    widget.bday.date = yearController.text +
        '-' +
        monthController.text +
        '-' +
        dayController.text;
    Navigator.pop(context, true);
    int result;
    if (widget.bday.id != null) {
      result = await helper.updateBirthday(widget.bday);
    } else {
      result = await helper.insertBirthday(widget.bday);
    }
    if (result != 0) {
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async {
    Navigator.pop(context, true);
    if (widget.bday.id == null) {
      _showAlertDialog('Status', 'No Note Was Deleted');
      return;
    }
    int result = await helper.deleteBirthday(widget.bday.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured While Saving');
    }
  }
}
