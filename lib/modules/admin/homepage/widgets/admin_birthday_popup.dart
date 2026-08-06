import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/data/user/models/response/user_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminBirthdayPopup extends StatelessWidget {
  final List<UserResponse> birthdayStudents;

  const AdminBirthdayPopup({
    super.key,
    required this.birthdayStudents,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header dengan gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF6B9D), Color(0xFFFF8E53)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                const Text(
                  '🎂',
                  style: TextStyle(fontSize: 40),
                ),
                const SizedBox(height: 8),
                GlobalText.bold(
                  'Ulang Tahun Hari Ini!',
                  fontSize: 18,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                GlobalText.regular(
                  birthdayStudents.length == 1
                      ? '${birthdayStudents.length} siswa berulang tahun hari ini'
                      : '${birthdayStudents.length} siswa berulang tahun hari ini',
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ],
            ),
          ),

          // List siswa
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: birthdayStudents.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                indent: 60,
                endIndent: 20,
              ),
              itemBuilder: (context, index) {
                final student = birthdayStudents[index];
                final name = student.username ?? 'Siswa';
                final initial = name.isNotEmpty ? name[0].toUpperCase() : 'S';
                final gradeLevel = student.gradeLevel;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getAvatarColor(index),
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  title: GlobalText.semiBold(
                    name,
                    fontSize: 14,
                    textAlign: TextAlign.start,
                  ),
                  subtitle: gradeLevel != null
                      ? GlobalText.regular(
                          'Kelas $gradeLevel',
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          textAlign: TextAlign.start,
                        )
                      : null,
                  trailing: const Text(
                    '🎉',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              },
            ),
          ),

          // Tombol tutup
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B9D),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: GlobalText.semiBold(
                  'Tutup',
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getAvatarColor(int index) {
    final colors = [
      const Color(0xFFFF6B9D),
      const Color(0xFFFF8E53),
      const Color(0xFF4ECDC4),
      const Color(0xFF45B7D1),
      const Color(0xFF96CEB4),
      const Color(0xFFDDA0DD),
    ];
    return colors[index % colors.length];
  }
}
