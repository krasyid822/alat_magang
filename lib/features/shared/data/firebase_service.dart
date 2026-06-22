import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';

part 'firebase_service.g.dart';

@riverpod
FirebaseService firebaseService(Ref ref) {
  return FirebaseService();
}

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection names
  static const String studentsCollection = 'students';
  static const String logsSubcollection = 'logs';
  static const String jobsSubcollection = 'jobs';
  static const String documentsSubcollection = 'documents';
  static const String sessionsSubcollection = 'sessions';

  // Student Profile
  Future<void> saveProfile(StudentProfile profile) async {
    if (profile.nim.isEmpty) return;
    await _db.collection(studentsCollection).doc(profile.nim).set(
      profile.toJson(),
      SetOptions(merge: true),
    );
  }

  // Session Management
  Future<void> registerDevice(String nim, String deviceId) async {
    if (nim.isEmpty || deviceId.isEmpty) return;
    await _db
        .collection(studentsCollection)
        .doc(nim)
        .collection(sessionsSubcollection)
        .doc(deviceId)
        .set({
      'deviceId': deviceId,
      'lastActive': FieldValue.serverTimestamp(),
      'userAgent': html.window.navigator.userAgent,
    });
  }

  Future<void> updateSessionSyncTime(String nim, String deviceId) async {
    if (nim.isEmpty || deviceId.isEmpty) return;
    await _db
        .collection(studentsCollection)
        .doc(nim)
        .collection(sessionsSubcollection)
        .doc(deviceId)
        .set({
      'lastSyncedAt': DateTime.now().millisecondsSinceEpoch,
      'lastActive': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<List<Map<String, dynamic>>> getSessions(String nim) async {
    if (nim.isEmpty) return [];
    final snapshot = await _db
        .collection(studentsCollection)
        .doc(nim)
        .collection(sessionsSubcollection)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> logoutAll(String nim, {required bool force}) async {
    if (nim.isEmpty) return;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    await _db.collection(studentsCollection).doc(nim).update({
      'lastLogoutAllTimestamp': timestamp,
      'logoutAllForce': force,
    });
    // Delete all session documents in sessions subcollection
    try {
      final sessions = await _db
          .collection(studentsCollection)
          .doc(nim)
          .collection(sessionsSubcollection)
          .get();
      for (final doc in sessions.docs) {
        await doc.reference.delete();
      }
    } catch (_) {}
  }

  Future<void> deleteSession(String nim, String deviceId) async {
    if (nim.isEmpty || deviceId.isEmpty) return;
    try {
      await _db
          .collection(studentsCollection)
          .doc(nim)
          .collection(sessionsSubcollection)
          .doc(deviceId)
          .delete();
    } catch (_) {}
  }

  Stream<List<Map<String, dynamic>>> activeSessionsStream(String nim) {
    if (nim.isEmpty) return Stream.value([]);
    return _db
        .collection(studentsCollection)
        .doc(nim)
        .collection(sessionsSubcollection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Stream<int> activeSessionsCount(String nim) {
    if (nim.isEmpty) return Stream.value(0);
    return _db
        .collection(studentsCollection)
        .doc(nim)
        .collection(sessionsSubcollection)
        .snapshots()
        .map((s) => s.docs.length);
  }

  Future<StudentProfile?> getProfile(String nim) async {
    if (nim.isEmpty) return null;
    final doc = await _db.collection(studentsCollection).doc(nim).get();
    if (doc.exists && doc.data() != null) {
      return StudentProfile.fromJson(doc.data()!);
    }
    return null;
  }

  Future<StudentProfile?> getProfileByWhatsapp(String whatsappNumber) async {
    if (whatsappNumber.isEmpty) return null;
    final query = await _db
        .collection(studentsCollection)
        .where('whatsappNumber', isEqualTo: whatsappNumber.trim())
        .limit(1)
        .get();
    if (query.docs.isNotEmpty) {
      return StudentProfile.fromJson(query.docs.first.data());
    }
    return null;
  }

  Stream<StudentProfile?> profileStream(String nim) {
    if (nim.isEmpty) return Stream.value(null);
    return _db.collection(studentsCollection).doc(nim).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return StudentProfile.fromJson(doc.data()!);
      }
      return null;
    });
  }

  // Internship Logs
  Future<void> saveLog(String nim, InternshipLog log) async {
    if (nim.isEmpty) return;
    await _db
        .collection(studentsCollection)
        .doc(nim)
        .collection(logsSubcollection)
        .doc(log.id)
        .set(log.toJson());
  }

  Future<void> deleteLog(String nim, String logId) async {
    if (nim.isEmpty) return;
    await _db
        .collection(studentsCollection)
        .doc(nim)
        .collection(logsSubcollection)
        .doc(logId)
        .delete();
  }

  Future<List<InternshipLog>> getLogs(String nim) async {
    if (nim.isEmpty) return [];
    final snapshot = await _db
        .collection(studentsCollection)
        .doc(nim)
        .collection(logsSubcollection)
        .get();
    return snapshot.docs.map((doc) => InternshipLog.fromJson(doc.data())).toList();
  }

  Stream<List<InternshipLog>> logsStream(String nim) {
    if (nim.isEmpty) return Stream.value([]);
    return _db
        .collection(studentsCollection)
        .doc(nim)
        .collection(logsSubcollection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => InternshipLog.fromJson(doc.data())).toList();
    });
  }

  // Job Details
  Future<void> saveJob(String nim, JobDetail job) async {
    if (nim.isEmpty) return;
    await _db
        .collection(studentsCollection)
        .doc(nim)
        .collection(jobsSubcollection)
        .doc(job.id)
        .set(job.toJson());
  }

  Future<void> deleteJob(String nim, String jobId) async {
    if (nim.isEmpty) return;
    await _db
        .collection(studentsCollection)
        .doc(nim)
        .collection(jobsSubcollection)
        .doc(jobId)
        .delete();
  }

  Future<List<JobDetail>> getJobs(String nim) async {
    if (nim.isEmpty) return [];
    final snapshot = await _db
        .collection(studentsCollection)
        .doc(nim)
        .collection(jobsSubcollection)
        .get();
    return snapshot.docs.map((doc) => JobDetail.fromJson(doc.data())).toList();
  }

  Stream<List<JobDetail>> jobsStream(String nim) {
    if (nim.isEmpty) return Stream.value([]);
    return _db
        .collection(studentsCollection)
        .doc(nim)
        .collection(jobsSubcollection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => JobDetail.fromJson(doc.data())).toList();
    });
  }

  // Research Data
  Future<void> saveResearchData(String nim, ResearchData data) async {
    if (nim.isEmpty) return;
    await _db.collection(studentsCollection).doc(nim).set(
      {'researchData': data.toJson()},
      SetOptions(merge: true),
    );
  }

  Future<ResearchData?> getResearchData(String nim) async {
    if (nim.isEmpty) return null;
    final doc = await _db.collection(studentsCollection).doc(nim).get();
    if (doc.exists && doc.data() != null && doc.data()!['researchData'] != null) {
      return ResearchData.fromJson(doc.data()!['researchData']);
    }
    return null;
  }

  Stream<ResearchData?> researchDataStream(String nim) {
    if (nim.isEmpty) return Stream.value(null);
    return _db.collection(studentsCollection).doc(nim).snapshots().map((doc) {
      if (doc.exists && doc.data() != null && doc.data()!['researchData'] != null) {
        return ResearchData.fromJson(doc.data()!['researchData']);
      }
      return null;
    });
  }

  // Document Checklist
  Future<void> saveDocument(String nim, DocChecklist doc) async {
    if (nim.isEmpty) return;
    await _db
        .collection(studentsCollection)
        .doc(nim)
        .collection(documentsSubcollection)
        .doc(doc.id)
        .set(doc.toJson());
  }

  Future<List<DocChecklist>> getDocuments(String nim) async {
    if (nim.isEmpty) return [];
    final snapshot = await _db
        .collection(studentsCollection)
        .doc(nim)
        .collection(documentsSubcollection)
        .get();
    return snapshot.docs.map((doc) => DocChecklist.fromJson(doc.data())).toList();
  }

  Stream<List<DocChecklist>> documentsStream(String nim) {
    if (nim.isEmpty) return Stream.value([]);
    return _db
        .collection(studentsCollection)
        .doc(nim)
        .collection(documentsSubcollection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => DocChecklist.fromJson(doc.data())).toList();
    });
  }

  Future<void> deleteDocument(String nim, String docId) async {
    if (nim.isEmpty) return;
    await _db
        .collection(studentsCollection)
        .doc(nim)
        .collection(documentsSubcollection)
        .doc(docId)
        .delete();
  }
}
