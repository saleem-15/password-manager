// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PasswordAdapter extends TypeAdapter<Password> {
  @override
  final int typeId = 1;

  @override
  Password read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Password(
      websiteName: fields[0] as String,
      docId: fields[6] as String,
      icon: fields[1] as String,
      email: fields[2] as String,
      url: fields[5] as String,
      password: fields[3] as String,
      lastUpdated: fields[4] as String,
      category: fields[7] as String,
      id: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Password obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.websiteName)
      ..writeByte(1)
      ..write(obj.icon)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.lastUpdated)
      ..writeByte(5)
      ..write(obj.url)
      ..writeByte(6)
      ..write(obj.docId)
      ..writeByte(7)
      ..write(obj.category)
      ..writeByte(8)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasswordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
