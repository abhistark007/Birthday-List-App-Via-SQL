
class Birthday {
  int _id;
  String _name;
  String _date;
  Birthday(this._name,this._date);
  int get id => _id;
  String get name => _name;
  String get date => _date;
  set name(String name){
    this._name=name;
  }
  set date(String date){
    this._date=date;
  }
  Map<String,dynamic> toMap(){
    var map=Map<String,dynamic>();
    if(id!=null){
      map['id']=_id;
    }
    map['name']=_name;
    map['date']=_date;
    return map;
  }
  Birthday.fromMapToObject(Map<String,dynamic> map){
    _id=map['id'];
    _name=map['name'];
    _date=map['date'];
  }
}