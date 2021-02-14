import 'package:hive/hive.dart';

@HiveType(typeId : 1)
class SimpleObject{
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  List<SimpleObject> children = List();

  SimpleObject({this.id, this.name, this.children});
}


@HiveType(typeId : 2)
enum ObjectStorageType{
@HiveField(0)
BEGIN,
@HiveField(1)
END,
}
