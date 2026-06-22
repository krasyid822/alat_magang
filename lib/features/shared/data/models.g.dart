// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudentProfile _$StudentProfileFromJson(Map<String, dynamic> json) =>
    _StudentProfile(
      nim: json['nim'] as String,
      name: json['name'] as String? ?? '',
      className: json['className'] as String? ?? '',
      major: json['major'] as String? ?? '',
      companyName: json['companyName'] as String? ?? '',
      internshipDurationWeeks:
          (json['internshipDurationWeeks'] as num?)?.toInt() ?? 16,
      whatsappNumber: json['whatsappNumber'] as String? ?? '',
      lastDeviceId: json['lastDeviceId'] as String? ?? '',
      lastLogoutAllTimestamp: (json['lastLogoutAllTimestamp'] as num?)?.toInt(),
      logoutAllForce: json['logoutAllForce'] as bool? ?? false,
      updatedAt: (json['updatedAt'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$StudentProfileToJson(_StudentProfile instance) =>
    <String, dynamic>{
      'nim': instance.nim,
      'name': instance.name,
      'className': instance.className,
      'major': instance.major,
      'companyName': instance.companyName,
      'internshipDurationWeeks': instance.internshipDurationWeeks,
      'whatsappNumber': instance.whatsappNumber,
      'lastDeviceId': instance.lastDeviceId,
      'lastLogoutAllTimestamp': instance.lastLogoutAllTimestamp,
      'logoutAllForce': instance.logoutAllForce,
      'updatedAt': instance.updatedAt,
    };

_InternshipLog _$InternshipLogFromJson(Map<String, dynamic> json) =>
    _InternshipLog(
      id: json['id'] as String,
      date: json['date'] as String,
      activity: json['activity'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      isSigned: json['isSigned'] as bool? ?? false,
      weekNumber: (json['weekNumber'] as num).toInt(),
      signatureData: json['signatureData'] as String? ?? '',
      versionHistory: json['versionHistory'] as String? ?? '',
      updatedAt: (json['updatedAt'] as num?)?.toInt() ?? 0,
      isDeleted: json['isDeleted'] as bool? ?? false,
    );

Map<String, dynamic> _$InternshipLogToJson(_InternshipLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'activity': instance.activity,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'isSigned': instance.isSigned,
      'weekNumber': instance.weekNumber,
      'signatureData': instance.signatureData,
      'versionHistory': instance.versionHistory,
      'updatedAt': instance.updatedAt,
      'isDeleted': instance.isDeleted,
    };

_JobDetail _$JobDetailFromJson(Map<String, dynamic> json) => _JobDetail(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  isCompleted: json['isCompleted'] as bool? ?? false,
  reasonOfIncompletion: json['reasonOfIncompletion'] as String? ?? '',
  imageUrl: json['imageUrl'] as String? ?? '',
  date: json['date'] as String,
  updatedAt: (json['updatedAt'] as num?)?.toInt() ?? 0,
  isDeleted: json['isDeleted'] as bool? ?? false,
);

Map<String, dynamic> _$JobDetailToJson(_JobDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'isCompleted': instance.isCompleted,
      'reasonOfIncompletion': instance.reasonOfIncompletion,
      'imageUrl': instance.imageUrl,
      'date': instance.date,
      'updatedAt': instance.updatedAt,
      'isDeleted': instance.isDeleted,
    };

_ResearchData _$ResearchDataFromJson(Map<String, dynamic> json) =>
    _ResearchData(
      companyHistory: json['companyHistory'] as String? ?? '',
      companyVisionMission: json['companyVisionMission'] as String? ?? '',
      companyStructureUrl: json['companyStructureUrl'] as String? ?? '',
      jobDescription: json['jobDescription'] as String? ?? '',
      procedureWork: json['procedureWork'] as String? ?? '',
      obstacles: json['obstacles'] as String? ?? '',
      updatedAt: (json['updatedAt'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ResearchDataToJson(_ResearchData instance) =>
    <String, dynamic>{
      'companyHistory': instance.companyHistory,
      'companyVisionMission': instance.companyVisionMission,
      'companyStructureUrl': instance.companyStructureUrl,
      'jobDescription': instance.jobDescription,
      'procedureWork': instance.procedureWork,
      'obstacles': instance.obstacles,
      'updatedAt': instance.updatedAt,
    };

_DocChecklist _$DocChecklistFromJson(Map<String, dynamic> json) =>
    _DocChecklist(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      category: json['category'] as String,
      fileUrl: json['fileUrl'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      updatedAt: (json['updatedAt'] as num?)?.toInt() ?? 0,
      isDeleted: json['isDeleted'] as bool? ?? false,
    );

Map<String, dynamic> _$DocChecklistToJson(_DocChecklist instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isCompleted': instance.isCompleted,
      'category': instance.category,
      'fileUrl': instance.fileUrl,
      'notes': instance.notes,
      'updatedAt': instance.updatedAt,
      'isDeleted': instance.isDeleted,
    };
