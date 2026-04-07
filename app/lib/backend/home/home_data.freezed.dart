// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeData {

 String get appName; UserContext get userContext; List<Appointment> get appointments; List<Article> get articles;
/// Create a copy of HomeData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeDataCopyWith<HomeData> get copyWith => _$HomeDataCopyWithImpl<HomeData>(this as HomeData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeData&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.userContext, userContext) || other.userContext == userContext)&&const DeepCollectionEquality().equals(other.appointments, appointments)&&const DeepCollectionEquality().equals(other.articles, articles));
}


@override
int get hashCode => Object.hash(runtimeType,appName,userContext,const DeepCollectionEquality().hash(appointments),const DeepCollectionEquality().hash(articles));

@override
String toString() {
  return 'HomeData(appName: $appName, userContext: $userContext, appointments: $appointments, articles: $articles)';
}


}

/// @nodoc
abstract mixin class $HomeDataCopyWith<$Res>  {
  factory $HomeDataCopyWith(HomeData value, $Res Function(HomeData) _then) = _$HomeDataCopyWithImpl;
@useResult
$Res call({
 String appName, UserContext userContext, List<Appointment> appointments, List<Article> articles
});


$UserContextCopyWith<$Res> get userContext;

}
/// @nodoc
class _$HomeDataCopyWithImpl<$Res>
    implements $HomeDataCopyWith<$Res> {
  _$HomeDataCopyWithImpl(this._self, this._then);

  final HomeData _self;
  final $Res Function(HomeData) _then;

/// Create a copy of HomeData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appName = null,Object? userContext = null,Object? appointments = null,Object? articles = null,}) {
  return _then(_self.copyWith(
appName: null == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String,userContext: null == userContext ? _self.userContext : userContext // ignore: cast_nullable_to_non_nullable
as UserContext,appointments: null == appointments ? _self.appointments : appointments // ignore: cast_nullable_to_non_nullable
as List<Appointment>,articles: null == articles ? _self.articles : articles // ignore: cast_nullable_to_non_nullable
as List<Article>,
  ));
}
/// Create a copy of HomeData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserContextCopyWith<$Res> get userContext {
  
  return $UserContextCopyWith<$Res>(_self.userContext, (value) {
    return _then(_self.copyWith(userContext: value));
  });
}
}


/// Adds pattern-matching-related methods to [HomeData].
extension HomeDataPatterns on HomeData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeData value)  $default,){
final _that = this;
switch (_that) {
case _HomeData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeData value)?  $default,){
final _that = this;
switch (_that) {
case _HomeData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String appName,  UserContext userContext,  List<Appointment> appointments,  List<Article> articles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeData() when $default != null:
return $default(_that.appName,_that.userContext,_that.appointments,_that.articles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String appName,  UserContext userContext,  List<Appointment> appointments,  List<Article> articles)  $default,) {final _that = this;
switch (_that) {
case _HomeData():
return $default(_that.appName,_that.userContext,_that.appointments,_that.articles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String appName,  UserContext userContext,  List<Appointment> appointments,  List<Article> articles)?  $default,) {final _that = this;
switch (_that) {
case _HomeData() when $default != null:
return $default(_that.appName,_that.userContext,_that.appointments,_that.articles);case _:
  return null;

}
}

}

/// @nodoc


class _HomeData implements HomeData {
  const _HomeData({required this.appName, required this.userContext, required final  List<Appointment> appointments, required final  List<Article> articles}): _appointments = appointments,_articles = articles;
  

@override final  String appName;
@override final  UserContext userContext;
 final  List<Appointment> _appointments;
@override List<Appointment> get appointments {
  if (_appointments is EqualUnmodifiableListView) return _appointments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_appointments);
}

 final  List<Article> _articles;
@override List<Article> get articles {
  if (_articles is EqualUnmodifiableListView) return _articles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_articles);
}


/// Create a copy of HomeData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeDataCopyWith<_HomeData> get copyWith => __$HomeDataCopyWithImpl<_HomeData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeData&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.userContext, userContext) || other.userContext == userContext)&&const DeepCollectionEquality().equals(other._appointments, _appointments)&&const DeepCollectionEquality().equals(other._articles, _articles));
}


@override
int get hashCode => Object.hash(runtimeType,appName,userContext,const DeepCollectionEquality().hash(_appointments),const DeepCollectionEquality().hash(_articles));

@override
String toString() {
  return 'HomeData(appName: $appName, userContext: $userContext, appointments: $appointments, articles: $articles)';
}


}

/// @nodoc
abstract mixin class _$HomeDataCopyWith<$Res> implements $HomeDataCopyWith<$Res> {
  factory _$HomeDataCopyWith(_HomeData value, $Res Function(_HomeData) _then) = __$HomeDataCopyWithImpl;
@override @useResult
$Res call({
 String appName, UserContext userContext, List<Appointment> appointments, List<Article> articles
});


@override $UserContextCopyWith<$Res> get userContext;

}
/// @nodoc
class __$HomeDataCopyWithImpl<$Res>
    implements _$HomeDataCopyWith<$Res> {
  __$HomeDataCopyWithImpl(this._self, this._then);

  final _HomeData _self;
  final $Res Function(_HomeData) _then;

/// Create a copy of HomeData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appName = null,Object? userContext = null,Object? appointments = null,Object? articles = null,}) {
  return _then(_HomeData(
appName: null == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String,userContext: null == userContext ? _self.userContext : userContext // ignore: cast_nullable_to_non_nullable
as UserContext,appointments: null == appointments ? _self._appointments : appointments // ignore: cast_nullable_to_non_nullable
as List<Appointment>,articles: null == articles ? _self._articles : articles // ignore: cast_nullable_to_non_nullable
as List<Article>,
  ));
}

/// Create a copy of HomeData
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
