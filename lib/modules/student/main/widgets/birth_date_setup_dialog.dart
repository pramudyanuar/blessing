import 'package:blessing/core/global_components/global_button.dart';
import 'package:blessing/core/global_components/global_text.dart';
import 'package:blessing/data/user/models/request/update_user_request.dart';
import 'package:blessing/data/user/repository/user_repository_impl.dart';
import 'package:blessing/core/utils/cache_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BirthDateSetupDialog extends StatefulWidget {
  const BirthDateSetupDialog({super.key});

  @override
  State<BirthDateSetupDialog> createState() => _BirthDateSetupDialogState();
}

class _BirthDateSetupDialogState extends State<BirthDateSetupDialog> {
  final TextEditingController birthDateController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    birthDateController.dispose();
    super.dispose();
  }

  Future<void> selectBirthDate() async {
    DateTime initialDate = DateTime.now();
    
    if (birthDateController.text.isNotEmpty) {
      try {
        final formatter = DateFormat('dd-MM-yyyy');
        initialDate = formatter.parseStrict(birthDateController.text);
      } catch (e) {
        // Gunakan current date jika parse gagal
      }
    }

    if (initialDate.isAfter(DateTime.now())) {
      initialDate = DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      setState(() {
        birthDateController.text = formattedDate;
      });
    }
  }

  Future<void> saveBirthDate() async {
    if (birthDateController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Tanggal lahir harus diisi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final userRepository = Get.find<UserRepository>();
      final formatter = DateFormat('dd-MM-yyyy');
      final parsedDate = formatter.parseStrict(birthDateController.text);
      final birthDateForApi = parsedDate.toUtc().toIso8601String();

      final updatedUser = await userRepository.updateUser(
        UpdateUserRequest(birthDate: birthDateForApi),
      );

      if (updatedUser != null) {
        final currentData = await CacheUtil().getData('user_data') ?? {};
        currentData['birth_date'] = updatedUser.birthDate;
        await CacheUtil().setData('user_data', currentData);

        if (mounted) {
          Get.back();
        }
      } else {
        Get.snackbar(
          'Error',
          'Gagal menyimpan tanggal lahir',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlobalText.bold(
              'Lengkapi Data Diri',
              fontSize: 16.sp,
            ),
            SizedBox(height: 8.h),
            GlobalText.medium(
              'Silakan isi tanggal lahir Anda untuk melanjutkan',
              fontSize: 12.sp,
              color: Colors.grey,
            ),
            SizedBox(height: 24.h),
            GlobalText.medium('Tanggal Lahir', fontSize: 14),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: selectBirthDate,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: Color(0xFF0D47A1),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        birthDateController.text.isEmpty
                            ? 'Pilih tanggal lahir'
                            : birthDateController.text,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: birthDateController.text.isEmpty
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: GlobalButton(
                text: 'Simpan',
                onPressed: isLoading ? null : saveBirthDate,
                isLoading: isLoading,
                color: const Color(0xFF0D47A1),
                height: 40.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
