// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppMetadata {

 String get appName; String get version;
/// Create a copy of AppMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppMetadataCopyWith<AppMetadata> get copyWith => _$AppMetadataCopyWithImpl<AppMetadata>(this as AppMetadata, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppMetadata&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,appName,version);

@override
String toString() {
  return 'AppMetadata(appName: $appName, version: $version)';
}


}

/// @nodoc
abstract mixin class $AppMetadataCopyWith<$Res>  {
  factory $AppMetadataCopyWith(AppMetadata value, $Res Function(AppMetadata) _then) = _$AppMetadataCopyWithImpl;
@useResult
$Res call({
 String appName, String version
});




}
/// @nodoc
class _$AppMetadataCopyWithImpl<$Res>
    implements $AppMetadataCopyWith<$Res> {
  _$AppMetadataCopyWithImpl(this._self, this._then);

  final AppMetadata _self;
  final $Res Function(AppMetadata) _then;

/// Create a copy of AppMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appName = null,Object? version = null,}) {
  return _then(_self.copyWith(
appName: null == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppMetadata].
extension AppMetadataPatterns on AppMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppMetadata value)  $default,){
final _that = this;
switch (_that) {
case _AppMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _AppMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String appName,  String version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppMetadata() when $default != null:
return $default(_that.appName,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String appName,  String version)  $default,) {final _that = this;
switch (_that) {
case _AppMetadata():
return $default(_that.appName,_that.version);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String appName,  String version)?  $default,) {final _that = this;
switch (_that) {
case _AppMetadata() when $default != null:
return $default(_that.appName,_that.version);case _:
  return null;

}
}

}

/// @nodoc


class _AppMetadata extends AppMetadata {
  const _AppMetadata({required this.appName, required this.version}): super._();
  

@override final  String appName;
@override final  String version;

/// Create a copy of AppMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppMetadataCopyWith<_AppMetadata> get copyWith => __$AppMetadataCopyWithImpl<_AppMetadata>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppMetadata&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,appName,version);

@override
String toString() {
  return 'AppMetadata(appName: $appName, version: $version)';
}


}

/// @nodoc
abstract mixin class _$AppMetadataCopyWith<$Res> implements $AppMetadataCopyWith<$Res> {
  factory _$AppMetadataCopyWith(_AppMetadata value, $Res Function(_AppMetadata) _then) = __$AppMetadataCopyWithImpl;
@override @useResult
$Res call({
 String appName, String version
});




}
/// @nodoc
class __$AppMetadataCopyWithImpl<$Res>
    implements _$AppMetadataCopyWith<$Res> {
  __$AppMetadataCopyWithImpl(this._self, this._then);

  final _AppMetadata _self;
  final $Res Function(_AppMetadata) _then;

/// Create a copy of AppMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appName = null,Object? version = null,}) {
  return _then(_AppMetadata(
appName: null == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
