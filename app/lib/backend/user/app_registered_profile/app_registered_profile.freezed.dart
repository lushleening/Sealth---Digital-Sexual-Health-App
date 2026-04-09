// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_registered_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppRegisteredProfile {

@JsonKey(name: 'username') String get username;@JsonKey(name: 'avatar_url') String? get avatarUrl;@JsonKey(name: 'verified') bool get verified;
/// Create a copy of AppRegisteredProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppRegisteredProfileCopyWith<AppRegisteredProfile> get copyWith => _$AppRegisteredProfileCopyWithImpl<AppRegisteredProfile>(this as AppRegisteredProfile, _$identity);

  /// Serializes this AppRegisteredProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppRegisteredProfile&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.verified, verified) || other.verified == verified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,avatarUrl,verified);

@override
String toString() {
  return 'AppRegisteredProfile(username: $username, avatarUrl: $avatarUrl, verified: $verified)';
}


}

/// @nodoc
abstract mixin class $AppRegisteredProfileCopyWith<$Res>  {
  factory $AppRegisteredProfileCopyWith(AppRegisteredProfile value, $Res Function(AppRegisteredProfile) _then) = _$AppRegisteredProfileCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'username') String username,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'verified') bool verified
});




}
/// @nodoc
class _$AppRegisteredProfileCopyWithImpl<$Res>
    implements $AppRegisteredProfileCopyWith<$Res> {
  _$AppRegisteredProfileCopyWithImpl(this._self, this._then);

  final AppRegisteredProfile _self;
  final $Res Function(AppRegisteredProfile) _then;

/// Create a copy of AppRegisteredProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? avatarUrl = freezed,Object? verified = null,}) {
  return _then(_self.copyWith(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppRegisteredProfile].
extension AppRegisteredProfilePatterns on AppRegisteredProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppRegisteredProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppRegisteredProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppRegisteredProfile value)  $default,){
final _that = this;
switch (_that) {
case _AppRegisteredProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppRegisteredProfile value)?  $default,){
final _that = this;
switch (_that) {
case _AppRegisteredProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'username')  String username, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'verified')  bool verified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppRegisteredProfile() when $default != null:
return $default(_that.username,_that.avatarUrl,_that.verified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'username')  String username, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'verified')  bool verified)  $default,) {final _that = this;
switch (_that) {
case _AppRegisteredProfile():
return $default(_that.username,_that.avatarUrl,_that.verified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'username')  String username, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'verified')  bool verified)?  $default,) {final _that = this;
switch (_that) {
case _AppRegisteredProfile() when $default != null:
return $default(_that.username,_that.avatarUrl,_that.verified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppRegisteredProfile extends AppRegisteredProfile {
  const _AppRegisteredProfile({@JsonKey(name: 'username') required this.username, @JsonKey(name: 'avatar_url') required this.avatarUrl, @JsonKey(name: 'verified') required this.verified}): super._();
  factory _AppRegisteredProfile.fromJson(Map<String, dynamic> json) => _$AppRegisteredProfileFromJson(json);

@override@JsonKey(name: 'username') final  String username;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override@JsonKey(name: 'verified') final  bool verified;

/// Create a copy of AppRegisteredProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppRegisteredProfileCopyWith<_AppRegisteredProfile> get copyWith => __$AppRegisteredProfileCopyWithImpl<_AppRegisteredProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppRegisteredProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppRegisteredProfile&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.verified, verified) || other.verified == verified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,avatarUrl,verified);

@override
String toString() {
  return 'AppRegisteredProfile(username: $username, avatarUrl: $avatarUrl, verified: $verified)';
}


}

/// @nodoc
abstract mixin class _$AppRegisteredProfileCopyWith<$Res> implements $AppRegisteredProfileCopyWith<$Res> {
  factory _$AppRegisteredProfileCopyWith(_AppRegisteredProfile value, $Res Function(_AppRegisteredProfile) _then) = __$AppRegisteredProfileCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'username') String username,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'verified') bool verified
});




}
/// @nodoc
class __$AppRegisteredProfileCopyWithImpl<$Res>
    implements _$AppRegisteredProfileCopyWith<$Res> {
  __$AppRegisteredProfileCopyWithImpl(this._self, this._then);

  final _AppRegisteredProfile _self;
  final $Res Function(_AppRegisteredProfile) _then;

/// Create a copy of AppRegisteredProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? avatarUrl = freezed,Object? verified = null,}) {
  return _then(_AppRegisteredProfile(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
