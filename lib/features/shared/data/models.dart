import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
abstract class StudentProfile with _$StudentProfile {
  const factory StudentProfile({
    required String nim,
    @Default('') String name,
    @Default('') String className,
    @Default('') String major,
    @Default('') String companyName,
    @Default('') String division,
    @Default('') String mentorName,
    @Default(16) int internshipDurationWeeks,
    @Default('') String whatsappNumber,
    @Default('') String lastDeviceId,
    int? lastLogoutAllTimestamp,
    @Default(false) bool logoutAllForce,
    @Default(0) int updatedAt,
  }) = _StudentProfile;

  factory StudentProfile.fromJson(Map<String, dynamic> json) =>
      _$StudentProfileFromJson(json);
}

@freezed
abstract class InternshipLog with _$InternshipLog {
  const factory InternshipLog({
    required String id,
    required String date,
    required String activity,
    required String startTime,
    required String endTime,
    @Default(false) bool isSigned,
    required int weekNumber,
    @Default('') String signatureData,
    @Default('') String versionHistory,
    @Default([]) List<String> imageUrls,
    @Default(0) int updatedAt,
    @Default(false) bool isDeleted,
    @Default(false) bool isDraft,
  }) = _InternshipLog;

  factory InternshipLog.fromJson(Map<String, dynamic> json) =>
      _$InternshipLogFromJson(json);
}

@freezed
abstract class InternshipGrading with _$InternshipGrading {
  const factory InternshipGrading({
    required String nim,
    // Form-3.30 (Nilai Perusahaan / Mentor) - 10 kriteria
    @Default(0.0) double companyKerapian,
    @Default(0.0) double companyDisiplin,
    @Default(0.0) double companyKehadiran,
    @Default(0.0) double companyTanggungJawab,
    @Default(0.0) double companyKemandirian,
    @Default(0.0) double companyInisiatif,
    @Default(0.0) double companyPemahaman,
    @Default(0.0) double companyKerjasamaRekan,
    @Default(0.0) double companyKerjasamaAtasan,
    @Default(0.0) double companyAdaptasi,
    @Default('') String companySaranKritik,
    
    // Form-3.31 (Nilai Dosen Pembimbing)
    @Default(0.0) double dosenFormatLaporan,     // Bobot 15%
    @Default(0.0) double dosenUraianLaporan,     // Bobot 25%
    @Default(0.0) double dosenPresentasiLaporan,  // Bobot 20%
    @Default(0.0) double dosenTanyaJawabLaporan,  // Bobot 40%
    
    @Default(0) int updatedAt,
    @Default(false) bool isDeleted,
  }) = _InternshipGrading;

  factory InternshipGrading.fromJson(Map<String, dynamic> json) =>
      _$InternshipGradingFromJson(json);
}

@freezed
abstract class JobDetail with _$JobDetail {
  const factory JobDetail({
    required String id,
    required String title,
    required String description,
    @Default(false) bool isCompleted,
    @Default('') String reasonOfIncompletion,
    @Default('') String imageUrl,
    required String date,
    @Default(0) int updatedAt,
    @Default(false) bool isDeleted,
  }) = _JobDetail;

  factory JobDetail.fromJson(Map<String, dynamic> json) =>
      _$JobDetailFromJson(json);
}

@freezed
abstract class ResearchData with _$ResearchData {
  const factory ResearchData({
    @Default('') String companyHistory,
    @Default('') String companyVisionMission,
    @Default('') String companyStructureUrl,
    @Default('') String jobDescription,
    @Default('') String procedureWork,
    @Default('') String obstacles,
    @Default(0) int updatedAt,
  }) = _ResearchData;

  factory ResearchData.fromJson(Map<String, dynamic> json) =>
      _$ResearchDataFromJson(json);
}

@freezed
abstract class DocChecklist with _$DocChecklist {
  const factory DocChecklist({
    required String id,
    required String title,
    @Default(false) bool isCompleted,
    required String category, // 'Alat 3' or 'Alat 4' or 'Tambahan'
    @Default('') String fileUrl,
    @Default('') String notes,
    @Default(0) int updatedAt,
    @Default(false) bool isDeleted,
  }) = _DocChecklist;

  factory DocChecklist.fromJson(Map<String, dynamic> json) =>
      _$DocChecklistFromJson(json);
}

enum SyncStatusType {
  idle,
  uploading,
  downloading,
  error,
  offline,
  synced
}

@freezed
abstract class SyncState with _$SyncState {
  const factory SyncState({
    @Default(SyncStatusType.idle) SyncStatusType status,
    @Default('Sistem Siap') String message,
    DateTime? lastSynced,
  }) = _SyncState;
}
