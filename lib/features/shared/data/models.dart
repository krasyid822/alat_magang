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
    @Default(16) int internshipDurationWeeks,
    @Default('') String whatsappNumber,
    @Default('') String lastDeviceId,
    int? lastLogoutAllTimestamp,
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
    @Default(0) int updatedAt,
    @Default(false) bool isDeleted,
  }) = _InternshipLog;

  factory InternshipLog.fromJson(Map<String, dynamic> json) =>
      _$InternshipLogFromJson(json);
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
