// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'personal_info_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PersonalInfoData {

 AppUser get user; AppRegisteredProfile get profile;
/// Create a copy of PersonalInfoData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonalInfoDataCopyWith<PersonalInfoData> get copyWith => _$PersonalInfoDataCopyWithImpl<PersonalInfoData>(this as PersonalInfoData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonalInfoData&&(identical(other.user, user) || other.user == user)&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode => Object.hash(runtimeType,user,profile);

@override
String toString() {
  return 'PersonalInfoData(user: $user, profile: $profile)';
}


}

/// @nodoc
abstract mixin class $PersonalInfoDataCopyWith<$Res>  {
  factory $PersonalInfoDataCopyWith(PersonalInfoData value, $Res Function(PersonalInfoData) _then) = _$PersonalInfoDataCopyWithImpl;
@useResult
$Res call({
 AppUser user, AppRegisteredProfile profile
});


$AppUserCopyWith<$Res> get user;$AppRegisteredProfileCopyWith<$Res> get profile;

}
/// @nodoc
class _$PersonalInfoDataCopyWithImpl<$Res>
    implements $PersonalInfoDataCopyWith<$Res> {
  _$PersonalInfoDataCopyWithImpl(this._self, this._then);

  final PersonalInfoData _self;
  final $Res Function(PersonalInfoData) _then;

/// Create a copy of PersonalInfoData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? profile = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AppUser,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as AppRegisteredProfile,
  ));
}
/// Create a copy of PersonalInfoData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppUserCopyWith<$Res> get user {
  
  return $AppUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of PersonalInfoData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppRegisteredProfileCopyWith<$Res> get profile {
  
  return $AppRegisteredProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [PersonalInfoData].
extension PersonalInfoDataPatterns on PersonalInfoData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonalInfoData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonalInfoData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonalInfoData value)  $default,){
final _that = this;
switch (_that) {
case _PersonalInfoData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonalInfoData value)?  $default,){
final _that = this;
switch (_that) {
case _PersonalInfoData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppUser user,  AppRegisteredProfile profile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonalInfoData() when $default != null:
return $default(_that.user,_that.profile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppUser user,  AppRegisteredProfile profile)  $default,) {final _that = this;
switch (_that) {
case _PersonalInfoData():
return $default(_that.user,_that.profile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppUser user,  AppRegisteredProfile profile)?  $default,) {final _that = this;
switch (_that) {
case _PersonalInfoData() when $default != null:
return $default(_that.user,_that.profile);case _:
  return null;

}
}

}

/// @nodoc


class _PersonalInfoData implements PersonalInfoData {
  const _PersonalInfoData({required this.user, required this.profile});
  

@override final  AppUser user;
@override final  AppRegisteredProfile profile;

/// Create a copy of PersonalInfoData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonalInfoDataCopyWith<_PersonalInfoData> get copyWith => __$PersonalInfoDataCopyWithImpl<_PersonalInfoData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonalInfoData&&(identical(other.user, user) || other.user == user)&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode => Object.hash(runtimeType,user,profile);

@override
String toString() {
  return 'PersonalInfoData(user: $user, profile: $profile)';
}


}

/// @nodoc
abstract mixin class _$PersonalInfoDataCopyWith<$Res> implements $PersonalInfoDataCopyWith<$Res> {
  factory _$PersonalInfoDataCopyWith(_PersonalInfoData value, $Res Function(_PersonalInfoData) _then) = __$PersonalInfoDataCopyWithImpl;
@override @useResult
$Res call({
 AppUser user, AppRegisteredProfile profile
});


@override $AppUserCopyWith<$Res> get user;@override $AppRegisteredProfileCopyWith<$Res> get profile;

}
/// @nodoc
class __$PersonalInfoDataCopyWithImpl<$Res>
    implements _$PersonalInfoDataCopyWith<$Res> {
  __$PersonalInfoDataCopyWithImpl(this._self, this._then);

  final _PersonalInfoData _self;
  final $Res Function(_PersonalInfoData) _then;

/// Create a copy of PersonalInfoData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? profile = null,}) {
  return _then(_PersonalInfoData(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AppUser,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as AppRegisteredProfile,
  ));
}

/// Create a copy of PersonalInfoData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppUserCopyWith<$Res> get user {
  
  return $AppUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of PersonalInfoData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppRegisteredProfileCopyWith<$Res> get profile {
  
  return $AppRegisteredProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

// dart format on
