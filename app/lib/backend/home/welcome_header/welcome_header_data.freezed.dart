// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'welcome_header_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WelcomeHeaderData {

 String get appName; UserContext get userContext;
/// Create a copy of WelcomeHeaderData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WelcomeHeaderDataCopyWith<WelcomeHeaderData> get copyWith => _$WelcomeHeaderDataCopyWithImpl<WelcomeHeaderData>(this as WelcomeHeaderData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WelcomeHeaderData&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.userContext, userContext) || other.userContext == userContext));
}


@override
int get hashCode => Object.hash(runtimeType,appName,userContext);

@override
String toString() {
  return 'WelcomeHeaderData(appName: $appName, userContext: $userContext)';
}


}

/// @nodoc
abstract mixin class $WelcomeHeaderDataCopyWith<$Res>  {
  factory $WelcomeHeaderDataCopyWith(WelcomeHeaderData value, $Res Function(WelcomeHeaderData) _then) = _$WelcomeHeaderDataCopyWithImpl;
@useResult
$Res call({
 String appName, UserContext userContext
});


$UserContextCopyWith<$Res> get userContext;

}
/// @nodoc
class _$WelcomeHeaderDataCopyWithImpl<$Res>
    implements $WelcomeHeaderDataCopyWith<$Res> {
  _$WelcomeHeaderDataCopyWithImpl(this._self, this._then);

  final WelcomeHeaderData _self;
  final $Res Function(WelcomeHeaderData) _then;

/// Create a copy of WelcomeHeaderData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appName = null,Object? userContext = null,}) {
  return _then(_self.copyWith(
appName: null == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String,userContext: null == userContext ? _self.userContext : userContext // ignore: cast_nullable_to_non_nullable
as UserContext,
  ));
}
/// Create a copy of WelcomeHeaderData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserContextCopyWith<$Res> get userContext {
  
  return $UserContextCopyWith<$Res>(_self.userContext, (value) {
    return _then(_self.copyWith(userContext: value));
  });
}
}


/// Adds pattern-matching-related methods to [WelcomeHeaderData].
extension WelcomeHeaderDataPatterns on WelcomeHeaderData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WelcomeHeaderData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WelcomeHeaderData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WelcomeHeaderData value)  $default,){
final _that = this;
switch (_that) {
case _WelcomeHeaderData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WelcomeHeaderData value)?  $default,){
final _that = this;
switch (_that) {
case _WelcomeHeaderData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String appName,  UserContext userContext)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WelcomeHeaderData() when $default != null:
return $default(_that.appName,_that.userContext);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String appName,  UserContext userContext)  $default,) {final _that = this;
switch (_that) {
case _WelcomeHeaderData():
return $default(_that.appName,_that.userContext);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String appName,  UserContext userContext)?  $default,) {final _that = this;
switch (_that) {
case _WelcomeHeaderData() when $default != null:
return $default(_that.appName,_that.userContext);case _:
  return null;

}
}

}

/// @nodoc


class _WelcomeHeaderData implements WelcomeHeaderData {
  const _WelcomeHeaderData({required this.appName, required this.userContext});
  

@override final  String appName;
@override final  UserContext userContext;

/// Create a copy of WelcomeHeaderData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WelcomeHeaderDataCopyWith<_WelcomeHeaderData> get copyWith => __$WelcomeHeaderDataCopyWithImpl<_WelcomeHeaderData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WelcomeHeaderData&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.userContext, userContext) || other.userContext == userContext));
}


@override
int get hashCode => Object.hash(runtimeType,appName,userContext);

@override
String toString() {
  return 'WelcomeHeaderData(appName: $appName, userContext: $userContext)';
}


}

/// @nodoc
abstract mixin class _$WelcomeHeaderDataCopyWith<$Res> implements $WelcomeHeaderDataCopyWith<$Res> {
  factory _$WelcomeHeaderDataCopyWith(_WelcomeHeaderData value, $Res Function(_WelcomeHeaderData) _then) = __$WelcomeHeaderDataCopyWithImpl;
@override @useResult
$Res call({
 String appName, UserContext userContext
});


@override $UserContextCopyWith<$Res> get userContext;

}
/// @nodoc
class __$WelcomeHeaderDataCopyWithImpl<$Res>
    implements _$WelcomeHeaderDataCopyWith<$Res> {
  __$WelcomeHeaderDataCopyWithImpl(this._self, this._then);

  final _WelcomeHeaderData _self;
  final $Res Function(_WelcomeHeaderData) _then;

/// Create a copy of WelcomeHeaderData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appName = null,Object? userContext = null,}) {
  return _then(_WelcomeHeaderData(
appName: null == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String,userContext: null == userContext ? _self.userContext : userContext // ignore: cast_nullable_to_non_nullable
as UserContext,
  ));
}

/// Create a copy of WelcomeHeaderData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserContextCopyWith<$Res> get userContext {
  
  return $UserContextCopyWith<$Res>(_self.userContext, (value) {
    return _then(_self.copyWith(userContext: value));
  });
}
}

// dart format on
