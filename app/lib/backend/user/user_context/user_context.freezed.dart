// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_context.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserContext {

 AppUser get user; AppRegisteredProfile? get profile; List<AppNotifications> get notifications; AppSettings get settings;
/// Create a copy of UserContext
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserContextCopyWith<UserContext> get copyWith => _$UserContextCopyWithImpl<UserContext>(this as UserContext, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserContext&&(identical(other.user, user) || other.user == user)&&(identical(other.profile, profile) || other.profile == profile)&&const DeepCollectionEquality().equals(other.notifications, notifications)&&(identical(other.settings, settings) || other.settings == settings));
}


@override
int get hashCode => Object.hash(runtimeType,user,profile,const DeepCollectionEquality().hash(notifications),settings);

@override
String toString() {
  return 'UserContext(user: $user, profile: $profile, notifications: $notifications, settings: $settings)';
}


}

/// @nodoc
abstract mixin class $UserContextCopyWith<$Res>  {
  factory $UserContextCopyWith(UserContext value, $Res Function(UserContext) _then) = _$UserContextCopyWithImpl;
@useResult
$Res call({
 AppUser user, AppRegisteredProfile? profile, List<AppNotifications> notifications, AppSettings settings
});


$AppUserCopyWith<$Res> get user;$AppRegisteredProfileCopyWith<$Res>? get profile;$AppSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class _$UserContextCopyWithImpl<$Res>
    implements $UserContextCopyWith<$Res> {
  _$UserContextCopyWithImpl(this._self, this._then);

  final UserContext _self;
  final $Res Function(UserContext) _then;

/// Create a copy of UserContext
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? profile = freezed,Object? notifications = null,Object? settings = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AppUser,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as AppRegisteredProfile?,notifications: null == notifications ? _self.notifications : notifications // ignore: cast_nullable_to_non_nullable
as List<AppNotifications>,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as AppSettings,
  ));
}
/// Create a copy of UserContext
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppUserCopyWith<$Res> get user {
  
  return $AppUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of UserContext
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppRegisteredProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $AppRegisteredProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of UserContext
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<$Res> get settings {
  
  return $AppSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserContext].
extension UserContextPatterns on UserContext {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserContext value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserContext() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserContext value)  $default,){
final _that = this;
switch (_that) {
case _UserContext():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserContext value)?  $default,){
final _that = this;
switch (_that) {
case _UserContext() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppUser user,  AppRegisteredProfile? profile,  List<AppNotifications> notifications,  AppSettings settings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserContext() when $default != null:
return $default(_that.user,_that.profile,_that.notifications,_that.settings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppUser user,  AppRegisteredProfile? profile,  List<AppNotifications> notifications,  AppSettings settings)  $default,) {final _that = this;
switch (_that) {
case _UserContext():
return $default(_that.user,_that.profile,_that.notifications,_that.settings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppUser user,  AppRegisteredProfile? profile,  List<AppNotifications> notifications,  AppSettings settings)?  $default,) {final _that = this;
switch (_that) {
case _UserContext() when $default != null:
return $default(_that.user,_that.profile,_that.notifications,_that.settings);case _:
  return null;

}
}

}

/// @nodoc


class _UserContext extends UserContext {
  const _UserContext({required this.user, required this.profile, required final  List<AppNotifications> notifications, required this.settings}): _notifications = notifications,super._();
  

@override final  AppUser user;
@override final  AppRegisteredProfile? profile;
 final  List<AppNotifications> _notifications;
@override List<AppNotifications> get notifications {
  if (_notifications is EqualUnmodifiableListView) return _notifications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notifications);
}

@override final  AppSettings settings;

/// Create a copy of UserContext
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserContextCopyWith<_UserContext> get copyWith => __$UserContextCopyWithImpl<_UserContext>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserContext&&(identical(other.user, user) || other.user == user)&&(identical(other.profile, profile) || other.profile == profile)&&const DeepCollectionEquality().equals(other._notifications, _notifications)&&(identical(other.settings, settings) || other.settings == settings));
}


@override
int get hashCode => Object.hash(runtimeType,user,profile,const DeepCollectionEquality().hash(_notifications),settings);

@override
String toString() {
  return 'UserContext(user: $user, profile: $profile, notifications: $notifications, settings: $settings)';
}


}

/// @nodoc
abstract mixin class _$UserContextCopyWith<$Res> implements $UserContextCopyWith<$Res> {
  factory _$UserContextCopyWith(_UserContext value, $Res Function(_UserContext) _then) = __$UserContextCopyWithImpl;
@override @useResult
$Res call({
 AppUser user, AppRegisteredProfile? profile, List<AppNotifications> notifications, AppSettings settings
});


@override $AppUserCopyWith<$Res> get user;@override $AppRegisteredProfileCopyWith<$Res>? get profile;@override $AppSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class __$UserContextCopyWithImpl<$Res>
    implements _$UserContextCopyWith<$Res> {
  __$UserContextCopyWithImpl(this._self, this._then);

  final _UserContext _self;
  final $Res Function(_UserContext) _then;

/// Create a copy of UserContext
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? profile = freezed,Object? notifications = null,Object? settings = null,}) {
  return _then(_UserContext(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AppUser,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as AppRegisteredProfile?,notifications: null == notifications ? _self._notifications : notifications // ignore: cast_nullable_to_non_nullable
as List<AppNotifications>,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as AppSettings,
  ));
}

/// Create a copy of UserContext
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppUserCopyWith<$Res> get user {
  
  return $AppUserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of UserContext
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppRegisteredProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $AppRegisteredProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of UserContext
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<$Res> get settings {
  
  return $AppSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

// dart format on
