// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudentProfile {

 String get nim; String get name; String get className; String get major; String get companyName; String get division; String get mentorName; int get internshipDurationWeeks; String get whatsappNumber; String get lastDeviceId; int? get lastLogoutAllTimestamp; bool get logoutAllForce; int get updatedAt;
/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentProfileCopyWith<StudentProfile> get copyWith => _$StudentProfileCopyWithImpl<StudentProfile>(this as StudentProfile, _$identity);

  /// Serializes this StudentProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentProfile&&(identical(other.nim, nim) || other.nim == nim)&&(identical(other.name, name) || other.name == name)&&(identical(other.className, className) || other.className == className)&&(identical(other.major, major) || other.major == major)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.division, division) || other.division == division)&&(identical(other.mentorName, mentorName) || other.mentorName == mentorName)&&(identical(other.internshipDurationWeeks, internshipDurationWeeks) || other.internshipDurationWeeks == internshipDurationWeeks)&&(identical(other.whatsappNumber, whatsappNumber) || other.whatsappNumber == whatsappNumber)&&(identical(other.lastDeviceId, lastDeviceId) || other.lastDeviceId == lastDeviceId)&&(identical(other.lastLogoutAllTimestamp, lastLogoutAllTimestamp) || other.lastLogoutAllTimestamp == lastLogoutAllTimestamp)&&(identical(other.logoutAllForce, logoutAllForce) || other.logoutAllForce == logoutAllForce)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nim,name,className,major,companyName,division,mentorName,internshipDurationWeeks,whatsappNumber,lastDeviceId,lastLogoutAllTimestamp,logoutAllForce,updatedAt);

@override
String toString() {
  return 'StudentProfile(nim: $nim, name: $name, className: $className, major: $major, companyName: $companyName, division: $division, mentorName: $mentorName, internshipDurationWeeks: $internshipDurationWeeks, whatsappNumber: $whatsappNumber, lastDeviceId: $lastDeviceId, lastLogoutAllTimestamp: $lastLogoutAllTimestamp, logoutAllForce: $logoutAllForce, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StudentProfileCopyWith<$Res>  {
  factory $StudentProfileCopyWith(StudentProfile value, $Res Function(StudentProfile) _then) = _$StudentProfileCopyWithImpl;
@useResult
$Res call({
 String nim, String name, String className, String major, String companyName, String division, String mentorName, int internshipDurationWeeks, String whatsappNumber, String lastDeviceId, int? lastLogoutAllTimestamp, bool logoutAllForce, int updatedAt
});




}
/// @nodoc
class _$StudentProfileCopyWithImpl<$Res>
    implements $StudentProfileCopyWith<$Res> {
  _$StudentProfileCopyWithImpl(this._self, this._then);

  final StudentProfile _self;
  final $Res Function(StudentProfile) _then;

/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nim = null,Object? name = null,Object? className = null,Object? major = null,Object? companyName = null,Object? division = null,Object? mentorName = null,Object? internshipDurationWeeks = null,Object? whatsappNumber = null,Object? lastDeviceId = null,Object? lastLogoutAllTimestamp = freezed,Object? logoutAllForce = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
nim: null == nim ? _self.nim : nim // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,className: null == className ? _self.className : className // ignore: cast_nullable_to_non_nullable
as String,major: null == major ? _self.major : major // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,division: null == division ? _self.division : division // ignore: cast_nullable_to_non_nullable
as String,mentorName: null == mentorName ? _self.mentorName : mentorName // ignore: cast_nullable_to_non_nullable
as String,internshipDurationWeeks: null == internshipDurationWeeks ? _self.internshipDurationWeeks : internshipDurationWeeks // ignore: cast_nullable_to_non_nullable
as int,whatsappNumber: null == whatsappNumber ? _self.whatsappNumber : whatsappNumber // ignore: cast_nullable_to_non_nullable
as String,lastDeviceId: null == lastDeviceId ? _self.lastDeviceId : lastDeviceId // ignore: cast_nullable_to_non_nullable
as String,lastLogoutAllTimestamp: freezed == lastLogoutAllTimestamp ? _self.lastLogoutAllTimestamp : lastLogoutAllTimestamp // ignore: cast_nullable_to_non_nullable
as int?,logoutAllForce: null == logoutAllForce ? _self.logoutAllForce : logoutAllForce // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentProfile].
extension StudentProfilePatterns on StudentProfile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentProfile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentProfile value)  $default,){
final _that = this;
switch (_that) {
case _StudentProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentProfile value)?  $default,){
final _that = this;
switch (_that) {
case _StudentProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nim,  String name,  String className,  String major,  String companyName,  String division,  String mentorName,  int internshipDurationWeeks,  String whatsappNumber,  String lastDeviceId,  int? lastLogoutAllTimestamp,  bool logoutAllForce,  int updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentProfile() when $default != null:
return $default(_that.nim,_that.name,_that.className,_that.major,_that.companyName,_that.division,_that.mentorName,_that.internshipDurationWeeks,_that.whatsappNumber,_that.lastDeviceId,_that.lastLogoutAllTimestamp,_that.logoutAllForce,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nim,  String name,  String className,  String major,  String companyName,  String division,  String mentorName,  int internshipDurationWeeks,  String whatsappNumber,  String lastDeviceId,  int? lastLogoutAllTimestamp,  bool logoutAllForce,  int updatedAt)  $default,) {final _that = this;
switch (_that) {
case _StudentProfile():
return $default(_that.nim,_that.name,_that.className,_that.major,_that.companyName,_that.division,_that.mentorName,_that.internshipDurationWeeks,_that.whatsappNumber,_that.lastDeviceId,_that.lastLogoutAllTimestamp,_that.logoutAllForce,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nim,  String name,  String className,  String major,  String companyName,  String division,  String mentorName,  int internshipDurationWeeks,  String whatsappNumber,  String lastDeviceId,  int? lastLogoutAllTimestamp,  bool logoutAllForce,  int updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _StudentProfile() when $default != null:
return $default(_that.nim,_that.name,_that.className,_that.major,_that.companyName,_that.division,_that.mentorName,_that.internshipDurationWeeks,_that.whatsappNumber,_that.lastDeviceId,_that.lastLogoutAllTimestamp,_that.logoutAllForce,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudentProfile implements StudentProfile {
  const _StudentProfile({required this.nim, this.name = '', this.className = '', this.major = '', this.companyName = '', this.division = '', this.mentorName = '', this.internshipDurationWeeks = 16, this.whatsappNumber = '', this.lastDeviceId = '', this.lastLogoutAllTimestamp, this.logoutAllForce = false, this.updatedAt = 0});
  factory _StudentProfile.fromJson(Map<String, dynamic> json) => _$StudentProfileFromJson(json);

@override final  String nim;
@override@JsonKey() final  String name;
@override@JsonKey() final  String className;
@override@JsonKey() final  String major;
@override@JsonKey() final  String companyName;
@override@JsonKey() final  String division;
@override@JsonKey() final  String mentorName;
@override@JsonKey() final  int internshipDurationWeeks;
@override@JsonKey() final  String whatsappNumber;
@override@JsonKey() final  String lastDeviceId;
@override final  int? lastLogoutAllTimestamp;
@override@JsonKey() final  bool logoutAllForce;
@override@JsonKey() final  int updatedAt;

/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentProfileCopyWith<_StudentProfile> get copyWith => __$StudentProfileCopyWithImpl<_StudentProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentProfile&&(identical(other.nim, nim) || other.nim == nim)&&(identical(other.name, name) || other.name == name)&&(identical(other.className, className) || other.className == className)&&(identical(other.major, major) || other.major == major)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.division, division) || other.division == division)&&(identical(other.mentorName, mentorName) || other.mentorName == mentorName)&&(identical(other.internshipDurationWeeks, internshipDurationWeeks) || other.internshipDurationWeeks == internshipDurationWeeks)&&(identical(other.whatsappNumber, whatsappNumber) || other.whatsappNumber == whatsappNumber)&&(identical(other.lastDeviceId, lastDeviceId) || other.lastDeviceId == lastDeviceId)&&(identical(other.lastLogoutAllTimestamp, lastLogoutAllTimestamp) || other.lastLogoutAllTimestamp == lastLogoutAllTimestamp)&&(identical(other.logoutAllForce, logoutAllForce) || other.logoutAllForce == logoutAllForce)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nim,name,className,major,companyName,division,mentorName,internshipDurationWeeks,whatsappNumber,lastDeviceId,lastLogoutAllTimestamp,logoutAllForce,updatedAt);

@override
String toString() {
  return 'StudentProfile(nim: $nim, name: $name, className: $className, major: $major, companyName: $companyName, division: $division, mentorName: $mentorName, internshipDurationWeeks: $internshipDurationWeeks, whatsappNumber: $whatsappNumber, lastDeviceId: $lastDeviceId, lastLogoutAllTimestamp: $lastLogoutAllTimestamp, logoutAllForce: $logoutAllForce, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StudentProfileCopyWith<$Res> implements $StudentProfileCopyWith<$Res> {
  factory _$StudentProfileCopyWith(_StudentProfile value, $Res Function(_StudentProfile) _then) = __$StudentProfileCopyWithImpl;
@override @useResult
$Res call({
 String nim, String name, String className, String major, String companyName, String division, String mentorName, int internshipDurationWeeks, String whatsappNumber, String lastDeviceId, int? lastLogoutAllTimestamp, bool logoutAllForce, int updatedAt
});




}
/// @nodoc
class __$StudentProfileCopyWithImpl<$Res>
    implements _$StudentProfileCopyWith<$Res> {
  __$StudentProfileCopyWithImpl(this._self, this._then);

  final _StudentProfile _self;
  final $Res Function(_StudentProfile) _then;

/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nim = null,Object? name = null,Object? className = null,Object? major = null,Object? companyName = null,Object? division = null,Object? mentorName = null,Object? internshipDurationWeeks = null,Object? whatsappNumber = null,Object? lastDeviceId = null,Object? lastLogoutAllTimestamp = freezed,Object? logoutAllForce = null,Object? updatedAt = null,}) {
  return _then(_StudentProfile(
nim: null == nim ? _self.nim : nim // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,className: null == className ? _self.className : className // ignore: cast_nullable_to_non_nullable
as String,major: null == major ? _self.major : major // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,division: null == division ? _self.division : division // ignore: cast_nullable_to_non_nullable
as String,mentorName: null == mentorName ? _self.mentorName : mentorName // ignore: cast_nullable_to_non_nullable
as String,internshipDurationWeeks: null == internshipDurationWeeks ? _self.internshipDurationWeeks : internshipDurationWeeks // ignore: cast_nullable_to_non_nullable
as int,whatsappNumber: null == whatsappNumber ? _self.whatsappNumber : whatsappNumber // ignore: cast_nullable_to_non_nullable
as String,lastDeviceId: null == lastDeviceId ? _self.lastDeviceId : lastDeviceId // ignore: cast_nullable_to_non_nullable
as String,lastLogoutAllTimestamp: freezed == lastLogoutAllTimestamp ? _self.lastLogoutAllTimestamp : lastLogoutAllTimestamp // ignore: cast_nullable_to_non_nullable
as int?,logoutAllForce: null == logoutAllForce ? _self.logoutAllForce : logoutAllForce // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$InternshipLog {

 String get id; String get date; String get activity; String get startTime; String get endTime; bool get isSigned; int get weekNumber; String get signatureData; String get versionHistory; List<String> get imageUrls; int get updatedAt; bool get isDeleted;
/// Create a copy of InternshipLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InternshipLogCopyWith<InternshipLog> get copyWith => _$InternshipLogCopyWithImpl<InternshipLog>(this as InternshipLog, _$identity);

  /// Serializes this InternshipLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InternshipLog&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isSigned, isSigned) || other.isSigned == isSigned)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.signatureData, signatureData) || other.signatureData == signatureData)&&(identical(other.versionHistory, versionHistory) || other.versionHistory == versionHistory)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,activity,startTime,endTime,isSigned,weekNumber,signatureData,versionHistory,const DeepCollectionEquality().hash(imageUrls),updatedAt,isDeleted);

@override
String toString() {
  return 'InternshipLog(id: $id, date: $date, activity: $activity, startTime: $startTime, endTime: $endTime, isSigned: $isSigned, weekNumber: $weekNumber, signatureData: $signatureData, versionHistory: $versionHistory, imageUrls: $imageUrls, updatedAt: $updatedAt, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class $InternshipLogCopyWith<$Res>  {
  factory $InternshipLogCopyWith(InternshipLog value, $Res Function(InternshipLog) _then) = _$InternshipLogCopyWithImpl;
@useResult
$Res call({
 String id, String date, String activity, String startTime, String endTime, bool isSigned, int weekNumber, String signatureData, String versionHistory, List<String> imageUrls, int updatedAt, bool isDeleted
});




}
/// @nodoc
class _$InternshipLogCopyWithImpl<$Res>
    implements $InternshipLogCopyWith<$Res> {
  _$InternshipLogCopyWithImpl(this._self, this._then);

  final InternshipLog _self;
  final $Res Function(InternshipLog) _then;

/// Create a copy of InternshipLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? activity = null,Object? startTime = null,Object? endTime = null,Object? isSigned = null,Object? weekNumber = null,Object? signatureData = null,Object? versionHistory = null,Object? imageUrls = null,Object? updatedAt = null,Object? isDeleted = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,isSigned: null == isSigned ? _self.isSigned : isSigned // ignore: cast_nullable_to_non_nullable
as bool,weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,signatureData: null == signatureData ? _self.signatureData : signatureData // ignore: cast_nullable_to_non_nullable
as String,versionHistory: null == versionHistory ? _self.versionHistory : versionHistory // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [InternshipLog].
extension InternshipLogPatterns on InternshipLog {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InternshipLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InternshipLog() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InternshipLog value)  $default,){
final _that = this;
switch (_that) {
case _InternshipLog():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InternshipLog value)?  $default,){
final _that = this;
switch (_that) {
case _InternshipLog() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String date,  String activity,  String startTime,  String endTime,  bool isSigned,  int weekNumber,  String signatureData,  String versionHistory,  List<String> imageUrls,  int updatedAt,  bool isDeleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InternshipLog() when $default != null:
return $default(_that.id,_that.date,_that.activity,_that.startTime,_that.endTime,_that.isSigned,_that.weekNumber,_that.signatureData,_that.versionHistory,_that.imageUrls,_that.updatedAt,_that.isDeleted);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String date,  String activity,  String startTime,  String endTime,  bool isSigned,  int weekNumber,  String signatureData,  String versionHistory,  List<String> imageUrls,  int updatedAt,  bool isDeleted)  $default,) {final _that = this;
switch (_that) {
case _InternshipLog():
return $default(_that.id,_that.date,_that.activity,_that.startTime,_that.endTime,_that.isSigned,_that.weekNumber,_that.signatureData,_that.versionHistory,_that.imageUrls,_that.updatedAt,_that.isDeleted);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String date,  String activity,  String startTime,  String endTime,  bool isSigned,  int weekNumber,  String signatureData,  String versionHistory,  List<String> imageUrls,  int updatedAt,  bool isDeleted)?  $default,) {final _that = this;
switch (_that) {
case _InternshipLog() when $default != null:
return $default(_that.id,_that.date,_that.activity,_that.startTime,_that.endTime,_that.isSigned,_that.weekNumber,_that.signatureData,_that.versionHistory,_that.imageUrls,_that.updatedAt,_that.isDeleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InternshipLog implements InternshipLog {
  const _InternshipLog({required this.id, required this.date, required this.activity, required this.startTime, required this.endTime, this.isSigned = false, required this.weekNumber, this.signatureData = '', this.versionHistory = '', final  List<String> imageUrls = const [], this.updatedAt = 0, this.isDeleted = false}): _imageUrls = imageUrls;
  factory _InternshipLog.fromJson(Map<String, dynamic> json) => _$InternshipLogFromJson(json);

@override final  String id;
@override final  String date;
@override final  String activity;
@override final  String startTime;
@override final  String endTime;
@override@JsonKey() final  bool isSigned;
@override final  int weekNumber;
@override@JsonKey() final  String signatureData;
@override@JsonKey() final  String versionHistory;
 final  List<String> _imageUrls;
@override@JsonKey() List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override@JsonKey() final  int updatedAt;
@override@JsonKey() final  bool isDeleted;

/// Create a copy of InternshipLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InternshipLogCopyWith<_InternshipLog> get copyWith => __$InternshipLogCopyWithImpl<_InternshipLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InternshipLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InternshipLog&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isSigned, isSigned) || other.isSigned == isSigned)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.signatureData, signatureData) || other.signatureData == signatureData)&&(identical(other.versionHistory, versionHistory) || other.versionHistory == versionHistory)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,activity,startTime,endTime,isSigned,weekNumber,signatureData,versionHistory,const DeepCollectionEquality().hash(_imageUrls),updatedAt,isDeleted);

@override
String toString() {
  return 'InternshipLog(id: $id, date: $date, activity: $activity, startTime: $startTime, endTime: $endTime, isSigned: $isSigned, weekNumber: $weekNumber, signatureData: $signatureData, versionHistory: $versionHistory, imageUrls: $imageUrls, updatedAt: $updatedAt, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class _$InternshipLogCopyWith<$Res> implements $InternshipLogCopyWith<$Res> {
  factory _$InternshipLogCopyWith(_InternshipLog value, $Res Function(_InternshipLog) _then) = __$InternshipLogCopyWithImpl;
@override @useResult
$Res call({
 String id, String date, String activity, String startTime, String endTime, bool isSigned, int weekNumber, String signatureData, String versionHistory, List<String> imageUrls, int updatedAt, bool isDeleted
});




}
/// @nodoc
class __$InternshipLogCopyWithImpl<$Res>
    implements _$InternshipLogCopyWith<$Res> {
  __$InternshipLogCopyWithImpl(this._self, this._then);

  final _InternshipLog _self;
  final $Res Function(_InternshipLog) _then;

/// Create a copy of InternshipLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? activity = null,Object? startTime = null,Object? endTime = null,Object? isSigned = null,Object? weekNumber = null,Object? signatureData = null,Object? versionHistory = null,Object? imageUrls = null,Object? updatedAt = null,Object? isDeleted = null,}) {
  return _then(_InternshipLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,isSigned: null == isSigned ? _self.isSigned : isSigned // ignore: cast_nullable_to_non_nullable
as bool,weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,signatureData: null == signatureData ? _self.signatureData : signatureData // ignore: cast_nullable_to_non_nullable
as String,versionHistory: null == versionHistory ? _self.versionHistory : versionHistory // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$InternshipGrading {

 String get nim; double get companyKerapian; double get companyDisiplin; double get companyKehadiran; double get companyTanggungJawab; double get companyKemandirian; double get companyInisiatif; double get companyPemahaman; double get companyKerjasamaRekan; double get companyKerjasamaAtasan; double get companyAdaptasi; String get companySaranKritik; double get dosenFormatLaporan; double get dosenUraianLaporan; double get dosenPresentasiLaporan; double get dosenTanyaJawabLaporan; int get updatedAt; bool get isDeleted;
/// Create a copy of InternshipGrading
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InternshipGradingCopyWith<InternshipGrading> get copyWith => _$InternshipGradingCopyWithImpl<InternshipGrading>(this as InternshipGrading, _$identity);

  /// Serializes this InternshipGrading to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InternshipGrading&&(identical(other.nim, nim) || other.nim == nim)&&(identical(other.companyKerapian, companyKerapian) || other.companyKerapian == companyKerapian)&&(identical(other.companyDisiplin, companyDisiplin) || other.companyDisiplin == companyDisiplin)&&(identical(other.companyKehadiran, companyKehadiran) || other.companyKehadiran == companyKehadiran)&&(identical(other.companyTanggungJawab, companyTanggungJawab) || other.companyTanggungJawab == companyTanggungJawab)&&(identical(other.companyKemandirian, companyKemandirian) || other.companyKemandirian == companyKemandirian)&&(identical(other.companyInisiatif, companyInisiatif) || other.companyInisiatif == companyInisiatif)&&(identical(other.companyPemahaman, companyPemahaman) || other.companyPemahaman == companyPemahaman)&&(identical(other.companyKerjasamaRekan, companyKerjasamaRekan) || other.companyKerjasamaRekan == companyKerjasamaRekan)&&(identical(other.companyKerjasamaAtasan, companyKerjasamaAtasan) || other.companyKerjasamaAtasan == companyKerjasamaAtasan)&&(identical(other.companyAdaptasi, companyAdaptasi) || other.companyAdaptasi == companyAdaptasi)&&(identical(other.companySaranKritik, companySaranKritik) || other.companySaranKritik == companySaranKritik)&&(identical(other.dosenFormatLaporan, dosenFormatLaporan) || other.dosenFormatLaporan == dosenFormatLaporan)&&(identical(other.dosenUraianLaporan, dosenUraianLaporan) || other.dosenUraianLaporan == dosenUraianLaporan)&&(identical(other.dosenPresentasiLaporan, dosenPresentasiLaporan) || other.dosenPresentasiLaporan == dosenPresentasiLaporan)&&(identical(other.dosenTanyaJawabLaporan, dosenTanyaJawabLaporan) || other.dosenTanyaJawabLaporan == dosenTanyaJawabLaporan)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nim,companyKerapian,companyDisiplin,companyKehadiran,companyTanggungJawab,companyKemandirian,companyInisiatif,companyPemahaman,companyKerjasamaRekan,companyKerjasamaAtasan,companyAdaptasi,companySaranKritik,dosenFormatLaporan,dosenUraianLaporan,dosenPresentasiLaporan,dosenTanyaJawabLaporan,updatedAt,isDeleted);

@override
String toString() {
  return 'InternshipGrading(nim: $nim, companyKerapian: $companyKerapian, companyDisiplin: $companyDisiplin, companyKehadiran: $companyKehadiran, companyTanggungJawab: $companyTanggungJawab, companyKemandirian: $companyKemandirian, companyInisiatif: $companyInisiatif, companyPemahaman: $companyPemahaman, companyKerjasamaRekan: $companyKerjasamaRekan, companyKerjasamaAtasan: $companyKerjasamaAtasan, companyAdaptasi: $companyAdaptasi, companySaranKritik: $companySaranKritik, dosenFormatLaporan: $dosenFormatLaporan, dosenUraianLaporan: $dosenUraianLaporan, dosenPresentasiLaporan: $dosenPresentasiLaporan, dosenTanyaJawabLaporan: $dosenTanyaJawabLaporan, updatedAt: $updatedAt, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class $InternshipGradingCopyWith<$Res>  {
  factory $InternshipGradingCopyWith(InternshipGrading value, $Res Function(InternshipGrading) _then) = _$InternshipGradingCopyWithImpl;
@useResult
$Res call({
 String nim, double companyKerapian, double companyDisiplin, double companyKehadiran, double companyTanggungJawab, double companyKemandirian, double companyInisiatif, double companyPemahaman, double companyKerjasamaRekan, double companyKerjasamaAtasan, double companyAdaptasi, String companySaranKritik, double dosenFormatLaporan, double dosenUraianLaporan, double dosenPresentasiLaporan, double dosenTanyaJawabLaporan, int updatedAt, bool isDeleted
});




}
/// @nodoc
class _$InternshipGradingCopyWithImpl<$Res>
    implements $InternshipGradingCopyWith<$Res> {
  _$InternshipGradingCopyWithImpl(this._self, this._then);

  final InternshipGrading _self;
  final $Res Function(InternshipGrading) _then;

/// Create a copy of InternshipGrading
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nim = null,Object? companyKerapian = null,Object? companyDisiplin = null,Object? companyKehadiran = null,Object? companyTanggungJawab = null,Object? companyKemandirian = null,Object? companyInisiatif = null,Object? companyPemahaman = null,Object? companyKerjasamaRekan = null,Object? companyKerjasamaAtasan = null,Object? companyAdaptasi = null,Object? companySaranKritik = null,Object? dosenFormatLaporan = null,Object? dosenUraianLaporan = null,Object? dosenPresentasiLaporan = null,Object? dosenTanyaJawabLaporan = null,Object? updatedAt = null,Object? isDeleted = null,}) {
  return _then(_self.copyWith(
nim: null == nim ? _self.nim : nim // ignore: cast_nullable_to_non_nullable
as String,companyKerapian: null == companyKerapian ? _self.companyKerapian : companyKerapian // ignore: cast_nullable_to_non_nullable
as double,companyDisiplin: null == companyDisiplin ? _self.companyDisiplin : companyDisiplin // ignore: cast_nullable_to_non_nullable
as double,companyKehadiran: null == companyKehadiran ? _self.companyKehadiran : companyKehadiran // ignore: cast_nullable_to_non_nullable
as double,companyTanggungJawab: null == companyTanggungJawab ? _self.companyTanggungJawab : companyTanggungJawab // ignore: cast_nullable_to_non_nullable
as double,companyKemandirian: null == companyKemandirian ? _self.companyKemandirian : companyKemandirian // ignore: cast_nullable_to_non_nullable
as double,companyInisiatif: null == companyInisiatif ? _self.companyInisiatif : companyInisiatif // ignore: cast_nullable_to_non_nullable
as double,companyPemahaman: null == companyPemahaman ? _self.companyPemahaman : companyPemahaman // ignore: cast_nullable_to_non_nullable
as double,companyKerjasamaRekan: null == companyKerjasamaRekan ? _self.companyKerjasamaRekan : companyKerjasamaRekan // ignore: cast_nullable_to_non_nullable
as double,companyKerjasamaAtasan: null == companyKerjasamaAtasan ? _self.companyKerjasamaAtasan : companyKerjasamaAtasan // ignore: cast_nullable_to_non_nullable
as double,companyAdaptasi: null == companyAdaptasi ? _self.companyAdaptasi : companyAdaptasi // ignore: cast_nullable_to_non_nullable
as double,companySaranKritik: null == companySaranKritik ? _self.companySaranKritik : companySaranKritik // ignore: cast_nullable_to_non_nullable
as String,dosenFormatLaporan: null == dosenFormatLaporan ? _self.dosenFormatLaporan : dosenFormatLaporan // ignore: cast_nullable_to_non_nullable
as double,dosenUraianLaporan: null == dosenUraianLaporan ? _self.dosenUraianLaporan : dosenUraianLaporan // ignore: cast_nullable_to_non_nullable
as double,dosenPresentasiLaporan: null == dosenPresentasiLaporan ? _self.dosenPresentasiLaporan : dosenPresentasiLaporan // ignore: cast_nullable_to_non_nullable
as double,dosenTanyaJawabLaporan: null == dosenTanyaJawabLaporan ? _self.dosenTanyaJawabLaporan : dosenTanyaJawabLaporan // ignore: cast_nullable_to_non_nullable
as double,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [InternshipGrading].
extension InternshipGradingPatterns on InternshipGrading {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InternshipGrading value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InternshipGrading() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InternshipGrading value)  $default,){
final _that = this;
switch (_that) {
case _InternshipGrading():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InternshipGrading value)?  $default,){
final _that = this;
switch (_that) {
case _InternshipGrading() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nim,  double companyKerapian,  double companyDisiplin,  double companyKehadiran,  double companyTanggungJawab,  double companyKemandirian,  double companyInisiatif,  double companyPemahaman,  double companyKerjasamaRekan,  double companyKerjasamaAtasan,  double companyAdaptasi,  String companySaranKritik,  double dosenFormatLaporan,  double dosenUraianLaporan,  double dosenPresentasiLaporan,  double dosenTanyaJawabLaporan,  int updatedAt,  bool isDeleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InternshipGrading() when $default != null:
return $default(_that.nim,_that.companyKerapian,_that.companyDisiplin,_that.companyKehadiran,_that.companyTanggungJawab,_that.companyKemandirian,_that.companyInisiatif,_that.companyPemahaman,_that.companyKerjasamaRekan,_that.companyKerjasamaAtasan,_that.companyAdaptasi,_that.companySaranKritik,_that.dosenFormatLaporan,_that.dosenUraianLaporan,_that.dosenPresentasiLaporan,_that.dosenTanyaJawabLaporan,_that.updatedAt,_that.isDeleted);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nim,  double companyKerapian,  double companyDisiplin,  double companyKehadiran,  double companyTanggungJawab,  double companyKemandirian,  double companyInisiatif,  double companyPemahaman,  double companyKerjasamaRekan,  double companyKerjasamaAtasan,  double companyAdaptasi,  String companySaranKritik,  double dosenFormatLaporan,  double dosenUraianLaporan,  double dosenPresentasiLaporan,  double dosenTanyaJawabLaporan,  int updatedAt,  bool isDeleted)  $default,) {final _that = this;
switch (_that) {
case _InternshipGrading():
return $default(_that.nim,_that.companyKerapian,_that.companyDisiplin,_that.companyKehadiran,_that.companyTanggungJawab,_that.companyKemandirian,_that.companyInisiatif,_that.companyPemahaman,_that.companyKerjasamaRekan,_that.companyKerjasamaAtasan,_that.companyAdaptasi,_that.companySaranKritik,_that.dosenFormatLaporan,_that.dosenUraianLaporan,_that.dosenPresentasiLaporan,_that.dosenTanyaJawabLaporan,_that.updatedAt,_that.isDeleted);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nim,  double companyKerapian,  double companyDisiplin,  double companyKehadiran,  double companyTanggungJawab,  double companyKemandirian,  double companyInisiatif,  double companyPemahaman,  double companyKerjasamaRekan,  double companyKerjasamaAtasan,  double companyAdaptasi,  String companySaranKritik,  double dosenFormatLaporan,  double dosenUraianLaporan,  double dosenPresentasiLaporan,  double dosenTanyaJawabLaporan,  int updatedAt,  bool isDeleted)?  $default,) {final _that = this;
switch (_that) {
case _InternshipGrading() when $default != null:
return $default(_that.nim,_that.companyKerapian,_that.companyDisiplin,_that.companyKehadiran,_that.companyTanggungJawab,_that.companyKemandirian,_that.companyInisiatif,_that.companyPemahaman,_that.companyKerjasamaRekan,_that.companyKerjasamaAtasan,_that.companyAdaptasi,_that.companySaranKritik,_that.dosenFormatLaporan,_that.dosenUraianLaporan,_that.dosenPresentasiLaporan,_that.dosenTanyaJawabLaporan,_that.updatedAt,_that.isDeleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InternshipGrading implements InternshipGrading {
  const _InternshipGrading({required this.nim, this.companyKerapian = 0.0, this.companyDisiplin = 0.0, this.companyKehadiran = 0.0, this.companyTanggungJawab = 0.0, this.companyKemandirian = 0.0, this.companyInisiatif = 0.0, this.companyPemahaman = 0.0, this.companyKerjasamaRekan = 0.0, this.companyKerjasamaAtasan = 0.0, this.companyAdaptasi = 0.0, this.companySaranKritik = '', this.dosenFormatLaporan = 0.0, this.dosenUraianLaporan = 0.0, this.dosenPresentasiLaporan = 0.0, this.dosenTanyaJawabLaporan = 0.0, this.updatedAt = 0, this.isDeleted = false});
  factory _InternshipGrading.fromJson(Map<String, dynamic> json) => _$InternshipGradingFromJson(json);

@override final  String nim;
@override@JsonKey() final  double companyKerapian;
@override@JsonKey() final  double companyDisiplin;
@override@JsonKey() final  double companyKehadiran;
@override@JsonKey() final  double companyTanggungJawab;
@override@JsonKey() final  double companyKemandirian;
@override@JsonKey() final  double companyInisiatif;
@override@JsonKey() final  double companyPemahaman;
@override@JsonKey() final  double companyKerjasamaRekan;
@override@JsonKey() final  double companyKerjasamaAtasan;
@override@JsonKey() final  double companyAdaptasi;
@override@JsonKey() final  String companySaranKritik;
@override@JsonKey() final  double dosenFormatLaporan;
@override@JsonKey() final  double dosenUraianLaporan;
@override@JsonKey() final  double dosenPresentasiLaporan;
@override@JsonKey() final  double dosenTanyaJawabLaporan;
@override@JsonKey() final  int updatedAt;
@override@JsonKey() final  bool isDeleted;

/// Create a copy of InternshipGrading
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InternshipGradingCopyWith<_InternshipGrading> get copyWith => __$InternshipGradingCopyWithImpl<_InternshipGrading>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InternshipGradingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InternshipGrading&&(identical(other.nim, nim) || other.nim == nim)&&(identical(other.companyKerapian, companyKerapian) || other.companyKerapian == companyKerapian)&&(identical(other.companyDisiplin, companyDisiplin) || other.companyDisiplin == companyDisiplin)&&(identical(other.companyKehadiran, companyKehadiran) || other.companyKehadiran == companyKehadiran)&&(identical(other.companyTanggungJawab, companyTanggungJawab) || other.companyTanggungJawab == companyTanggungJawab)&&(identical(other.companyKemandirian, companyKemandirian) || other.companyKemandirian == companyKemandirian)&&(identical(other.companyInisiatif, companyInisiatif) || other.companyInisiatif == companyInisiatif)&&(identical(other.companyPemahaman, companyPemahaman) || other.companyPemahaman == companyPemahaman)&&(identical(other.companyKerjasamaRekan, companyKerjasamaRekan) || other.companyKerjasamaRekan == companyKerjasamaRekan)&&(identical(other.companyKerjasamaAtasan, companyKerjasamaAtasan) || other.companyKerjasamaAtasan == companyKerjasamaAtasan)&&(identical(other.companyAdaptasi, companyAdaptasi) || other.companyAdaptasi == companyAdaptasi)&&(identical(other.companySaranKritik, companySaranKritik) || other.companySaranKritik == companySaranKritik)&&(identical(other.dosenFormatLaporan, dosenFormatLaporan) || other.dosenFormatLaporan == dosenFormatLaporan)&&(identical(other.dosenUraianLaporan, dosenUraianLaporan) || other.dosenUraianLaporan == dosenUraianLaporan)&&(identical(other.dosenPresentasiLaporan, dosenPresentasiLaporan) || other.dosenPresentasiLaporan == dosenPresentasiLaporan)&&(identical(other.dosenTanyaJawabLaporan, dosenTanyaJawabLaporan) || other.dosenTanyaJawabLaporan == dosenTanyaJawabLaporan)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nim,companyKerapian,companyDisiplin,companyKehadiran,companyTanggungJawab,companyKemandirian,companyInisiatif,companyPemahaman,companyKerjasamaRekan,companyKerjasamaAtasan,companyAdaptasi,companySaranKritik,dosenFormatLaporan,dosenUraianLaporan,dosenPresentasiLaporan,dosenTanyaJawabLaporan,updatedAt,isDeleted);

@override
String toString() {
  return 'InternshipGrading(nim: $nim, companyKerapian: $companyKerapian, companyDisiplin: $companyDisiplin, companyKehadiran: $companyKehadiran, companyTanggungJawab: $companyTanggungJawab, companyKemandirian: $companyKemandirian, companyInisiatif: $companyInisiatif, companyPemahaman: $companyPemahaman, companyKerjasamaRekan: $companyKerjasamaRekan, companyKerjasamaAtasan: $companyKerjasamaAtasan, companyAdaptasi: $companyAdaptasi, companySaranKritik: $companySaranKritik, dosenFormatLaporan: $dosenFormatLaporan, dosenUraianLaporan: $dosenUraianLaporan, dosenPresentasiLaporan: $dosenPresentasiLaporan, dosenTanyaJawabLaporan: $dosenTanyaJawabLaporan, updatedAt: $updatedAt, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class _$InternshipGradingCopyWith<$Res> implements $InternshipGradingCopyWith<$Res> {
  factory _$InternshipGradingCopyWith(_InternshipGrading value, $Res Function(_InternshipGrading) _then) = __$InternshipGradingCopyWithImpl;
@override @useResult
$Res call({
 String nim, double companyKerapian, double companyDisiplin, double companyKehadiran, double companyTanggungJawab, double companyKemandirian, double companyInisiatif, double companyPemahaman, double companyKerjasamaRekan, double companyKerjasamaAtasan, double companyAdaptasi, String companySaranKritik, double dosenFormatLaporan, double dosenUraianLaporan, double dosenPresentasiLaporan, double dosenTanyaJawabLaporan, int updatedAt, bool isDeleted
});




}
/// @nodoc
class __$InternshipGradingCopyWithImpl<$Res>
    implements _$InternshipGradingCopyWith<$Res> {
  __$InternshipGradingCopyWithImpl(this._self, this._then);

  final _InternshipGrading _self;
  final $Res Function(_InternshipGrading) _then;

/// Create a copy of InternshipGrading
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nim = null,Object? companyKerapian = null,Object? companyDisiplin = null,Object? companyKehadiran = null,Object? companyTanggungJawab = null,Object? companyKemandirian = null,Object? companyInisiatif = null,Object? companyPemahaman = null,Object? companyKerjasamaRekan = null,Object? companyKerjasamaAtasan = null,Object? companyAdaptasi = null,Object? companySaranKritik = null,Object? dosenFormatLaporan = null,Object? dosenUraianLaporan = null,Object? dosenPresentasiLaporan = null,Object? dosenTanyaJawabLaporan = null,Object? updatedAt = null,Object? isDeleted = null,}) {
  return _then(_InternshipGrading(
nim: null == nim ? _self.nim : nim // ignore: cast_nullable_to_non_nullable
as String,companyKerapian: null == companyKerapian ? _self.companyKerapian : companyKerapian // ignore: cast_nullable_to_non_nullable
as double,companyDisiplin: null == companyDisiplin ? _self.companyDisiplin : companyDisiplin // ignore: cast_nullable_to_non_nullable
as double,companyKehadiran: null == companyKehadiran ? _self.companyKehadiran : companyKehadiran // ignore: cast_nullable_to_non_nullable
as double,companyTanggungJawab: null == companyTanggungJawab ? _self.companyTanggungJawab : companyTanggungJawab // ignore: cast_nullable_to_non_nullable
as double,companyKemandirian: null == companyKemandirian ? _self.companyKemandirian : companyKemandirian // ignore: cast_nullable_to_non_nullable
as double,companyInisiatif: null == companyInisiatif ? _self.companyInisiatif : companyInisiatif // ignore: cast_nullable_to_non_nullable
as double,companyPemahaman: null == companyPemahaman ? _self.companyPemahaman : companyPemahaman // ignore: cast_nullable_to_non_nullable
as double,companyKerjasamaRekan: null == companyKerjasamaRekan ? _self.companyKerjasamaRekan : companyKerjasamaRekan // ignore: cast_nullable_to_non_nullable
as double,companyKerjasamaAtasan: null == companyKerjasamaAtasan ? _self.companyKerjasamaAtasan : companyKerjasamaAtasan // ignore: cast_nullable_to_non_nullable
as double,companyAdaptasi: null == companyAdaptasi ? _self.companyAdaptasi : companyAdaptasi // ignore: cast_nullable_to_non_nullable
as double,companySaranKritik: null == companySaranKritik ? _self.companySaranKritik : companySaranKritik // ignore: cast_nullable_to_non_nullable
as String,dosenFormatLaporan: null == dosenFormatLaporan ? _self.dosenFormatLaporan : dosenFormatLaporan // ignore: cast_nullable_to_non_nullable
as double,dosenUraianLaporan: null == dosenUraianLaporan ? _self.dosenUraianLaporan : dosenUraianLaporan // ignore: cast_nullable_to_non_nullable
as double,dosenPresentasiLaporan: null == dosenPresentasiLaporan ? _self.dosenPresentasiLaporan : dosenPresentasiLaporan // ignore: cast_nullable_to_non_nullable
as double,dosenTanyaJawabLaporan: null == dosenTanyaJawabLaporan ? _self.dosenTanyaJawabLaporan : dosenTanyaJawabLaporan // ignore: cast_nullable_to_non_nullable
as double,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$JobDetail {

 String get id; String get title; String get description; bool get isCompleted; String get reasonOfIncompletion; String get imageUrl; String get date; int get updatedAt; bool get isDeleted;
/// Create a copy of JobDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobDetailCopyWith<JobDetail> get copyWith => _$JobDetailCopyWithImpl<JobDetail>(this as JobDetail, _$identity);

  /// Serializes this JobDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.reasonOfIncompletion, reasonOfIncompletion) || other.reasonOfIncompletion == reasonOfIncompletion)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.date, date) || other.date == date)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,isCompleted,reasonOfIncompletion,imageUrl,date,updatedAt,isDeleted);

@override
String toString() {
  return 'JobDetail(id: $id, title: $title, description: $description, isCompleted: $isCompleted, reasonOfIncompletion: $reasonOfIncompletion, imageUrl: $imageUrl, date: $date, updatedAt: $updatedAt, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class $JobDetailCopyWith<$Res>  {
  factory $JobDetailCopyWith(JobDetail value, $Res Function(JobDetail) _then) = _$JobDetailCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, bool isCompleted, String reasonOfIncompletion, String imageUrl, String date, int updatedAt, bool isDeleted
});




}
/// @nodoc
class _$JobDetailCopyWithImpl<$Res>
    implements $JobDetailCopyWith<$Res> {
  _$JobDetailCopyWithImpl(this._self, this._then);

  final JobDetail _self;
  final $Res Function(JobDetail) _then;

/// Create a copy of JobDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? isCompleted = null,Object? reasonOfIncompletion = null,Object? imageUrl = null,Object? date = null,Object? updatedAt = null,Object? isDeleted = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,reasonOfIncompletion: null == reasonOfIncompletion ? _self.reasonOfIncompletion : reasonOfIncompletion // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [JobDetail].
extension JobDetailPatterns on JobDetail {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobDetail() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobDetail value)  $default,){
final _that = this;
switch (_that) {
case _JobDetail():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobDetail value)?  $default,){
final _that = this;
switch (_that) {
case _JobDetail() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  bool isCompleted,  String reasonOfIncompletion,  String imageUrl,  String date,  int updatedAt,  bool isDeleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobDetail() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.isCompleted,_that.reasonOfIncompletion,_that.imageUrl,_that.date,_that.updatedAt,_that.isDeleted);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  bool isCompleted,  String reasonOfIncompletion,  String imageUrl,  String date,  int updatedAt,  bool isDeleted)  $default,) {final _that = this;
switch (_that) {
case _JobDetail():
return $default(_that.id,_that.title,_that.description,_that.isCompleted,_that.reasonOfIncompletion,_that.imageUrl,_that.date,_that.updatedAt,_that.isDeleted);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  bool isCompleted,  String reasonOfIncompletion,  String imageUrl,  String date,  int updatedAt,  bool isDeleted)?  $default,) {final _that = this;
switch (_that) {
case _JobDetail() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.isCompleted,_that.reasonOfIncompletion,_that.imageUrl,_that.date,_that.updatedAt,_that.isDeleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobDetail implements JobDetail {
  const _JobDetail({required this.id, required this.title, required this.description, this.isCompleted = false, this.reasonOfIncompletion = '', this.imageUrl = '', required this.date, this.updatedAt = 0, this.isDeleted = false});
  factory _JobDetail.fromJson(Map<String, dynamic> json) => _$JobDetailFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override@JsonKey() final  bool isCompleted;
@override@JsonKey() final  String reasonOfIncompletion;
@override@JsonKey() final  String imageUrl;
@override final  String date;
@override@JsonKey() final  int updatedAt;
@override@JsonKey() final  bool isDeleted;

/// Create a copy of JobDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobDetailCopyWith<_JobDetail> get copyWith => __$JobDetailCopyWithImpl<_JobDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.reasonOfIncompletion, reasonOfIncompletion) || other.reasonOfIncompletion == reasonOfIncompletion)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.date, date) || other.date == date)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,isCompleted,reasonOfIncompletion,imageUrl,date,updatedAt,isDeleted);

@override
String toString() {
  return 'JobDetail(id: $id, title: $title, description: $description, isCompleted: $isCompleted, reasonOfIncompletion: $reasonOfIncompletion, imageUrl: $imageUrl, date: $date, updatedAt: $updatedAt, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class _$JobDetailCopyWith<$Res> implements $JobDetailCopyWith<$Res> {
  factory _$JobDetailCopyWith(_JobDetail value, $Res Function(_JobDetail) _then) = __$JobDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, bool isCompleted, String reasonOfIncompletion, String imageUrl, String date, int updatedAt, bool isDeleted
});




}
/// @nodoc
class __$JobDetailCopyWithImpl<$Res>
    implements _$JobDetailCopyWith<$Res> {
  __$JobDetailCopyWithImpl(this._self, this._then);

  final _JobDetail _self;
  final $Res Function(_JobDetail) _then;

/// Create a copy of JobDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? isCompleted = null,Object? reasonOfIncompletion = null,Object? imageUrl = null,Object? date = null,Object? updatedAt = null,Object? isDeleted = null,}) {
  return _then(_JobDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,reasonOfIncompletion: null == reasonOfIncompletion ? _self.reasonOfIncompletion : reasonOfIncompletion // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ResearchData {

 String get companyHistory; String get companyVisionMission; String get companyStructureUrl; String get jobDescription; String get procedureWork; String get obstacles; int get updatedAt;
/// Create a copy of ResearchData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResearchDataCopyWith<ResearchData> get copyWith => _$ResearchDataCopyWithImpl<ResearchData>(this as ResearchData, _$identity);

  /// Serializes this ResearchData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResearchData&&(identical(other.companyHistory, companyHistory) || other.companyHistory == companyHistory)&&(identical(other.companyVisionMission, companyVisionMission) || other.companyVisionMission == companyVisionMission)&&(identical(other.companyStructureUrl, companyStructureUrl) || other.companyStructureUrl == companyStructureUrl)&&(identical(other.jobDescription, jobDescription) || other.jobDescription == jobDescription)&&(identical(other.procedureWork, procedureWork) || other.procedureWork == procedureWork)&&(identical(other.obstacles, obstacles) || other.obstacles == obstacles)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,companyHistory,companyVisionMission,companyStructureUrl,jobDescription,procedureWork,obstacles,updatedAt);

@override
String toString() {
  return 'ResearchData(companyHistory: $companyHistory, companyVisionMission: $companyVisionMission, companyStructureUrl: $companyStructureUrl, jobDescription: $jobDescription, procedureWork: $procedureWork, obstacles: $obstacles, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ResearchDataCopyWith<$Res>  {
  factory $ResearchDataCopyWith(ResearchData value, $Res Function(ResearchData) _then) = _$ResearchDataCopyWithImpl;
@useResult
$Res call({
 String companyHistory, String companyVisionMission, String companyStructureUrl, String jobDescription, String procedureWork, String obstacles, int updatedAt
});




}
/// @nodoc
class _$ResearchDataCopyWithImpl<$Res>
    implements $ResearchDataCopyWith<$Res> {
  _$ResearchDataCopyWithImpl(this._self, this._then);

  final ResearchData _self;
  final $Res Function(ResearchData) _then;

/// Create a copy of ResearchData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? companyHistory = null,Object? companyVisionMission = null,Object? companyStructureUrl = null,Object? jobDescription = null,Object? procedureWork = null,Object? obstacles = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
companyHistory: null == companyHistory ? _self.companyHistory : companyHistory // ignore: cast_nullable_to_non_nullable
as String,companyVisionMission: null == companyVisionMission ? _self.companyVisionMission : companyVisionMission // ignore: cast_nullable_to_non_nullable
as String,companyStructureUrl: null == companyStructureUrl ? _self.companyStructureUrl : companyStructureUrl // ignore: cast_nullable_to_non_nullable
as String,jobDescription: null == jobDescription ? _self.jobDescription : jobDescription // ignore: cast_nullable_to_non_nullable
as String,procedureWork: null == procedureWork ? _self.procedureWork : procedureWork // ignore: cast_nullable_to_non_nullable
as String,obstacles: null == obstacles ? _self.obstacles : obstacles // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ResearchData].
extension ResearchDataPatterns on ResearchData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResearchData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResearchData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResearchData value)  $default,){
final _that = this;
switch (_that) {
case _ResearchData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResearchData value)?  $default,){
final _that = this;
switch (_that) {
case _ResearchData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String companyHistory,  String companyVisionMission,  String companyStructureUrl,  String jobDescription,  String procedureWork,  String obstacles,  int updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResearchData() when $default != null:
return $default(_that.companyHistory,_that.companyVisionMission,_that.companyStructureUrl,_that.jobDescription,_that.procedureWork,_that.obstacles,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String companyHistory,  String companyVisionMission,  String companyStructureUrl,  String jobDescription,  String procedureWork,  String obstacles,  int updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ResearchData():
return $default(_that.companyHistory,_that.companyVisionMission,_that.companyStructureUrl,_that.jobDescription,_that.procedureWork,_that.obstacles,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String companyHistory,  String companyVisionMission,  String companyStructureUrl,  String jobDescription,  String procedureWork,  String obstacles,  int updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ResearchData() when $default != null:
return $default(_that.companyHistory,_that.companyVisionMission,_that.companyStructureUrl,_that.jobDescription,_that.procedureWork,_that.obstacles,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResearchData implements ResearchData {
  const _ResearchData({this.companyHistory = '', this.companyVisionMission = '', this.companyStructureUrl = '', this.jobDescription = '', this.procedureWork = '', this.obstacles = '', this.updatedAt = 0});
  factory _ResearchData.fromJson(Map<String, dynamic> json) => _$ResearchDataFromJson(json);

@override@JsonKey() final  String companyHistory;
@override@JsonKey() final  String companyVisionMission;
@override@JsonKey() final  String companyStructureUrl;
@override@JsonKey() final  String jobDescription;
@override@JsonKey() final  String procedureWork;
@override@JsonKey() final  String obstacles;
@override@JsonKey() final  int updatedAt;

/// Create a copy of ResearchData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResearchDataCopyWith<_ResearchData> get copyWith => __$ResearchDataCopyWithImpl<_ResearchData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResearchDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResearchData&&(identical(other.companyHistory, companyHistory) || other.companyHistory == companyHistory)&&(identical(other.companyVisionMission, companyVisionMission) || other.companyVisionMission == companyVisionMission)&&(identical(other.companyStructureUrl, companyStructureUrl) || other.companyStructureUrl == companyStructureUrl)&&(identical(other.jobDescription, jobDescription) || other.jobDescription == jobDescription)&&(identical(other.procedureWork, procedureWork) || other.procedureWork == procedureWork)&&(identical(other.obstacles, obstacles) || other.obstacles == obstacles)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,companyHistory,companyVisionMission,companyStructureUrl,jobDescription,procedureWork,obstacles,updatedAt);

@override
String toString() {
  return 'ResearchData(companyHistory: $companyHistory, companyVisionMission: $companyVisionMission, companyStructureUrl: $companyStructureUrl, jobDescription: $jobDescription, procedureWork: $procedureWork, obstacles: $obstacles, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ResearchDataCopyWith<$Res> implements $ResearchDataCopyWith<$Res> {
  factory _$ResearchDataCopyWith(_ResearchData value, $Res Function(_ResearchData) _then) = __$ResearchDataCopyWithImpl;
@override @useResult
$Res call({
 String companyHistory, String companyVisionMission, String companyStructureUrl, String jobDescription, String procedureWork, String obstacles, int updatedAt
});




}
/// @nodoc
class __$ResearchDataCopyWithImpl<$Res>
    implements _$ResearchDataCopyWith<$Res> {
  __$ResearchDataCopyWithImpl(this._self, this._then);

  final _ResearchData _self;
  final $Res Function(_ResearchData) _then;

/// Create a copy of ResearchData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? companyHistory = null,Object? companyVisionMission = null,Object? companyStructureUrl = null,Object? jobDescription = null,Object? procedureWork = null,Object? obstacles = null,Object? updatedAt = null,}) {
  return _then(_ResearchData(
companyHistory: null == companyHistory ? _self.companyHistory : companyHistory // ignore: cast_nullable_to_non_nullable
as String,companyVisionMission: null == companyVisionMission ? _self.companyVisionMission : companyVisionMission // ignore: cast_nullable_to_non_nullable
as String,companyStructureUrl: null == companyStructureUrl ? _self.companyStructureUrl : companyStructureUrl // ignore: cast_nullable_to_non_nullable
as String,jobDescription: null == jobDescription ? _self.jobDescription : jobDescription // ignore: cast_nullable_to_non_nullable
as String,procedureWork: null == procedureWork ? _self.procedureWork : procedureWork // ignore: cast_nullable_to_non_nullable
as String,obstacles: null == obstacles ? _self.obstacles : obstacles // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DocChecklist {

 String get id; String get title; bool get isCompleted; String get category; String get fileUrl; String get notes; int get updatedAt; bool get isDeleted;
/// Create a copy of DocChecklist
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocChecklistCopyWith<DocChecklist> get copyWith => _$DocChecklistCopyWithImpl<DocChecklist>(this as DocChecklist, _$identity);

  /// Serializes this DocChecklist to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocChecklist&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.category, category) || other.category == category)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,isCompleted,category,fileUrl,notes,updatedAt,isDeleted);

@override
String toString() {
  return 'DocChecklist(id: $id, title: $title, isCompleted: $isCompleted, category: $category, fileUrl: $fileUrl, notes: $notes, updatedAt: $updatedAt, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class $DocChecklistCopyWith<$Res>  {
  factory $DocChecklistCopyWith(DocChecklist value, $Res Function(DocChecklist) _then) = _$DocChecklistCopyWithImpl;
@useResult
$Res call({
 String id, String title, bool isCompleted, String category, String fileUrl, String notes, int updatedAt, bool isDeleted
});




}
/// @nodoc
class _$DocChecklistCopyWithImpl<$Res>
    implements $DocChecklistCopyWith<$Res> {
  _$DocChecklistCopyWithImpl(this._self, this._then);

  final DocChecklist _self;
  final $Res Function(DocChecklist) _then;

/// Create a copy of DocChecklist
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? isCompleted = null,Object? category = null,Object? fileUrl = null,Object? notes = null,Object? updatedAt = null,Object? isDeleted = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,fileUrl: null == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DocChecklist].
extension DocChecklistPatterns on DocChecklist {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocChecklist value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocChecklist() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocChecklist value)  $default,){
final _that = this;
switch (_that) {
case _DocChecklist():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocChecklist value)?  $default,){
final _that = this;
switch (_that) {
case _DocChecklist() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  bool isCompleted,  String category,  String fileUrl,  String notes,  int updatedAt,  bool isDeleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocChecklist() when $default != null:
return $default(_that.id,_that.title,_that.isCompleted,_that.category,_that.fileUrl,_that.notes,_that.updatedAt,_that.isDeleted);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  bool isCompleted,  String category,  String fileUrl,  String notes,  int updatedAt,  bool isDeleted)  $default,) {final _that = this;
switch (_that) {
case _DocChecklist():
return $default(_that.id,_that.title,_that.isCompleted,_that.category,_that.fileUrl,_that.notes,_that.updatedAt,_that.isDeleted);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  bool isCompleted,  String category,  String fileUrl,  String notes,  int updatedAt,  bool isDeleted)?  $default,) {final _that = this;
switch (_that) {
case _DocChecklist() when $default != null:
return $default(_that.id,_that.title,_that.isCompleted,_that.category,_that.fileUrl,_that.notes,_that.updatedAt,_that.isDeleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DocChecklist implements DocChecklist {
  const _DocChecklist({required this.id, required this.title, this.isCompleted = false, required this.category, this.fileUrl = '', this.notes = '', this.updatedAt = 0, this.isDeleted = false});
  factory _DocChecklist.fromJson(Map<String, dynamic> json) => _$DocChecklistFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey() final  bool isCompleted;
@override final  String category;
@override@JsonKey() final  String fileUrl;
@override@JsonKey() final  String notes;
@override@JsonKey() final  int updatedAt;
@override@JsonKey() final  bool isDeleted;

/// Create a copy of DocChecklist
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocChecklistCopyWith<_DocChecklist> get copyWith => __$DocChecklistCopyWithImpl<_DocChecklist>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocChecklistToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocChecklist&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.category, category) || other.category == category)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,isCompleted,category,fileUrl,notes,updatedAt,isDeleted);

@override
String toString() {
  return 'DocChecklist(id: $id, title: $title, isCompleted: $isCompleted, category: $category, fileUrl: $fileUrl, notes: $notes, updatedAt: $updatedAt, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class _$DocChecklistCopyWith<$Res> implements $DocChecklistCopyWith<$Res> {
  factory _$DocChecklistCopyWith(_DocChecklist value, $Res Function(_DocChecklist) _then) = __$DocChecklistCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, bool isCompleted, String category, String fileUrl, String notes, int updatedAt, bool isDeleted
});




}
/// @nodoc
class __$DocChecklistCopyWithImpl<$Res>
    implements _$DocChecklistCopyWith<$Res> {
  __$DocChecklistCopyWithImpl(this._self, this._then);

  final _DocChecklist _self;
  final $Res Function(_DocChecklist) _then;

/// Create a copy of DocChecklist
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? isCompleted = null,Object? category = null,Object? fileUrl = null,Object? notes = null,Object? updatedAt = null,Object? isDeleted = null,}) {
  return _then(_DocChecklist(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,fileUrl: null == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$SyncState {

 SyncStatusType get status; String get message; DateTime? get lastSynced;
/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncStateCopyWith<SyncState> get copyWith => _$SyncStateCopyWithImpl<SyncState>(this as SyncState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncState&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.lastSynced, lastSynced) || other.lastSynced == lastSynced));
}


@override
int get hashCode => Object.hash(runtimeType,status,message,lastSynced);

@override
String toString() {
  return 'SyncState(status: $status, message: $message, lastSynced: $lastSynced)';
}


}

/// @nodoc
abstract mixin class $SyncStateCopyWith<$Res>  {
  factory $SyncStateCopyWith(SyncState value, $Res Function(SyncState) _then) = _$SyncStateCopyWithImpl;
@useResult
$Res call({
 SyncStatusType status, String message, DateTime? lastSynced
});




}
/// @nodoc
class _$SyncStateCopyWithImpl<$Res>
    implements $SyncStateCopyWith<$Res> {
  _$SyncStateCopyWithImpl(this._self, this._then);

  final SyncState _self;
  final $Res Function(SyncState) _then;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? message = null,Object? lastSynced = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SyncStatusType,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,lastSynced: freezed == lastSynced ? _self.lastSynced : lastSynced // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncState].
extension SyncStatePatterns on SyncState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncState value)  $default,){
final _that = this;
switch (_that) {
case _SyncState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncState value)?  $default,){
final _that = this;
switch (_that) {
case _SyncState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SyncStatusType status,  String message,  DateTime? lastSynced)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncState() when $default != null:
return $default(_that.status,_that.message,_that.lastSynced);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SyncStatusType status,  String message,  DateTime? lastSynced)  $default,) {final _that = this;
switch (_that) {
case _SyncState():
return $default(_that.status,_that.message,_that.lastSynced);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SyncStatusType status,  String message,  DateTime? lastSynced)?  $default,) {final _that = this;
switch (_that) {
case _SyncState() when $default != null:
return $default(_that.status,_that.message,_that.lastSynced);case _:
  return null;

}
}

}

/// @nodoc


class _SyncState implements SyncState {
  const _SyncState({this.status = SyncStatusType.idle, this.message = 'Sistem Siap', this.lastSynced});
  

@override@JsonKey() final  SyncStatusType status;
@override@JsonKey() final  String message;
@override final  DateTime? lastSynced;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncStateCopyWith<_SyncState> get copyWith => __$SyncStateCopyWithImpl<_SyncState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncState&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.lastSynced, lastSynced) || other.lastSynced == lastSynced));
}


@override
int get hashCode => Object.hash(runtimeType,status,message,lastSynced);

@override
String toString() {
  return 'SyncState(status: $status, message: $message, lastSynced: $lastSynced)';
}


}

/// @nodoc
abstract mixin class _$SyncStateCopyWith<$Res> implements $SyncStateCopyWith<$Res> {
  factory _$SyncStateCopyWith(_SyncState value, $Res Function(_SyncState) _then) = __$SyncStateCopyWithImpl;
@override @useResult
$Res call({
 SyncStatusType status, String message, DateTime? lastSynced
});




}
/// @nodoc
class __$SyncStateCopyWithImpl<$Res>
    implements _$SyncStateCopyWith<$Res> {
  __$SyncStateCopyWithImpl(this._self, this._then);

  final _SyncState _self;
  final $Res Function(_SyncState) _then;

/// Create a copy of SyncState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? message = null,Object? lastSynced = freezed,}) {
  return _then(_SyncState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SyncStatusType,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,lastSynced: freezed == lastSynced ? _self.lastSynced : lastSynced // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
