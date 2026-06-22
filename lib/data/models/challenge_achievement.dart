import 'package:hive/hive.dart';

class ChallengeItem extends HiveObject {
  String id;
  String title;
  String description;
  int rewardXp;
  bool joined;
  bool completed;

  ChallengeItem({
    required this.id,
    required this.title,
    required this.description,
    required this.rewardXp,
    this.joined = false,
    this.completed = false,
  });
}

class ChallengeItemAdapter extends TypeAdapter<ChallengeItem> {
  @override
  final int typeId = 4;

  @override
  ChallengeItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChallengeItem(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      rewardXp: fields[3] as int,
      joined: fields[4] as bool,
      completed: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ChallengeItem obj) {
    writer.writeByte(6);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.title);
    writer.writeByte(2);
    writer.write(obj.description);
    writer.writeByte(3);
    writer.write(obj.rewardXp);
    writer.writeByte(4);
    writer.write(obj.joined);
    writer.writeByte(5);
    writer.write(obj.completed);
  }
}

class AchievementItem extends HiveObject {
  String id;
  String title;
  String icon;
  String description;
  bool unlocked;

  AchievementItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.description,
    this.unlocked = false,
  });
}

class AchievementItemAdapter extends TypeAdapter<AchievementItem> {
  @override
  final int typeId = 5;

  @override
  AchievementItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AchievementItem(
      id: fields[0] as String,
      title: fields[1] as String,
      icon: fields[2] as String,
      description: fields[3] as String,
      unlocked: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AchievementItem obj) {
    writer.writeByte(5);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.title);
    writer.writeByte(2);
    writer.write(obj.icon);
    writer.writeByte(3);
    writer.write(obj.description);
    writer.writeByte(4);
    writer.write(obj.unlocked);
  }
}
