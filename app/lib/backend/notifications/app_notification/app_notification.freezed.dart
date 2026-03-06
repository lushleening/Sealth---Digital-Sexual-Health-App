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

 IconData get icon;// JSON converter or sth
 String get title; String get description; bool get alert; bool get read; MainPageRoute get linkToPageMainIndex; Widget? get linkToPageSub;// TODO give me a way to display your pages
 DateTime? get pushDateTime;// TODO
 String get pushTarget;
/// Create a copy of AppNotifications
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppNotificationsCopyWith<AppNotifications> get copyWith => _$AppNotificationsCopyWithImpl<AppNotifications>(this as AppNotifications, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppNotifications&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.alert, alert) || other.alert == alert)&&(identical(other.read, read) || other.read == read)&&(identical(other.linkToPageMainIndex, linkToPageMainIndex) || other.linkToPageMainIndex == linkToPageMainIndex)&&(identical(other.linkToPageSub, linkToPageSub) || other.linkToPageSub == linkToPageSub)&&(identical(other.pushDateTime, pushDateTime) || other.pushDateTime == pushDateTime)&&(identical(other.pushTarget, pushTarget) || other.pushTarget == pushTarget));
}


@override
int get hashCode => Object.hash(runtimeType,icon,title,description,alert,read,linkToPageMainIndex,linkToPageSub,pushDateTime,pushTarget);

@override
String toString() {
  return 'AppNotifications(icon: $icon, title: $title, description: $description, alert: $alert, read: $read, linkToPageMainIndex: $linkToPageMainIndex, linkToPageSub: $linkToPageSub, pushDateTime: $pushDateTime, pushTarget: $pushTarget)';
}


}

/// @nodoc
abstract mixin class $AppNotificationsCopyWith<$Res>  {
  factory $AppNotificationsCopyWith(AppNotifications value, $Res Function(AppNotifications) _then) = _$AppNotificationsCopyWithImpl;
@useResult
$Res call({
 IconData icon, String title, String description, bool alert, bool read, MainPageRoute linkToPageMainIndex, Widget? linkToPageSub, DateTime? pushDateTime, String pushTarget
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
@pragma('vm:prefer-inline') @override $Res call({Object? icon = null,Object? title = null,Object? description = null,Object? alert = null,Object? read = null,Object? linkToPageMainIndex = null,Object? linkToPageSub = freezed,Object? pushDateTime = freezed,Object? pushTarget = null,}) {
  return _then(_self.copyWith(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,alert: null == alert ? _self.alert : alert // ignore: cast_nullable_to_non_nullable
as bool,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,linkToPageMainIndex: null == linkToPageMainIndex ? _self.linkToPageMainIndex : linkToPageMainIndex // ignore: cast_nullable_to_non_nullable
as MainPageRoute,linkToPageSub: freezed == linkToPageSub ? _self.linkToPageSub : linkToPageSub // ignore: cast_nullable_to_non_nullable
as Widget?,pushDateTime: freezed == pushDateTime ? _self.pushDateTime : pushDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,pushTarget: null == pushTarget ? _self.pushTarget : pushTarget // ignore: cast_nullable_to_non_nullable
as String,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( IconData icon,  String title,  String description,  bool alert,  bool read,  MainPageRoute linkToPageMainIndex,  Widget? linkToPageSub,  DateTime? pushDateTime,  String pushTarget)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppNotifications() when $default != null:
return $default(_that.icon,_that.title,_that.description,_that.alert,_that.read,_that.linkToPageMainIndex,_that.linkToPageSub,_that.pushDateTime,_that.pushTarget);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( IconData icon,  String title,  String description,  bool alert,  bool read,  MainPageRoute linkToPageMainIndex,  Widget? linkToPageSub,  DateTime? pushDateTime,  String pushTarget)  $default,) {final _that = this;
switch (_that) {
case _AppNotifications():
return $default(_that.icon,_that.title,_that.description,_that.alert,_that.read,_that.linkToPageMainIndex,_that.linkToPageSub,_that.pushDateTime,_that.pushTarget);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( IconData icon,  String title,  String description,  bool alert,  bool read,  MainPageRoute linkToPageMainIndex,  Widget? linkToPageSub,  DateTime? pushDateTime,  String pushTarget)?  $default,) {final _that = this;
switch (_that) {
case _AppNotifications() when $default != null:
return $default(_that.icon,_that.title,_that.description,_that.alert,_that.read,_that.linkToPageMainIndex,_that.linkToPageSub,_that.pushDateTime,_that.pushTarget);case _:
  return null;

}
}

}

/// @nodoc


class _AppNotifications implements AppNotifications {
  const _AppNotifications({required this.icon, required this.title, required this.description, this.alert = false, this.read = false, required this.linkToPageMainIndex, this.linkToPageSub, this.pushDateTime, this.pushTarget = "todo_replace-this"});
  

@override final  IconData icon;
// JSON converter or sth
@override final  String title;
@override final  String description;
@override@JsonKey() final  bool alert;
@override@JsonKey() final  bool read;
@override final  MainPageRoute linkToPageMainIndex;
@override final  Widget? linkToPageSub;
// TODO give me a way to display your pages
@override final  DateTime? pushDateTime;
// TODO
@override@JsonKey() final  String pushTarget;

/// Create a copy of AppNotifications
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppNotificationsCopyWith<_AppNotifications> get copyWith => __$AppNotificationsCopyWithImpl<_AppNotifications>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppNotifications&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.alert, alert) || other.alert == alert)&&(identical(other.read, read) || other.read == read)&&(identical(other.linkToPageMainIndex, linkToPageMainIndex) || other.linkToPageMainIndex == linkToPageMainIndex)&&(identical(other.linkToPageSub, linkToPageSub) || other.linkToPageSub == linkToPageSub)&&(identical(other.pushDateTime, pushDateTime) || other.pushDateTime == pushDateTime)&&(identical(other.pushTarget, pushTarget) || other.pushTarget == pushTarget));
}


@override
int get hashCode => Object.hash(runtimeType,icon,title,description,alert,read,linkToPageMainIndex,linkToPageSub,pushDateTime,pushTarget);

@override
String toString() {
  return 'AppNotifications(icon: $icon, title: $title, description: $description, alert: $alert, read: $read, linkToPageMainIndex: $linkToPageMainIndex, linkToPageSub: $linkToPageSub, pushDateTime: $pushDateTime, pushTarget: $pushTarget)';
}


}

/// @nodoc
abstract mixin class _$AppNotificationsCopyWith<$Res> implements $AppNotificationsCopyWith<$Res> {
  factory _$AppNotificationsCopyWith(_AppNotifications value, $Res Function(_AppNotifications) _then) = __$AppNotificationsCopyWithImpl;
@override @useResult
$Res call({
 IconData icon, String title, String description, bool alert, bool read, MainPageRoute linkToPageMainIndex, Widget? linkToPageSub, DateTime? pushDateTime, String pushTarget
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
@override @pragma('vm:prefer-inline') $Res call({Object? icon = null,Object? title = null,Object? description = null,Object? alert = null,Object? read = null,Object? linkToPageMainIndex = null,Object? linkToPageSub = freezed,Object? pushDateTime = freezed,Object? pushTarget = null,}) {
  return _then(_AppNotifications(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,alert: null == alert ? _self.alert : alert // ignore: cast_nullable_to_non_nullable
as bool,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,linkToPageMainIndex: null == linkToPageMainIndex ? _self.linkToPageMainIndex : linkToPageMainIndex // ignore: cast_nullable_to_non_nullable
as MainPageRoute,linkToPageSub: freezed == linkToPageSub ? _self.linkToPageSub : linkToPageSub // ignore: cast_nullable_to_non_nullable
as Widget?,pushDateTime: freezed == pushDateTime ? _self.pushDateTime : pushDateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,pushTarget: null == pushTarget ? _self.pushTarget : pushTarget // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
