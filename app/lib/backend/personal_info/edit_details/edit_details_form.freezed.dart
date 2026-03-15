// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_details_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditDetailsFormState {

 bool get inputEnabled; bool get submitting; String? get usernameError;
/// Create a copy of EditDetailsFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditDetailsFormStateCopyWith<EditDetailsFormState> get copyWith => _$EditDetailsFormStateCopyWithImpl<EditDetailsFormState>(this as EditDetailsFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditDetailsFormState&&(identical(other.inputEnabled, inputEnabled) || other.inputEnabled == inputEnabled)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.usernameError, usernameError) || other.usernameError == usernameError));
}


@override
int get hashCode => Object.hash(runtimeType,inputEnabled,submitting,usernameError);

@override
String toString() {
  return 'EditDetailsFormState(inputEnabled: $inputEnabled, submitting: $submitting, usernameError: $usernameError)';
}


}

/// @nodoc
abstract mixin class $EditDetailsFormStateCopyWith<$Res>  {
  factory $EditDetailsFormStateCopyWith(EditDetailsFormState value, $Res Function(EditDetailsFormState) _then) = _$EditDetailsFormStateCopyWithImpl;
@useResult
$Res call({
 bool inputEnabled, bool submitting, String? usernameError
});




}
/// @nodoc
class _$EditDetailsFormStateCopyWithImpl<$Res>
    implements $EditDetailsFormStateCopyWith<$Res> {
  _$EditDetailsFormStateCopyWithImpl(this._self, this._then);

  final EditDetailsFormState _self;
  final $Res Function(EditDetailsFormState) _then;

/// Create a copy of EditDetailsFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inputEnabled = null,Object? submitting = null,Object? usernameError = freezed,}) {
  return _then(_self.copyWith(
inputEnabled: null == inputEnabled ? _self.inputEnabled : inputEnabled // ignore: cast_nullable_to_non_nullable
as bool,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,usernameError: freezed == usernameError ? _self.usernameError : usernameError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EditDetailsFormState].
extension EditDetailsFormStatePatterns on EditDetailsFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditDetailsFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditDetailsFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditDetailsFormState value)  $default,){
final _that = this;
switch (_that) {
case _EditDetailsFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditDetailsFormState value)?  $default,){
final _that = this;
switch (_that) {
case _EditDetailsFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool inputEnabled,  bool submitting,  String? usernameError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditDetailsFormState() when $default != null:
return $default(_that.inputEnabled,_that.submitting,_that.usernameError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool inputEnabled,  bool submitting,  String? usernameError)  $default,) {final _that = this;
switch (_that) {
case _EditDetailsFormState():
return $default(_that.inputEnabled,_that.submitting,_that.usernameError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool inputEnabled,  bool submitting,  String? usernameError)?  $default,) {final _that = this;
switch (_that) {
case _EditDetailsFormState() when $default != null:
return $default(_that.inputEnabled,_that.submitting,_that.usernameError);case _:
  return null;

}
}

}

/// @nodoc


class _EditDetailsFormState implements EditDetailsFormState {
  const _EditDetailsFormState({this.inputEnabled = false, this.submitting = false, this.usernameError});
  

@override@JsonKey() final  bool inputEnabled;
@override@JsonKey() final  bool submitting;
@override final  String? usernameError;

/// Create a copy of EditDetailsFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditDetailsFormStateCopyWith<_EditDetailsFormState> get copyWith => __$EditDetailsFormStateCopyWithImpl<_EditDetailsFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditDetailsFormState&&(identical(other.inputEnabled, inputEnabled) || other.inputEnabled == inputEnabled)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.usernameError, usernameError) || other.usernameError == usernameError));
}


@override
int get hashCode => Object.hash(runtimeType,inputEnabled,submitting,usernameError);

@override
String toString() {
  return 'EditDetailsFormState(inputEnabled: $inputEnabled, submitting: $submitting, usernameError: $usernameError)';
}


}

/// @nodoc
abstract mixin class _$EditDetailsFormStateCopyWith<$Res> implements $EditDetailsFormStateCopyWith<$Res> {
  factory _$EditDetailsFormStateCopyWith(_EditDetailsFormState value, $Res Function(_EditDetailsFormState) _then) = __$EditDetailsFormStateCopyWithImpl;
@override @useResult
$Res call({
 bool inputEnabled, bool submitting, String? usernameError
});




}
/// @nodoc
class __$EditDetailsFormStateCopyWithImpl<$Res>
    implements _$EditDetailsFormStateCopyWith<$Res> {
  __$EditDetailsFormStateCopyWithImpl(this._self, this._then);

  final _EditDetailsFormState _self;
  final $Res Function(_EditDetailsFormState) _then;

/// Create a copy of EditDetailsFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inputEnabled = null,Object? submitting = null,Object? usernameError = freezed,}) {
  return _then(_EditDetailsFormState(
inputEnabled: null == inputEnabled ? _self.inputEnabled : inputEnabled // ignore: cast_nullable_to_non_nullable
as bool,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,usernameError: freezed == usernameError ? _self.usernameError : usernameError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
