import 'package:hive/hive.dart';

class GoalItem extends HiveObject {
  String id;
  String title;
  String category; // Travel, Food, Energy, Waste, Overall
  int targetPercent; // 10, 20, 30
  double progress; // 0..1
  bool achieved;
  DateTime createdAt;

  GoalItem({
    required this.id,
    required this.title,
    required this.category,
    required this.targetPercent,
    this.progress = 0,
    this.achieved = false,
    required this.createdAt,
  });
}

class GoalItemAdapter extends TypeAdapter<GoalItem> {
  @override
  final int typeId = 3;

  @override
  GoalItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoalItem(
      id: fields[0] as String,
      title: fields[1] as String,
      category: fields[2] as String,
      targetPercent: fields[3] as int,
      progress: fields[4] as double,
      achieved: fields[5] as bool,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GoalItem obj) {
    writer.writeByte(7);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.title);
    writer.writeByte(2);
    writer.write(obj.category);
    writer.writeByte(3);
    writer.write(obj.targetPercent);
    writer.writeByte(4);
    writer.write(obj.progress);
    writer.writeByte(5);
    writer.write(obj.achieved);
    writer.writeByte(6);
    writer.write(obj.createdAt);
  }
}
