import 'package:blessing/core/constants/color.dart';
import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:blessing/core/global_components/custom_snackbar.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/data/subject/models/response/subject_response.dart';
import 'package:blessing/data/subject/repository/subject_repository_impl.dart';
import 'package:blessing/core/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminSubjectDetailScreen extends StatefulWidget {
  const AdminSubjectDetailScreen({super.key});

  @override
  State<AdminSubjectDetailScreen> createState() =>
      _AdminSubjectDetailScreenState();
}

class _AdminSubjectDetailScreenState extends State<AdminSubjectDetailScreen> {
  late final SubjectRepository _subjectRepository;
  late String subjectId;
  SubjectResponse? subject;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _subjectRepository = Get.find<SubjectRepository>();

    final arguments = Get.arguments as Map<String, dynamic>?;
    subjectId = arguments?['subjectId'] ?? '';

    _loadSubjectDetail();
  }

  Future<void> _loadSubjectDetail() async {
    if (subjectId.isEmpty) {
      CustomSnackbar.show(title: 'Error', message: 'ID mata pelajaran tidak valid', isError: true);
      Get.back();
      return;
    }

    setState(() => isLoading = true);
    try {
      // Fetch all subjects to find the one we need
      final allSubjects = await _subjectRepository.getAllSubjectsComplete();
      final found = allSubjects.firstWhereOrNull((s) => s.id == subjectId);

      setState(() {
        subject = found;
        isLoading = false;
      });

      if (found == null) {
        CustomSnackbar.show(title: 'Error', message: 'Mata pelajaran tidak ditemukan', isError: true);
        Get.back();
      }
    } catch (e) {
      CustomSnackbar.show(title: 'Error', message: 'Error: $e', isError: true);
      setState(() => isLoading = false);
      Get.back();
    }
  }

  Future<void> _deleteSubject() async {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Mata Pelajaran'),
        content: Text('Apakah Anda yakin ingin menghapus "${subject?.subjectName}"? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await _performDelete();
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _performDelete() async {
    setState(() => isLoading = true);
    try {
      final result = await _subjectRepository.deleteSubject(subjectId);
      if (result != null) {
        CustomSnackbar.show(title: 'Sukses', message: 'Mata pelajaran berhasil dihapus');
        Get.back(result: true);
      } else {
        CustomSnackbar.show(title: 'Error', message: 'Gagal menghapus mata pelajaran', isError: true);
      }
    } catch (e) {
      CustomSnackbar.show(title: 'Error', message: 'Error: $e', isError: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidgetContainer(
      appBar: AppBar(
        title: GlobalText.semiBold(
          'Detail Mata Pelajaran',
          fontSize: 18.sp,
          color: AppColors.c2,
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          if (!isLoading && subject != null)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.c2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, color: AppColors.c2),
                      const SizedBox(width: 8),
                      const Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Hapus', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  Get.toNamed(
                    AppRoutes.adminEditSubject,
                    arguments: {
                      'subjectId': subject!.id,
                      'subjectName': subject!.subjectName,
                      'onSubjectUpdated': () => _loadSubjectDetail(),
                    },
                  );
                } else if (value == 'delete') {
                  _deleteSubject();
                }
              },
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : subject == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64.sp,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 16.h),
                      GlobalText.medium(
                        'Mata pelajaran tidak ditemukan',
                        fontSize: 16.sp,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: AppColors.c2.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.c2.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.c2.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.all(12.w),
                              child: Icon(
                                Icons.book,
                                color: AppColors.c2,
                                size: 32.sp,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            GlobalText.semiBold(
                              subject!.subjectName ?? 'Tanpa Nama',
                              fontSize: 18.sp,
                              color: Colors.black87,
                            ),
                            SizedBox(height: 12.h),
                            GlobalText.regular(
                              'ID: ${subject!.id}',
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // Information Section
                      GlobalText.semiBold(
                        'Informasi',
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                      SizedBox(height: 16.h),

                      _buildInfoCard(
                        icon: Icons.calendar_today,
                        label: 'Dibuat',
                        value: subject!.createdAt != null
                            ? DateFormat('dd MMM yyyy HH:mm')
                                .format(subject!.createdAt!)
                            : 'Tidak diketahui',
                      ),

                      SizedBox(height: 12.h),

                      _buildInfoCard(
                        icon: Icons.update,
                        label: 'Terakhir Diperbarui',
                        value: subject!.updatedAt != null
                            ? DateFormat('dd MMM yyyy HH:mm')
                                .format(subject!.updatedAt!)
                            : 'Tidak diketahui',
                      ),

                      SizedBox(height: 32.h),

                      // Action Buttons
                      SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.c2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: () => Get.toNamed(
                            AppRoutes.adminEditSubject,
                            arguments: {
                              'subjectId': subject!.id,
                              'subjectName': subject!.subjectName,
                              'onSubjectUpdated': () => _loadSubjectDetail(),
                            },
                          ),
                          icon: Icon(Icons.edit, size: 20.sp),
                          label: GlobalText.semiBold(
                            'EDIT MATA PELAJARAN',
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: _deleteSubject,
                          icon: Icon(Icons.delete_outline,
                              color: Colors.red, size: 20.sp),
                          label: GlobalText.semiBold(
                            'HAPUS MATA PELAJARAN',
                            fontSize: 14.sp,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.c2.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.all(8.w),
            child: Icon(icon, color: AppColors.c2, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlobalText.medium(
                  label,
                  fontSize: 12.sp,
                  color: Colors.grey.shade600,
                ),
                SizedBox(height: 4.h),
                GlobalText.semiBold(
                  value,
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
