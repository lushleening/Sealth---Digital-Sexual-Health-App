// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Settings {

 KBtn get kBtn; IconData get icon; String get title; String get description; bool Function(AppSettings) get value; void Function(AppSettingsNotifier, bool) get onChanged; bool Function(AppUser) get displaySetting;
/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsCopyWith<Settings> get copyWith => _$SettingsCopyWithImpl<Settings>(this as Settings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Settings&&(identical(other.kBtn, kBtn) || other.kBtn == kBtn)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.value, value) || other.value == value)&&(identical(other.onChanged, onChanged) || other.onChanged == onChanged)&&(identical(other.displaySetting, displaySetting) || other.displaySetting == displaySetting));
}


@override
int get hashCode => Object.hash(runtimeType,kBtn,icon,title,description,value,onChanged,displaySetting);

@override
String toString() {
  return 'Settings(kBtn: $kBtn, icon: $icon, title: $title, description: $description, value: $value, onChanged: $onChanged, displaySetting: $displaySetting)';
}


}

/// @nodoc
abstract mixin class $SettingsCopyWith<$Res>  {
  factory $SettingsCopyWith(Settings value, $Res Function(Settings) _then) = _$SettingsCopyWithImpl;
@useResult
$Res call({
 KBtn kBtn, IconData icon, String title, String description, bool Function(AppSettings) value, void Function(AppSettingsNotifier, bool) onChanged, bool Function(AppUser) displaySetting
});




}
/// @nodoc
class _$SettingsCopyWithImpl<$Res>
    implements $SettingsCopyWith<$Res> {
  _$SettingsCopyWithImpl(this._self, this._then);

  final Settings _self;
  final $Res Function(Settings) _then;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kBtn = null,Object? icon = null,Object? title = null,Object? description = null,Object? value = null,Object? onChanged = null,Object? displaySetting = null,}) {
  return _then(_self.copyWith(
kBtn: null == kBtn ? _self.kBtn : kBtn // ignore: cast_nullable_to_non_nullable
as KBtn,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as bool Function(AppSettings),onChanged: null == onChanged ? _self.onChanged : onChanged // ignore: cast_nullable_to_non_nullable
as void Function(AppSettingsNotifier, bool),displaySetting: null == displaySetting ? _self.displaySetting : displaySetting // ignore: cast_nullable_to_non_nullable
as bool Function(AppUser),
  ));
}

}


/// Adds pattern-matching-related methods to [Settings].
extension SettingsPatterns on Settings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Settings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Settings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Settings value)  $default,){
final _that = this;
switch (_that) {
case _Settings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Settings value)?  $default,){
final _that = this;
switch (_that) {
case _Settings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( KBtn kBtn,  IconData icon,  String title,  String description,  bool Function(AppSettings) value,  void Function(AppSettingsNotifier, bool) onChanged,  bool Function(AppUser) displaySetting)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Settings() when $default != null:
return $default(_that.kBtn,_that.icon,_that.title,_that.description,_that.value,_that.onChanged,_that.displaySetting);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( KBtn kBtn,  IconData icon,  String title,  String description,  bool Function(AppSettings) value,  void Function(AppSettingsNotifier, bool) onChanged,  bool Function(AppUser) displaySetting)  $default,) {final _that = this;
switch (_that) {
case _Settings():
return $default(_that.kBtn,_that.icon,_that.title,_that.description,_that.value,_that.onChanged,_that.displaySetting);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( KBtn kBtn,  IconData icon,  String title,  String description,  bool Function(AppSettings) value,  void Function(AppSettingsNotifier, bool) onChanged,  bool Function(AppUser) displaySetting)?  $default,) {final _that = this;
switch (_that) {
case _Settings() when $default != null:
return $default(_that.kBtn,_that.icon,_that.title,_that.description,_that.value,_that.onChanged,_that.displaySetting);case _:
  return null;

}
}

}

/// @nodoc


class _Settings implements Settings {
  const _Settings({required this.kBtn, required this.icon, required this.title, required this.description, required this.value, required this.onChanged, this.displaySetting = _defaultDisplaySetting});
  

@override final  KBtn kBtn;
@override final  IconData icon;
@override final  String title;
@override final  String description;
@override final  bool Function(AppSettings) value;
@override final  void Function(AppSettingsNotifier, bool) onChanged;
@override@JsonKey() final  bool Function(AppUser) displaySetting;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsCopyWith<_Settings> get copyWith => __$SettingsCopyWithImpl<_Settings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Settings&&(identical(other.kBtn, kBtn) || other.kBtn == kBtn)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.value, value) || other.value == value)&&(identical(other.onChanged, onChanged) || other.onChanged == onChanged)&&(identical(other.displaySetting, displaySetting) || other.displaySetting == displaySetting));
}


@override
int get hashCode => Object.hash(runtimeType,kBtn,icon,title,description,value,onChanged,displaySetting);

@override
String toString() {
  return 'Settings(kBtn: $kBtn, icon: $icon, title: $title, description: $description, value: $value, onChanged: $onChanged, displaySetting: $displaySetting)';
}


}

/// @nodoc
abstract mixin class _$SettingsCopyWith<$Res> implements $SettingsCopyWith<$Res> {
  factory _$SettingsCopyWith(_Settings value, $Res Function(_Settings) _then) = __$SettingsCopyWithImpl;
@override @useResult
$Res call({
 KBtn kBtn, IconData icon, String title, String description, bool Function(AppSettings) value, void Function(AppSettingsNotifier, bool) onChanged, bool Function(AppUser) displaySetting
});




}
/// @nodoc
class __$SettingsCopyWithImpl<$Res>
    implements _$SettingsCopyWith<$Res> {
  __$SettingsCopyWithImpl(this._self, this._then);

  final _Settings _self;
  final $Res Function(_Settings) _then;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kBtn = null,Object? icon = null,Object? title = null,Object? description = null,Object? value = null,Object? onChanged = null,Object? displaySetting = null,}) {
  return _then(_Settings(
kBtn: null == kBtn ? _self.kBtn : kBtn // ignore: cast_nullable_to_non_nullable
as KBtn,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as bool Function(AppSettings),onChanged: null == onChanged ? _self.onChanged : onChanged // ignore: cast_nullable_to_non_nullable
as void Function(AppSettingsNotifier, bool),displaySetting: null == displaySetting ? _self.displaySetting : displaySetting // ignore: cast_nullable_to_non_nullable
as bool Function(AppUser),
  ));
}


}

// dart format on
