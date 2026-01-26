import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/modules/student/main/widgets/new_activity_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewActivity extends StatelessWidget {
  const NewActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalText.bold(
          "Update Pembelajaran",
          fontSize: 16.sp,
          color: Colors.black,
        ),
        SizedBox(
          height: 120.h,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                NotificationCard(
                  title: "Materi",
                  subtitle: "1 min",
                  contentTitle: "Fisika",
                  icon: Icons.menu_book,
                  isRead: false,
                ),
                SizedBox(width: 12.w),
                NotificationCard(
                  title: "Kuis",
                  subtitle: "5 min",
                  contentTitle: "Matematika",
                  icon: Icons.emoji_events,
                  isRead: true,
                ),
                SizedBox(width: 12.w),
                NotificationCard(
                  title: "Info",
                  subtitle: "4 min",
                  contentTitle: "Jadwal Ujian",
                  icon: Icons.campaign,
                  isRead: false,
                ),
                SizedBox(width: 12.w),
                NotificationCard(
                  title: "Materi",
                  subtitle: "3 min",
                  contentTitle: "Kimia",
                  icon: Icons.menu_book,
                  isRead: true,
                ),
                SizedBox(width: 16.w),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
