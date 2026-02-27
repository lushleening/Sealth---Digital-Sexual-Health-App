// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registered_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegisteredProfile {

@JsonKey(name: 'supabase_id') String get supabaseId; String get username;@JsonKey(includeFromJson: false, includeToJson: false) String? get email;@JsonKey(name: 'avatar_url') String? get avatarUrl; bool get verified;
/// Create a copy of RegisteredProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisteredProfileCopyWith<RegisteredProfile> get copyWith => _$RegisteredProfileCopyWithImpl<RegisteredProfile>(this as RegisteredProfile, _$identity);

  /// Serializes this RegisteredProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisteredProfile&&(identical(other.supabaseId, supabaseId) || other.supabaseId == supabaseId)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.verified, verified) || other.verified == verified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,supabaseId,username,email,avatarUrl,verified);

@override
String toString() {
  return 'RegisteredProfile(supabaseId: $supabaseId, username: $username, email: $email, avatarUrl: $avatarUrl, verified: $verified)';
}


}

/// @nodoc
abstract mixin class $RegisteredProfileCopyWith<$Res>  {
  factory $RegisteredProfileCopyWith(RegisteredProfile value, $Res Function(RegisteredProfile) _then) = _$RegisteredProfileCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'supabase_id') String supabaseId, String username,@JsonKey(includeFromJson: false, includeToJson: false) String? email,@JsonKey(name: 'avatar_url') String? avatarUrl, bool verified
});




}
/// @nodoc
class _$RegisteredProfileCopyWithImpl<$Res>
    implements $RegisteredProfileCopyWith<$Res> {
  _$RegisteredProfileCopyWithImpl(this._self, this._then);

  final RegisteredProfile _self;
  final $Res Function(RegisteredProfile) _then;

/// Create a copy of RegisteredProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? supabaseId = null,Object? username = null,Object? email = freezed,Object? avatarUrl = freezed,Object? verified = null,}) {
  return _then(_self.copyWith(
supabaseId: null == supabaseId ? _self.supabaseId : supabaseId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RegisteredProfile].
extension RegisteredProfilePatterns on RegisteredProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisteredProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisteredProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisteredProfile value)  $default,){
final _that = this;
switch (_that) {
case _RegisteredProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisteredProfile value)?  $default,){
final _that = this;
switch (_that) {
case _RegisteredProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'supabase_id')  String supabaseId,  String username, @JsonKey(includeFromJson: false, includeToJson: false)  String? email, @JsonKey(name: 'avatar_url')  String? avatarUrl,  bool verified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisteredProfile() when $default != null:
return $default(_that.supabaseId,_that.username,_that.email,_that.avatarUrl,_that.verified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'supabase_id')  String supabaseId,  String username, @JsonKey(includeFromJson: false, includeToJson: false)  String? email, @JsonKey(name: 'avatar_url')  String? avatarUrl,  bool verified)  $default,) {final _that = this;
switch (_that) {
case _RegisteredProfile():
return $default(_that.supabaseId,_that.username,_that.email,_that.avatarUrl,_that.verified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'supabase_id')  String supabaseId,  String username, @JsonKey(includeFromJson: false, includeToJson: false)  String? email, @JsonKey(name: 'avatar_url')  String? avatarUrl,  bool verified)?  $default,) {final _that = this;
switch (_that) {
case _RegisteredProfile() when $default != null:
return $default(_that.supabaseId,_that.username,_that.email,_that.avatarUrl,_that.verified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegisteredProfile implements RegisteredProfile {
  const _RegisteredProfile({@JsonKey(name: 'supabase_id') required this.supabaseId, required this.username, @JsonKey(includeFromJson: false, includeToJson: false) this.email, @JsonKey(name: 'avatar_url') required this.avatarUrl, required this.verified});
  factory _RegisteredProfile.fromJson(Map<String, dynamic> json) => _$RegisteredProfileFromJson(json);

@override@JsonKey(name: 'supabase_id') final  String supabaseId;
@override final  String username;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  String? email;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override final  bool verified;

/// Create a copy of RegisteredProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisteredProfileCopyWith<_RegisteredProfile> get copyWith => __$RegisteredProfileCopyWithImpl<_RegisteredProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisteredProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisteredProfile&&(identical(other.supabaseId, supabaseId) || other.supabaseId == supabaseId)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.verified, verified) || other.verified == verified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,supabaseId,username,email,avatarUrl,verified);

@override
String toString() {
  return 'RegisteredProfile(supabaseId: $supabaseId, username: $username, email: $email, avatarUrl: $avatarUrl, verified: $verified)';
}


}

/// @nodoc
abstract mixin class _$RegisteredProfileCopyWith<$Res> implements $RegisteredProfileCopyWith<$Res> {
  factory _$RegisteredProfileCopyWith(_RegisteredProfile value, $Res Function(_RegisteredProfile) _then) = __$RegisteredProfileCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'supabase_id') String supabaseId, String username,@JsonKey(includeFromJson: false, includeToJson: false) String? email,@JsonKey(name: 'avatar_url') String? avatarUrl, bool verified
});




}
/// @nodoc
class __$RegisteredProfileCopyWithImpl<$Res>
    implements _$RegisteredProfileCopyWith<$Res> {
  __$RegisteredProfileCopyWithImpl(this._self, this._then);

  final _RegisteredProfile _self;
  final $Res Function(_RegisteredProfile) _then;

/// Create a copy of RegisteredProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? supabaseId = null,Object? username = null,Object? email = freezed,Object? avatarUrl = freezed,Object? verified = null,}) {
  return _then(_RegisteredProfile(
supabaseId: null == supabaseId ? _self.supabaseId : supabaseId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
