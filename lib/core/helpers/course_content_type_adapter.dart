import 'package:blessing/modules/admin/course/widgets/course_card.dart';
import 'package:hive/hive.dart';

class CourseContentTypeAdapter extends TypeAdapter<CourseContentType> {
  @override
  final typeId = 1;

  @override
  CourseContentType read(BinaryReader reader) {
    return CourseContentType.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, CourseContentType obj) {
    writer.writeInt(obj.index);
  }
}
