// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationObj {

 IconData get icon; String get title; String get description; bool get warning; MainPageRoute get linkToPageMainIndex; Widget? get linkToPageSub;// TODO give me a way to display your pages
 bool get read;
/// Create a copy of NotificationObj
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationObjCopyWith<NotificationObj> get copyWith => _$NotificationObjCopyWithImpl<NotificationObj>(this as NotificationObj, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationObj&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.warning, warning) || other.warning == warning)&&(identical(other.linkToPageMainIndex, linkToPageMainIndex) || other.linkToPageMainIndex == linkToPageMainIndex)&&(identical(other.linkToPageSub, linkToPageSub) || other.linkToPageSub == linkToPageSub)&&(identical(other.read, read) || other.read == read));
}


@override
int get hashCode => Object.hash(runtimeType,icon,title,description,warning,linkToPageMainIndex,linkToPageSub,read);

@override
String toString() {
  return 'NotificationObj(icon: $icon, title: $title, description: $description, warning: $warning, linkToPageMainIndex: $linkToPageMainIndex, linkToPageSub: $linkToPageSub, read: $read)';
}


}

/// @nodoc
abstract mixin class $NotificationObjCopyWith<$Res>  {
  factory $NotificationObjCopyWith(NotificationObj value, $Res Function(NotificationObj) _then) = _$NotificationObjCopyWithImpl;
@useResult
$Res call({
 IconData icon, String title, String description, bool warning, MainPageRoute linkToPageMainIndex, Widget? linkToPageSub, bool read
});




}
/// @nodoc
class _$NotificationObjCopyWithImpl<$Res>
    implements $NotificationObjCopyWith<$Res> {
  _$NotificationObjCopyWithImpl(this._self, this._then);

  final NotificationObj _self;
  final $Res Function(NotificationObj) _then;

/// Create a copy of NotificationObj
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? icon = null,Object? title = null,Object? description = null,Object? warning = null,Object? linkToPageMainIndex = null,Object? linkToPageSub = freezed,Object? read = null,}) {
  return _then(_self.copyWith(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,warning: null == warning ? _self.warning : warning // ignore: cast_nullable_to_non_nullable
as bool,linkToPageMainIndex: null == linkToPageMainIndex ? _self.linkToPageMainIndex : linkToPageMainIndex // ignore: cast_nullable_to_non_nullable
as MainPageRoute,linkToPageSub: freezed == linkToPageSub ? _self.linkToPageSub : linkToPageSub // ignore: cast_nullable_to_non_nullable
as Widget?,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationObj].
extension NotificationObjPatterns on NotificationObj {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationObj value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationObj() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationObj value)  $default,){
final _that = this;
switch (_that) {
case _NotificationObj():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationObj value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationObj() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( IconData icon,  String title,  String description,  bool warning,  MainPageRoute linkToPageMainIndex,  Widget? linkToPageSub,  bool read)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationObj() when $default != null:
return $default(_that.icon,_that.title,_that.description,_that.warning,_that.linkToPageMainIndex,_that.linkToPageSub,_that.read);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( IconData icon,  String title,  String description,  bool warning,  MainPageRoute linkToPageMainIndex,  Widget? linkToPageSub,  bool read)  $default,) {final _that = this;
switch (_that) {
case _NotificationObj():
return $default(_that.icon,_that.title,_that.description,_that.warning,_that.linkToPageMainIndex,_that.linkToPageSub,_that.read);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( IconData icon,  String title,  String description,  bool warning,  MainPageRoute linkToPageMainIndex,  Widget? linkToPageSub,  bool read)?  $default,) {final _that = this;
switch (_that) {
case _NotificationObj() when $default != null:
return $default(_that.icon,_that.title,_that.description,_that.warning,_that.linkToPageMainIndex,_that.linkToPageSub,_that.read);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationObj implements NotificationObj {
  const _NotificationObj({required this.icon, required this.title, required this.description, this.warning = false, required this.linkToPageMainIndex, this.linkToPageSub, this.read = false});
  

@override final  IconData icon;
@override final  String title;
@override final  String description;
@override@JsonKey() final  bool warning;
@override final  MainPageRoute linkToPageMainIndex;
@override final  Widget? linkToPageSub;
// TODO give me a way to display your pages
@override@JsonKey() final  bool read;

/// Create a copy of NotificationObj
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationObjCopyWith<_NotificationObj> get copyWith => __$NotificationObjCopyWithImpl<_NotificationObj>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationObj&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.warning, warning) || other.warning == warning)&&(identical(other.linkToPageMainIndex, linkToPageMainIndex) || other.linkToPageMainIndex == linkToPageMainIndex)&&(identical(other.linkToPageSub, linkToPageSub) || other.linkToPageSub == linkToPageSub)&&(identical(other.read, read) || other.read == read));
}


@override
int get hashCode => Object.hash(runtimeType,icon,title,description,warning,linkToPageMainIndex,linkToPageSub,read);

@override
String toString() {
  return 'NotificationObj(icon: $icon, title: $title, description: $description, warning: $warning, linkToPageMainIndex: $linkToPageMainIndex, linkToPageSub: $linkToPageSub, read: $read)';
}


}

/// @nodoc
abstract mixin class _$NotificationObjCopyWith<$Res> implements $NotificationObjCopyWith<$Res> {
  factory _$NotificationObjCopyWith(_NotificationObj value, $Res Function(_NotificationObj) _then) = __$NotificationObjCopyWithImpl;
@override @useResult
$Res call({
 IconData icon, String title, String description, bool warning, MainPageRoute linkToPageMainIndex, Widget? linkToPageSub, bool read
});




}
/// @nodoc
class __$NotificationObjCopyWithImpl<$Res>
    implements _$NotificationObjCopyWith<$Res> {
  __$NotificationObjCopyWithImpl(this._self, this._then);

  final _NotificationObj _self;
  final $Res Function(_NotificationObj) _then;

/// Create a copy of NotificationObj
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? icon = null,Object? title = null,Object? description = null,Object? warning = null,Object? linkToPageMainIndex = null,Object? linkToPageSub = freezed,Object? read = null,}) {
  return _then(_NotificationObj(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,warning: null == warning ? _self.warning : warning // ignore: cast_nullable_to_non_nullable
as bool,linkToPageMainIndex: null == linkToPageMainIndex ? _self.linkToPageMainIndex : linkToPageMainIndex // ignore: cast_nullable_to_non_nullable
as MainPageRoute,linkToPageSub: freezed == linkToPageSub ? _self.linkToPageSub : linkToPageSub // ignore: cast_nullable_to_non_nullable
as Widget?,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
