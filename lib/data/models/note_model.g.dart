// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteModelAdapter extends TypeAdapter<NoteModel> {
  @override
  final int typeId = 0;

  @override
  NoteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteModel(
      id: fields[0] as String?,
      title: fields[1] as String,
      description: fields[2] as String,
      filePath: fields[3] as String,
      fileName: fields[4] as String,
      fileType: fields[5] as String,
      degree: fields[6] as String,
      department: fields[7] as String,
      semester: fields[8] as String,
      subject: fields[9] as String,
      uploadDate: fields[10] as DateTime,
      uploadedBy: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NoteModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.filePath)
      ..writeByte(4)
      ..write(obj.fileName)
      ..writeByte(5)
      ..write(obj.fileType)
      ..writeByte(6)
      ..write(obj.degree)
      ..writeByte(7)
      ..write(obj.department)
      ..writeByte(8)
      ..write(obj.semester)
      ..writeByte(9)
      ..write(obj.subject)
      ..writeByte(10)
      ..write(obj.uploadDate)
      ..writeByte(11)
      ..write(obj.uploadedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
