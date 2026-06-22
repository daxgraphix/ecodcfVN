import 'package:hive/hive.dart';

/// category: travel, food, energy, waste
class ActivityEntry extends HiveObject {
  String id;
  String category;
  String subtype; // e.g. Car, Vegan, Electricity, Plastic
  double value; // distance km, kg, kWh, kg waste etc
  double emissions; // computed kg CO2e
  DateTime date;

  ActivityEntry({
    required this.id,
    required this.category,
    required this.subtype,
    required this.value,
    required this.emissions,
    required this.date,
  });
}

class ActivityEntryAdapter extends TypeAdapter<ActivityEntry> {
  @override
  final int typeId = 1;

  @override
  ActivityEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityEntry(
      id: fields[0] as String,
      category: fields[1] as String,
      subtype: fields[2] as String,
      value: fields[3] as double,
      emissions: fields[4] as double,
      date: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityEntry obj) {
    writer.writeByte(6);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.category);
    writer.writeByte(2);
    writer.write(obj.subtype);
    writer.writeByte(3);
    writer.write(obj.value);
    writer.writeByte(4);
    writer.write(obj.emissions);
    writer.writeByte(5);
    writer.write(obj.date);
  }
}
