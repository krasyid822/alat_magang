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

 String get nim; String get name; String get className; String get major; String get companyName; int get internshipDurationWeeks;
/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentProfileCopyWith<StudentProfile> get copyWith => _$StudentProfileCopyWithImpl<StudentProfile>(this as StudentProfile, _$identity);

  /// Serializes this StudentProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentProfile&&(identical(other.nim, nim) || other.nim == nim)&&(identical(other.name, name) || other.name == name)&&(identical(other.className, className) || other.className == className)&&(identical(other.major, major) || other.major == major)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.internshipDurationWeeks, internshipDurationWeeks) || other.internshipDurationWeeks == internshipDurationWeeks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nim,name,className,major,companyName,internshipDurationWeeks);

@override
String toString() {
  return 'StudentProfile(nim: $nim, name: $name, className: $className, major: $major, companyName: $companyName, internshipDurationWeeks: $internshipDurationWeeks)';
}


}

/// @nodoc
abstract mixin class $StudentProfileCopyWith<$Res>  {
  factory $StudentProfileCopyWith(StudentProfile value, $Res Function(StudentProfile) _then) = _$StudentProfileCopyWithImpl;
@useResult
$Res call({
 String nim, String name, String className, String major, String companyName, int internshipDurationWeeks
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
@pragma('vm:prefer-inline') @override $Res call({Object? nim = null,Object? name = null,Object? className = null,Object? major = null,Object? companyName = null,Object? internshipDurationWeeks = null,}) {
  return _then(_self.copyWith(
nim: null == nim ? _self.nim : nim // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,className: null == className ? _self.className : className // ignore: cast_nullable_to_non_nullable
as String,major: null == major ? _self.major : major // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,internshipDurationWeeks: null == internshipDurationWeeks ? _self.internshipDurationWeeks : internshipDurationWeeks // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nim,  String name,  String className,  String major,  String companyName,  int internshipDurationWeeks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentProfile() when $default != null:
return $default(_that.nim,_that.name,_that.className,_that.major,_that.companyName,_that.internshipDurationWeeks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nim,  String name,  String className,  String major,  String companyName,  int internshipDurationWeeks)  $default,) {final _that = this;
switch (_that) {
case _StudentProfile():
return $default(_that.nim,_that.name,_that.className,_that.major,_that.companyName,_that.internshipDurationWeeks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nim,  String name,  String className,  String major,  String companyName,  int internshipDurationWeeks)?  $default,) {final _that = this;
switch (_that) {
case _StudentProfile() when $default != null:
return $default(_that.nim,_that.name,_that.className,_that.major,_that.companyName,_that.internshipDurationWeeks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudentProfile implements StudentProfile {
  const _StudentProfile({required this.nim, this.name = '', this.className = '', this.major = '', this.companyName = '', this.internshipDurationWeeks = 16});
  factory _StudentProfile.fromJson(Map<String, dynamic> json) => _$StudentProfileFromJson(json);

@override final  String nim;
@override@JsonKey() final  String name;
@override@JsonKey() final  String className;
@override@JsonKey() final  String major;
@override@JsonKey() final  String companyName;
@override@JsonKey() final  int internshipDurationWeeks;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentProfile&&(identical(other.nim, nim) || other.nim == nim)&&(identical(other.name, name) || other.name == name)&&(identical(other.className, className) || other.className == className)&&(identical(other.major, major) || other.major == major)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.internshipDurationWeeks, internshipDurationWeeks) || other.internshipDurationWeeks == internshipDurationWeeks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nim,name,className,major,companyName,internshipDurationWeeks);

@override
String toString() {
  return 'StudentProfile(nim: $nim, name: $name, className: $className, major: $major, companyName: $companyName, internshipDurationWeeks: $internshipDurationWeeks)';
}


}

/// @nodoc
abstract mixin class _$StudentProfileCopyWith<$Res> implements $StudentProfileCopyWith<$Res> {
  factory _$StudentProfileCopyWith(_StudentProfile value, $Res Function(_StudentProfile) _then) = __$StudentProfileCopyWithImpl;
@override @useResult
$Res call({
 String nim, String name, String className, String major, String companyName, int internshipDurationWeeks
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
@override @pragma('vm:prefer-inline') $Res call({Object? nim = null,Object? name = null,Object? className = null,Object? major = null,Object? companyName = null,Object? internshipDurationWeeks = null,}) {
  return _then(_StudentProfile(
nim: null == nim ? _self.nim : nim // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,className: null == className ? _self.className : className // ignore: cast_nullable_to_non_nullable
as String,major: null == major ? _self.major : major // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,internshipDurationWeeks: null == internshipDurationWeeks ? _self.internshipDurationWeeks : internshipDurationWeeks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$InternshipLog {

 String get id; String get date; String get activity; String get startTime; String get endTime; bool get isSigned; int get weekNumber; String get signatureData; String get versionHistory;
/// Create a copy of InternshipLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InternshipLogCopyWith<InternshipLog> get copyWith => _$InternshipLogCopyWithImpl<InternshipLog>(this as InternshipLog, _$identity);

  /// Serializes this InternshipLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InternshipLog&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isSigned, isSigned) || other.isSigned == isSigned)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.signatureData, signatureData) || other.signatureData == signatureData)&&(identical(other.versionHistory, versionHistory) || other.versionHistory == versionHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,activity,startTime,endTime,isSigned,weekNumber,signatureData,versionHistory);

@override
String toString() {
  return 'InternshipLog(id: $id, date: $date, activity: $activity, startTime: $startTime, endTime: $endTime, isSigned: $isSigned, weekNumber: $weekNumber, signatureData: $signatureData, versionHistory: $versionHistory)';
}


}

/// @nodoc
abstract mixin class $InternshipLogCopyWith<$Res>  {
  factory $InternshipLogCopyWith(InternshipLog value, $Res Function(InternshipLog) _then) = _$InternshipLogCopyWithImpl;
@useResult
$Res call({
 String id, String date, String activity, String startTime, String endTime, bool isSigned, int weekNumber, String signatureData, String versionHistory
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? activity = null,Object? startTime = null,Object? endTime = null,Object? isSigned = null,Object? weekNumber = null,Object? signatureData = null,Object? versionHistory = null,}) {
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
as String,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String date,  String activity,  String startTime,  String endTime,  bool isSigned,  int weekNumber,  String signatureData,  String versionHistory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InternshipLog() when $default != null:
return $default(_that.id,_that.date,_that.activity,_that.startTime,_that.endTime,_that.isSigned,_that.weekNumber,_that.signatureData,_that.versionHistory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String date,  String activity,  String startTime,  String endTime,  bool isSigned,  int weekNumber,  String signatureData,  String versionHistory)  $default,) {final _that = this;
switch (_that) {
case _InternshipLog():
return $default(_that.id,_that.date,_that.activity,_that.startTime,_that.endTime,_that.isSigned,_that.weekNumber,_that.signatureData,_that.versionHistory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String date,  String activity,  String startTime,  String endTime,  bool isSigned,  int weekNumber,  String signatureData,  String versionHistory)?  $default,) {final _that = this;
switch (_that) {
case _InternshipLog() when $default != null:
return $default(_that.id,_that.date,_that.activity,_that.startTime,_that.endTime,_that.isSigned,_that.weekNumber,_that.signatureData,_that.versionHistory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InternshipLog implements InternshipLog {
  const _InternshipLog({required this.id, required this.date, required this.activity, required this.startTime, required this.endTime, this.isSigned = false, required this.weekNumber, this.signatureData = '', this.versionHistory = ''});
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InternshipLog&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isSigned, isSigned) || other.isSigned == isSigned)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.signatureData, signatureData) || other.signatureData == signatureData)&&(identical(other.versionHistory, versionHistory) || other.versionHistory == versionHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,activity,startTime,endTime,isSigned,weekNumber,signatureData,versionHistory);

@override
String toString() {
  return 'InternshipLog(id: $id, date: $date, activity: $activity, startTime: $startTime, endTime: $endTime, isSigned: $isSigned, weekNumber: $weekNumber, signatureData: $signatureData, versionHistory: $versionHistory)';
}


}

/// @nodoc
abstract mixin class _$InternshipLogCopyWith<$Res> implements $InternshipLogCopyWith<$Res> {
  factory _$InternshipLogCopyWith(_InternshipLog value, $Res Function(_InternshipLog) _then) = __$InternshipLogCopyWithImpl;
@override @useResult
$Res call({
 String id, String date, String activity, String startTime, String endTime, bool isSigned, int weekNumber, String signatureData, String versionHistory
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? activity = null,Object? startTime = null,Object? endTime = null,Object? isSigned = null,Object? weekNumber = null,Object? signatureData = null,Object? versionHistory = null,}) {
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
as String,
  ));
}


}


/// @nodoc
mixin _$JobDetail {

 String get id; String get title; String get description; bool get isCompleted; String get reasonOfIncompletion; String get imageUrl; String get date;
/// Create a copy of JobDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobDetailCopyWith<JobDetail> get copyWith => _$JobDetailCopyWithImpl<JobDetail>(this as JobDetail, _$identity);

  /// Serializes this JobDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.reasonOfIncompletion, reasonOfIncompletion) || other.reasonOfIncompletion == reasonOfIncompletion)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,isCompleted,reasonOfIncompletion,imageUrl,date);

@override
String toString() {
  return 'JobDetail(id: $id, title: $title, description: $description, isCompleted: $isCompleted, reasonOfIncompletion: $reasonOfIncompletion, imageUrl: $imageUrl, date: $date)';
}


}

/// @nodoc
abstract mixin class $JobDetailCopyWith<$Res>  {
  factory $JobDetailCopyWith(JobDetail value, $Res Function(JobDetail) _then) = _$JobDetailCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, bool isCompleted, String reasonOfIncompletion, String imageUrl, String date
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? isCompleted = null,Object? reasonOfIncompletion = null,Object? imageUrl = null,Object? date = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,reasonOfIncompletion: null == reasonOfIncompletion ? _self.reasonOfIncompletion : reasonOfIncompletion // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  bool isCompleted,  String reasonOfIncompletion,  String imageUrl,  String date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobDetail() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.isCompleted,_that.reasonOfIncompletion,_that.imageUrl,_that.date);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  bool isCompleted,  String reasonOfIncompletion,  String imageUrl,  String date)  $default,) {final _that = this;
switch (_that) {
case _JobDetail():
return $default(_that.id,_that.title,_that.description,_that.isCompleted,_that.reasonOfIncompletion,_that.imageUrl,_that.date);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  bool isCompleted,  String reasonOfIncompletion,  String imageUrl,  String date)?  $default,) {final _that = this;
switch (_that) {
case _JobDetail() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.isCompleted,_that.reasonOfIncompletion,_that.imageUrl,_that.date);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobDetail implements JobDetail {
  const _JobDetail({required this.id, required this.title, required this.description, this.isCompleted = false, this.reasonOfIncompletion = '', this.imageUrl = '', required this.date});
  factory _JobDetail.fromJson(Map<String, dynamic> json) => _$JobDetailFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override@JsonKey() final  bool isCompleted;
@override@JsonKey() final  String reasonOfIncompletion;
@override@JsonKey() final  String imageUrl;
@override final  String date;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.reasonOfIncompletion, reasonOfIncompletion) || other.reasonOfIncompletion == reasonOfIncompletion)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,isCompleted,reasonOfIncompletion,imageUrl,date);

@override
String toString() {
  return 'JobDetail(id: $id, title: $title, description: $description, isCompleted: $isCompleted, reasonOfIncompletion: $reasonOfIncompletion, imageUrl: $imageUrl, date: $date)';
}


}

/// @nodoc
abstract mixin class _$JobDetailCopyWith<$Res> implements $JobDetailCopyWith<$Res> {
  factory _$JobDetailCopyWith(_JobDetail value, $Res Function(_JobDetail) _then) = __$JobDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, bool isCompleted, String reasonOfIncompletion, String imageUrl, String date
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? isCompleted = null,Object? reasonOfIncompletion = null,Object? imageUrl = null,Object? date = null,}) {
  return _then(_JobDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,reasonOfIncompletion: null == reasonOfIncompletion ? _self.reasonOfIncompletion : reasonOfIncompletion // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ResearchData {

 String get companyHistory; String get companyVisionMission; String get companyStructureUrl; String get jobDescription; String get procedureWork; String get obstacles;
/// Create a copy of ResearchData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResearchDataCopyWith<ResearchData> get copyWith => _$ResearchDataCopyWithImpl<ResearchData>(this as ResearchData, _$identity);

  /// Serializes this ResearchData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResearchData&&(identical(other.companyHistory, companyHistory) || other.companyHistory == companyHistory)&&(identical(other.companyVisionMission, companyVisionMission) || other.companyVisionMission == companyVisionMission)&&(identical(other.companyStructureUrl, companyStructureUrl) || other.companyStructureUrl == companyStructureUrl)&&(identical(other.jobDescription, jobDescription) || other.jobDescription == jobDescription)&&(identical(other.procedureWork, procedureWork) || other.procedureWork == procedureWork)&&(identical(other.obstacles, obstacles) || other.obstacles == obstacles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,companyHistory,companyVisionMission,companyStructureUrl,jobDescription,procedureWork,obstacles);

@override
String toString() {
  return 'ResearchData(companyHistory: $companyHistory, companyVisionMission: $companyVisionMission, companyStructureUrl: $companyStructureUrl, jobDescription: $jobDescription, procedureWork: $procedureWork, obstacles: $obstacles)';
}


}

/// @nodoc
abstract mixin class $ResearchDataCopyWith<$Res>  {
  factory $ResearchDataCopyWith(ResearchData value, $Res Function(ResearchData) _then) = _$ResearchDataCopyWithImpl;
@useResult
$Res call({
 String companyHistory, String companyVisionMission, String companyStructureUrl, String jobDescription, String procedureWork, String obstacles
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
@pragma('vm:prefer-inline') @override $Res call({Object? companyHistory = null,Object? companyVisionMission = null,Object? companyStructureUrl = null,Object? jobDescription = null,Object? procedureWork = null,Object? obstacles = null,}) {
  return _then(_self.copyWith(
companyHistory: null == companyHistory ? _self.companyHistory : companyHistory // ignore: cast_nullable_to_non_nullable
as String,companyVisionMission: null == companyVisionMission ? _self.companyVisionMission : companyVisionMission // ignore: cast_nullable_to_non_nullable
as String,companyStructureUrl: null == companyStructureUrl ? _self.companyStructureUrl : companyStructureUrl // ignore: cast_nullable_to_non_nullable
as String,jobDescription: null == jobDescription ? _self.jobDescription : jobDescription // ignore: cast_nullable_to_non_nullable
as String,procedureWork: null == procedureWork ? _self.procedureWork : procedureWork // ignore: cast_nullable_to_non_nullable
as String,obstacles: null == obstacles ? _self.obstacles : obstacles // ignore: cast_nullable_to_non_nullable
as String,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String companyHistory,  String companyVisionMission,  String companyStructureUrl,  String jobDescription,  String procedureWork,  String obstacles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResearchData() when $default != null:
return $default(_that.companyHistory,_that.companyVisionMission,_that.companyStructureUrl,_that.jobDescription,_that.procedureWork,_that.obstacles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String companyHistory,  String companyVisionMission,  String companyStructureUrl,  String jobDescription,  String procedureWork,  String obstacles)  $default,) {final _that = this;
switch (_that) {
case _ResearchData():
return $default(_that.companyHistory,_that.companyVisionMission,_that.companyStructureUrl,_that.jobDescription,_that.procedureWork,_that.obstacles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String companyHistory,  String companyVisionMission,  String companyStructureUrl,  String jobDescription,  String procedureWork,  String obstacles)?  $default,) {final _that = this;
switch (_that) {
case _ResearchData() when $default != null:
return $default(_that.companyHistory,_that.companyVisionMission,_that.companyStructureUrl,_that.jobDescription,_that.procedureWork,_that.obstacles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResearchData implements ResearchData {
  const _ResearchData({this.companyHistory = '', this.companyVisionMission = '', this.companyStructureUrl = '', this.jobDescription = '', this.procedureWork = '', this.obstacles = ''});
  factory _ResearchData.fromJson(Map<String, dynamic> json) => _$ResearchDataFromJson(json);

@override@JsonKey() final  String companyHistory;
@override@JsonKey() final  String companyVisionMission;
@override@JsonKey() final  String companyStructureUrl;
@override@JsonKey() final  String jobDescription;
@override@JsonKey() final  String procedureWork;
@override@JsonKey() final  String obstacles;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResearchData&&(identical(other.companyHistory, companyHistory) || other.companyHistory == companyHistory)&&(identical(other.companyVisionMission, companyVisionMission) || other.companyVisionMission == companyVisionMission)&&(identical(other.companyStructureUrl, companyStructureUrl) || other.companyStructureUrl == companyStructureUrl)&&(identical(other.jobDescription, jobDescription) || other.jobDescription == jobDescription)&&(identical(other.procedureWork, procedureWork) || other.procedureWork == procedureWork)&&(identical(other.obstacles, obstacles) || other.obstacles == obstacles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,companyHistory,companyVisionMission,companyStructureUrl,jobDescription,procedureWork,obstacles);

@override
String toString() {
  return 'ResearchData(companyHistory: $companyHistory, companyVisionMission: $companyVisionMission, companyStructureUrl: $companyStructureUrl, jobDescription: $jobDescription, procedureWork: $procedureWork, obstacles: $obstacles)';
}


}

/// @nodoc
abstract mixin class _$ResearchDataCopyWith<$Res> implements $ResearchDataCopyWith<$Res> {
  factory _$ResearchDataCopyWith(_ResearchData value, $Res Function(_ResearchData) _then) = __$ResearchDataCopyWithImpl;
@override @useResult
$Res call({
 String companyHistory, String companyVisionMission, String companyStructureUrl, String jobDescription, String procedureWork, String obstacles
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
@override @pragma('vm:prefer-inline') $Res call({Object? companyHistory = null,Object? companyVisionMission = null,Object? companyStructureUrl = null,Object? jobDescription = null,Object? procedureWork = null,Object? obstacles = null,}) {
  return _then(_ResearchData(
companyHistory: null == companyHistory ? _self.companyHistory : companyHistory // ignore: cast_nullable_to_non_nullable
as String,companyVisionMission: null == companyVisionMission ? _self.companyVisionMission : companyVisionMission // ignore: cast_nullable_to_non_nullable
as String,companyStructureUrl: null == companyStructureUrl ? _self.companyStructureUrl : companyStructureUrl // ignore: cast_nullable_to_non_nullable
as String,jobDescription: null == jobDescription ? _self.jobDescription : jobDescription // ignore: cast_nullable_to_non_nullable
as String,procedureWork: null == procedureWork ? _self.procedureWork : procedureWork // ignore: cast_nullable_to_non_nullable
as String,obstacles: null == obstacles ? _self.obstacles : obstacles // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DocChecklist {

 String get id; String get title; bool get isCompleted; String get category; String get fileUrl; String get notes;
/// Create a copy of DocChecklist
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocChecklistCopyWith<DocChecklist> get copyWith => _$DocChecklistCopyWithImpl<DocChecklist>(this as DocChecklist, _$identity);

  /// Serializes this DocChecklist to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocChecklist&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.category, category) || other.category == category)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,isCompleted,category,fileUrl,notes);

@override
String toString() {
  return 'DocChecklist(id: $id, title: $title, isCompleted: $isCompleted, category: $category, fileUrl: $fileUrl, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $DocChecklistCopyWith<$Res>  {
  factory $DocChecklistCopyWith(DocChecklist value, $Res Function(DocChecklist) _then) = _$DocChecklistCopyWithImpl;
@useResult
$Res call({
 String id, String title, bool isCompleted, String category, String fileUrl, String notes
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? isCompleted = null,Object? category = null,Object? fileUrl = null,Object? notes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,fileUrl: null == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  bool isCompleted,  String category,  String fileUrl,  String notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocChecklist() when $default != null:
return $default(_that.id,_that.title,_that.isCompleted,_that.category,_that.fileUrl,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  bool isCompleted,  String category,  String fileUrl,  String notes)  $default,) {final _that = this;
switch (_that) {
case _DocChecklist():
return $default(_that.id,_that.title,_that.isCompleted,_that.category,_that.fileUrl,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  bool isCompleted,  String category,  String fileUrl,  String notes)?  $default,) {final _that = this;
switch (_that) {
case _DocChecklist() when $default != null:
return $default(_that.id,_that.title,_that.isCompleted,_that.category,_that.fileUrl,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DocChecklist implements DocChecklist {
  const _DocChecklist({required this.id, required this.title, this.isCompleted = false, required this.category, this.fileUrl = '', this.notes = ''});
  factory _DocChecklist.fromJson(Map<String, dynamic> json) => _$DocChecklistFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey() final  bool isCompleted;
@override final  String category;
@override@JsonKey() final  String fileUrl;
@override@JsonKey() final  String notes;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocChecklist&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.category, category) || other.category == category)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,isCompleted,category,fileUrl,notes);

@override
String toString() {
  return 'DocChecklist(id: $id, title: $title, isCompleted: $isCompleted, category: $category, fileUrl: $fileUrl, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$DocChecklistCopyWith<$Res> implements $DocChecklistCopyWith<$Res> {
  factory _$DocChecklistCopyWith(_DocChecklist value, $Res Function(_DocChecklist) _then) = __$DocChecklistCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, bool isCompleted, String category, String fileUrl, String notes
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? isCompleted = null,Object? category = null,Object? fileUrl = null,Object? notes = null,}) {
  return _then(_DocChecklist(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,fileUrl: null == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
