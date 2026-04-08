// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppNotifications {

@JsonKey(name: uuidColName) String get uuid;@JsonKey(name: "title") String get title;@JsonKey(name: "description") String get description;// Use NotificationType.*.name instead of normal Strings for accurate results
@JsonKey(name: "notification_type") String get notificationType;@JsonKey(name: "is_alert_message") bool get isAlertMessage;@JsonKey(name: "has_read") bool get hasRead;@JsonKey(name: "link_to_page") String get linkToPage;@JsonKey(name: "scheduled_at") DateTime get scheduledAt;@JsonKey(name: "created_at") DateTime get createdAt;
/// Create a copy of AppNotifications
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppNotificationsCopyWith<AppNotifications> get copyWith => _$AppNotificationsCopyWithImpl<AppNotifications>(this as AppNotifications, _$identity);

  /// Serializes this AppNotifications to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppNotifications&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.notificationType, notificationType) || other.notificationType == notificationType)&&(identical(other.isAlertMessage, isAlertMessage) || other.isAlertMessage == isAlertMessage)&&(identical(other.hasRead, hasRead) || other.hasRead == hasRead)&&(identical(other.linkToPage, linkToPage) || other.linkToPage == linkToPage)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,title,description,notificationType,isAlertMessage,hasRead,linkToPage,scheduledAt,createdAt);

@override
String toString() {
  return 'AppNotifications(uuid: $uuid, title: $title, description: $description, notificationType: $notificationType, isAlertMessage: $isAlertMessage, hasRead: $hasRead, linkToPage: $linkToPage, scheduledAt: $scheduledAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AppNotificationsCopyWith<$Res>  {
  factory $AppNotificationsCopyWith(AppNotifications value, $Res Function(AppNotifications) _then) = _$AppNotificationsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: uuidColName) String uuid,@JsonKey(name: "title") String title,@JsonKey(name: "description") String description,@JsonKey(name: "notification_type") String notificationType,@JsonKey(name: "is_alert_message") bool isAlertMessage,@JsonKey(name: "has_read") bool hasRead,@JsonKey(name: "link_to_page") String linkToPage,@JsonKey(name: "scheduled_at") DateTime scheduledAt,@JsonKey(name: "created_at") DateTime createdAt
});




}
/// @nodoc
class _$AppNotificationsCopyWithImpl<$Res>
    implements $AppNotificationsCopyWith<$Res> {
  _$AppNotificationsCopyWithImpl(this._self, this._then);

  final AppNotifications _self;
  final $Res Function(AppNotifications) _then;

/// Create a copy of AppNotifications
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uuid = null,Object? title = null,Object? description = null,Object? notificationType = null,Object? isAlertMessage = null,Object? hasRead = null,Object? linkToPage = null,Object? scheduledAt = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,notificationType: null == notificationType ? _self.notificationType : notificationType // ignore: cast_nullable_to_non_nullable
as String,isAlertMessage: null == isAlertMessage ? _self.isAlertMessage : isAlertMessage // ignore: cast_nullable_to_non_nullable
as bool,hasRead: null == hasRead ? _self.hasRead : hasRead // ignore: cast_nullable_to_non_nullable
as bool,linkToPage: null == linkToPage ? _self.linkToPage : linkToPage // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AppNotifications].
extension AppNotificationsPatterns on AppNotifications {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppNotifications value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppNotifications() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppNotifications value)  $default,){
final _that = this;
switch (_that) {
case _AppNotifications():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppNotifications value)?  $default,){
final _that = this;
switch (_that) {
case _AppNotifications() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: uuidColName)  String uuid, @JsonKey(name: "title")  String title, @JsonKey(name: "description")  String description, @JsonKey(name: "notification_type")  String notificationType, @JsonKey(name: "is_alert_message")  bool isAlertMessage, @JsonKey(name: "has_read")  bool hasRead, @JsonKey(name: "link_to_page")  String linkToPage, @JsonKey(name: "scheduled_at")  DateTime scheduledAt, @JsonKey(name: "created_at")  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppNotifications() when $default != null:
return $default(_that.uuid,_that.title,_that.description,_that.notificationType,_that.isAlertMessage,_that.hasRead,_that.linkToPage,_that.scheduledAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: uuidColName)  String uuid, @JsonKey(name: "title")  String title, @JsonKey(name: "description")  String description, @JsonKey(name: "notification_type")  String notificationType, @JsonKey(name: "is_alert_message")  bool isAlertMessage, @JsonKey(name: "has_read")  bool hasRead, @JsonKey(name: "link_to_page")  String linkToPage, @JsonKey(name: "scheduled_at")  DateTime scheduledAt, @JsonKey(name: "created_at")  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AppNotifications():
return $default(_that.uuid,_that.title,_that.description,_that.notificationType,_that.isAlertMessage,_that.hasRead,_that.linkToPage,_that.scheduledAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: uuidColName)  String uuid, @JsonKey(name: "title")  String title, @JsonKey(name: "description")  String description, @JsonKey(name: "notification_type")  String notificationType, @JsonKey(name: "is_alert_message")  bool isAlertMessage, @JsonKey(name: "has_read")  bool hasRead, @JsonKey(name: "link_to_page")  String linkToPage, @JsonKey(name: "scheduled_at")  DateTime scheduledAt, @JsonKey(name: "created_at")  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AppNotifications() when $default != null:
return $default(_that.uuid,_that.title,_that.description,_that.notificationType,_that.isAlertMessage,_that.hasRead,_that.linkToPage,_that.scheduledAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppNotifications extends AppNotifications {
  const _AppNotifications({@JsonKey(name: uuidColName) required this.uuid, @JsonKey(name: "title") required this.title, @JsonKey(name: "description") required this.description, @JsonKey(name: "notification_type") required this.notificationType, @JsonKey(name: "is_alert_message") required this.isAlertMessage, @JsonKey(name: "has_read") required this.hasRead, @JsonKey(name: "link_to_page") required this.linkToPage, @JsonKey(name: "scheduled_at") required this.scheduledAt, @JsonKey(name: "created_at") required this.createdAt}): super._();
  factory _AppNotifications.fromJson(Map<String, dynamic> json) => _$AppNotificationsFromJson(json);

@override@JsonKey(name: uuidColName) final  String uuid;
@override@JsonKey(name: "title") final  String title;
@override@JsonKey(name: "description") final  String description;
// Use NotificationType.*.name instead of normal Strings for accurate results
@override@JsonKey(name: "notification_type") final  String notificationType;
@override@JsonKey(name: "is_alert_message") final  bool isAlertMessage;
@override@JsonKey(name: "has_read") final  bool hasRead;
@override@JsonKey(name: "link_to_page") final  String linkToPage;
@override@JsonKey(name: "scheduled_at") final  DateTime scheduledAt;
@override@JsonKey(name: "created_at") final  DateTime createdAt;

/// Create a copy of AppNotifications
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppNotificationsCopyWith<_AppNotifications> get copyWith => __$AppNotificationsCopyWithImpl<_AppNotifications>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppNotificationsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppNotifications&&(identical(other.uuid, uuid) || other.uuid == uuid)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.notificationType, notificationType) || other.notificationType == notificationType)&&(identical(other.isAlertMessage, isAlertMessage) || other.isAlertMessage == isAlertMessage)&&(identical(other.hasRead, hasRead) || other.hasRead == hasRead)&&(identical(other.linkToPage, linkToPage) || other.linkToPage == linkToPage)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uuid,title,description,notificationType,isAlertMessage,hasRead,linkToPage,scheduledAt,createdAt);

@override
String toString() {
  return 'AppNotifications(uuid: $uuid, title: $title, description: $description, notificationType: $notificationType, isAlertMessage: $isAlertMessage, hasRead: $hasRead, linkToPage: $linkToPage, scheduledAt: $scheduledAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AppNotificationsCopyWith<$Res> implements $AppNotificationsCopyWith<$Res> {
  factory _$AppNotificationsCopyWith(_AppNotifications value, $Res Function(_AppNotifications) _then) = __$AppNotificationsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: uuidColName) String uuid,@JsonKey(name: "title") String title,@JsonKey(name: "description") String description,@JsonKey(name: "notification_type") String notificationType,@JsonKey(name: "is_alert_message") bool isAlertMessage,@JsonKey(name: "has_read") bool hasRead,@JsonKey(name: "link_to_page") String linkToPage,@JsonKey(name: "scheduled_at") DateTime scheduledAt,@JsonKey(name: "created_at") DateTime createdAt
});




}
/// @nodoc
class __$AppNotificationsCopyWithImpl<$Res>
    implements _$AppNotificationsCopyWith<$Res> {
  __$AppNotificationsCopyWithImpl(this._self, this._then);

  final _AppNotifications _self;
  final $Res Function(_AppNotifications) _then;

/// Create a copy of AppNotifications
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uuid = null,Object? title = null,Object? description = null,Object? notificationType = null,Object? isAlertMessage = null,Object? hasRead = null,Object? linkToPage = null,Object? scheduledAt = null,Object? createdAt = null,}) {
  return _then(_AppNotifications(
uuid: null == uuid ? _self.uuid : uuid // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,notificationType: null == notificationType ? _self.notificationType : notificationType // ignore: cast_nullable_to_non_nullable
as String,isAlertMessage: null == isAlertMessage ? _self.isAlertMessage : isAlertMessage // ignore: cast_nullable_to_non_nullable
as bool,hasRead: null == hasRead ? _self.hasRead : hasRead // ignore: cast_nullable_to_non_nullable
as bool,linkToPage: null == linkToPage ? _self.linkToPage : linkToPage // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
