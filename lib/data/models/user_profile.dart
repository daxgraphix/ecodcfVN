import 'package:hive/hive.dart';

class UserProfile extends HiveObject {
  int householdSize;
  String vehicleType; // None, Car, Motorbike, Public Transport
  String electricitySource; // Grid, Solar, Mixed
  String dietType; // Vegan, Vegetarian, Mixed, Meat Heavy
  String recyclingFrequency; // Never, Sometimes, Often, Always
  bool onboarded;
  int ecoStreak;
  String? lastActiveDate; // yyyy-MM-dd
  int xp;

  UserProfile({
    this.householdSize = 1,
    this.vehicleType = 'None',
    this.electricitySource = 'Grid',
    this.dietType = 'Mixed',
    this.recyclingFrequency = 'Sometimes',
    this.onboarded = false,
    this.ecoStreak = 0,
    this.lastActiveDate,
    this.xp = 0,
  });
}

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      householdSize: fields[0] as int? ?? 1,
      vehicleType: fields[1] as String? ?? 'None',
      electricitySource: fields[2] as String? ?? 'Grid',
      dietType: fields[3] as String? ?? 'Mixed',
      recyclingFrequency: fields[4] as String? ?? 'Sometimes',
      onboarded: fields[5] as bool? ?? false,
      ecoStreak: fields[6] as int? ?? 0,
      lastActiveDate: fields[7] as String?,
      xp: fields[8] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer.writeByte(9);
    writer.writeByte(0);
    writer.write(obj.householdSize);
    writer.writeByte(1);
    writer.write(obj.vehicleType);
    writer.writeByte(2);
    writer.write(obj.electricitySource);
    writer.writeByte(3);
    writer.write(obj.dietType);
    writer.writeByte(4);
    writer.write(obj.recyclingFrequency);
    writer.writeByte(5);
    writer.write(obj.onboarded);
    writer.writeByte(6);
    writer.write(obj.ecoStreak);
    writer.writeByte(7);
    writer.write(obj.lastActiveDate);
    writer.writeByte(8);
    writer.write(obj.xp);
  }
}
