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
      division: json['division'] as String? ?? '',
      mentorName: json['mentorName'] as String? ?? '',
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
      'division': instance.division,
      'mentorName': instance.mentorName,
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
      imageUrls:
          (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      updatedAt: (json['updatedAt'] as num?)?.toInt() ?? 0,
      isDeleted: json['isDeleted'] as bool? ?? false,
      isDraft: json['isDraft'] as bool? ?? false,
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
      'imageUrls': instance.imageUrls,
      'updatedAt': instance.updatedAt,
      'isDeleted': instance.isDeleted,
      'isDraft': instance.isDraft,
    };

_InternshipGrading _$InternshipGradingFromJson(
  Map<String, dynamic> json,
) => _InternshipGrading(
  nim: json['nim'] as String,
  companyKerapian: (json['companyKerapian'] as num?)?.toDouble() ?? 0.0,
  companyDisiplin: (json['companyDisiplin'] as num?)?.toDouble() ?? 0.0,
  companyKehadiran: (json['companyKehadiran'] as num?)?.toDouble() ?? 0.0,
  companyTanggungJawab:
      (json['companyTanggungJawab'] as num?)?.toDouble() ?? 0.0,
  companyKemandirian: (json['companyKemandirian'] as num?)?.toDouble() ?? 0.0,
  companyInisiatif: (json['companyInisiatif'] as num?)?.toDouble() ?? 0.0,
  companyPemahaman: (json['companyPemahaman'] as num?)?.toDouble() ?? 0.0,
  companyKerjasamaRekan:
      (json['companyKerjasamaRekan'] as num?)?.toDouble() ?? 0.0,
  companyKerjasamaAtasan:
      (json['companyKerjasamaAtasan'] as num?)?.toDouble() ?? 0.0,
  companyAdaptasi: (json['companyAdaptasi'] as num?)?.toDouble() ?? 0.0,
  companySaranKritik: json['companySaranKritik'] as String? ?? '',
  dosenFormatLaporan: (json['dosenFormatLaporan'] as num?)?.toDouble() ?? 0.0,
  dosenUraianLaporan: (json['dosenUraianLaporan'] as num?)?.toDouble() ?? 0.0,
  dosenPresentasiLaporan:
      (json['dosenPresentasiLaporan'] as num?)?.toDouble() ?? 0.0,
  dosenTanyaJawabLaporan:
      (json['dosenTanyaJawabLaporan'] as num?)?.toDouble() ?? 0.0,
  updatedAt: (json['updatedAt'] as num?)?.toInt() ?? 0,
  isDeleted: json['isDeleted'] as bool? ?? false,
);

Map<String, dynamic> _$InternshipGradingToJson(_InternshipGrading instance) =>
    <String, dynamic>{
      'nim': instance.nim,
      'companyKerapian': instance.companyKerapian,
      'companyDisiplin': instance.companyDisiplin,
      'companyKehadiran': instance.companyKehadiran,
      'companyTanggungJawab': instance.companyTanggungJawab,
      'companyKemandirian': instance.companyKemandirian,
      'companyInisiatif': instance.companyInisiatif,
      'companyPemahaman': instance.companyPemahaman,
      'companyKerjasamaRekan': instance.companyKerjasamaRekan,
      'companyKerjasamaAtasan': instance.companyKerjasamaAtasan,
      'companyAdaptasi': instance.companyAdaptasi,
      'companySaranKritik': instance.companySaranKritik,
      'dosenFormatLaporan': instance.dosenFormatLaporan,
      'dosenUraianLaporan': instance.dosenUraianLaporan,
      'dosenPresentasiLaporan': instance.dosenPresentasiLaporan,
      'dosenTanyaJawabLaporan': instance.dosenTanyaJawabLaporan,
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
