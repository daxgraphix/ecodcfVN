import 'package:hive/hive.dart';

class JournalEntry extends HiveObject {
  String id;
  DateTime date;
  String action;
  String note;

  JournalEntry({
    required this.id,
    required this.date,
    required this.action,
    required this.note,
  });
}

class JournalEntryAdapter extends TypeAdapter<JournalEntry> {
  @override
  final int typeId = 2;

  @override
  JournalEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JournalEntry(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      action: fields[2] as String,
      note: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, JournalEntry obj) {
    writer.writeByte(4);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.date);
    writer.writeByte(2);
    writer.write(obj.action);
    writer.writeByte(3);
    writer.write(obj.note);
  }
}
