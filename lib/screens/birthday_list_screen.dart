
import 'package:birthday_app_sql/screens/birthday_details_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:birthday_app_sql/models/birthday.dart';
import 'package:birthday_app_sql/utility/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:age/age.dart';

class BirthdayList extends StatefulWidget {
  @override
  _BirthdayListState createState() => _BirthdayListState();
}

class _BirthdayListState extends State<BirthdayList> {
  DatabaseHelper databaseHelper=DatabaseHelper();
  List<Birthday> bdayList;
  int count=0;
  @override
  Widget build(BuildContext context) {
    if(bdayList==null){
      bdayList=List<Birthday>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(title: Text("Birthday List via SQL"),),
      body: ListView.builder(itemCount:count,
      itemBuilder:(BuildContext context,int position){
        var y=int.parse(bdayList[position].date.substring(0,4));
        var m=int.parse(bdayList[position].date.substring(5,7));
        var d=int.parse(bdayList[position].date.substring(8));  //2000-02-04
        DateTime birthday = DateTime(y, m, d);
        DateTime today = DateTime.now();
        AgeDuration age = Age.dateDifference(fromDate: birthday, toDate: today, includeToDate: false);
        return Card(
          child: ListTile(title: Text(this.bdayList[position].name),
          subtitle: Text('Age: '+ age.toString()),
          trailing: GestureDetector(
            child:Icon(Icons.delete,color: Colors.grey,),
            onTap: (){
              _delete(context,bdayList[position]);
            },
          ),
          onTap: (){
            navigateToDetail(this.bdayList[position], 'Edit Birthday');
          },
          ),
        );
      }
      ),
      floatingActionButton: FloatingActionButton(
       onPressed: (){
         navigateToDetail(Birthday('',''),'Add Birthday');
       },
       child: Icon(Icons.add),
      ),
    );
  }
  //-------------------------------------------------------------------------------------------------------------
  void updateListView() {
    final Future<Database> dbFuture=databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Birthday>> bdayListFuture=databaseHelper.getBdayList();
      bdayListFuture.then((bdayList){
        setState(() {
          this.bdayList=bdayList;
          this.count=bdayList.length;
        });
      } );
    } );
  }
  void navigateToDetail(Birthday bday,String title) async{
    bool result=await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BirthdayDetail(bday, title);
    }));
    if(result==true){
      updateListView();
    }
  }
  void _delete(BuildContext context,Birthday bday) async{
    int result=await databaseHelper.deleteBirthday(bday.id);
    if(result!=0){
      _showSnackBar(context,'Note Deleted Successfully');
      updateListView();
    }
  }
  void _showSnackBar(BuildContext context,String message){
    final snackBar=SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}