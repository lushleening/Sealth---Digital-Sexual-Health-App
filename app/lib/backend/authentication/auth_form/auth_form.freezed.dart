// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthFormState {

 String? get emailError; String? get passwordError; String? get confirmPasswordError; bool get submitting; bool get hidePassword; bool get hideConfirmPassword; bool get blockRecommends;
/// Create a copy of AuthFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthFormStateCopyWith<AuthFormState> get copyWith => _$AuthFormStateCopyWithImpl<AuthFormState>(this as AuthFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthFormState&&(identical(other.emailError, emailError) || other.emailError == emailError)&&(identical(other.passwordError, passwordError) || other.passwordError == passwordError)&&(identical(other.confirmPasswordError, confirmPasswordError) || other.confirmPasswordError == confirmPasswordError)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.hidePassword, hidePassword) || other.hidePassword == hidePassword)&&(identical(other.hideConfirmPassword, hideConfirmPassword) || other.hideConfirmPassword == hideConfirmPassword)&&(identical(other.blockRecommends, blockRecommends) || other.blockRecommends == blockRecommends));
}


@override
int get hashCode => Object.hash(runtimeType,emailError,passwordError,confirmPasswordError,submitting,hidePassword,hideConfirmPassword,blockRecommends);

@override
String toString() {
  return 'AuthFormState(emailError: $emailError, passwordError: $passwordError, confirmPasswordError: $confirmPasswordError, submitting: $submitting, hidePassword: $hidePassword, hideConfirmPassword: $hideConfirmPassword, blockRecommends: $blockRecommends)';
}


}

/// @nodoc
abstract mixin class $AuthFormStateCopyWith<$Res>  {
  factory $AuthFormStateCopyWith(AuthFormState value, $Res Function(AuthFormState) _then) = _$AuthFormStateCopyWithImpl;
@useResult
$Res call({
 String? emailError, String? passwordError, String? confirmPasswordError, bool submitting, bool hidePassword, bool hideConfirmPassword, bool blockRecommends
});




}
/// @nodoc
class _$AuthFormStateCopyWithImpl<$Res>
    implements $AuthFormStateCopyWith<$Res> {
  _$AuthFormStateCopyWithImpl(this._self, this._then);

  final AuthFormState _self;
  final $Res Function(AuthFormState) _then;

/// Create a copy of AuthFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? emailError = freezed,Object? passwordError = freezed,Object? confirmPasswordError = freezed,Object? submitting = null,Object? hidePassword = null,Object? hideConfirmPassword = null,Object? blockRecommends = null,}) {
  return _then(_self.copyWith(
emailError: freezed == emailError ? _self.emailError : emailError // ignore: cast_nullable_to_non_nullable
as String?,passwordError: freezed == passwordError ? _self.passwordError : passwordError // ignore: cast_nullable_to_non_nullable
as String?,confirmPasswordError: freezed == confirmPasswordError ? _self.confirmPasswordError : confirmPasswordError // ignore: cast_nullable_to_non_nullable
as String?,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,hidePassword: null == hidePassword ? _self.hidePassword : hidePassword // ignore: cast_nullable_to_non_nullable
as bool,hideConfirmPassword: null == hideConfirmPassword ? _self.hideConfirmPassword : hideConfirmPassword // ignore: cast_nullable_to_non_nullable
as bool,blockRecommends: null == blockRecommends ? _self.blockRecommends : blockRecommends // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthFormState].
extension AuthFormStatePatterns on AuthFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthFormState value)  $default,){
final _that = this;
switch (_that) {
case _AuthFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthFormState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? emailError,  String? passwordError,  String? confirmPasswordError,  bool submitting,  bool hidePassword,  bool hideConfirmPassword,  bool blockRecommends)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthFormState() when $default != null:
return $default(_that.emailError,_that.passwordError,_that.confirmPasswordError,_that.submitting,_that.hidePassword,_that.hideConfirmPassword,_that.blockRecommends);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? emailError,  String? passwordError,  String? confirmPasswordError,  bool submitting,  bool hidePassword,  bool hideConfirmPassword,  bool blockRecommends)  $default,) {final _that = this;
switch (_that) {
case _AuthFormState():
return $default(_that.emailError,_that.passwordError,_that.confirmPasswordError,_that.submitting,_that.hidePassword,_that.hideConfirmPassword,_that.blockRecommends);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? emailError,  String? passwordError,  String? confirmPasswordError,  bool submitting,  bool hidePassword,  bool hideConfirmPassword,  bool blockRecommends)?  $default,) {final _that = this;
switch (_that) {
case _AuthFormState() when $default != null:
return $default(_that.emailError,_that.passwordError,_that.confirmPasswordError,_that.submitting,_that.hidePassword,_that.hideConfirmPassword,_that.blockRecommends);case _:
  return null;

}
}

}

/// @nodoc


class _AuthFormState implements AuthFormState {
  const _AuthFormState({this.emailError, this.passwordError, this.confirmPasswordError, this.submitting = false, this.hidePassword = true, this.hideConfirmPassword = true, this.blockRecommends = false});
  

@override final  String? emailError;
@override final  String? passwordError;
@override final  String? confirmPasswordError;
@override@JsonKey() final  bool submitting;
@override@JsonKey() final  bool hidePassword;
@override@JsonKey() final  bool hideConfirmPassword;
@override@JsonKey() final  bool blockRecommends;

/// Create a copy of AuthFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthFormStateCopyWith<_AuthFormState> get copyWith => __$AuthFormStateCopyWithImpl<_AuthFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthFormState&&(identical(other.emailError, emailError) || other.emailError == emailError)&&(identical(other.passwordError, passwordError) || other.passwordError == passwordError)&&(identical(other.confirmPasswordError, confirmPasswordError) || other.confirmPasswordError == confirmPasswordError)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.hidePassword, hidePassword) || other.hidePassword == hidePassword)&&(identical(other.hideConfirmPassword, hideConfirmPassword) || other.hideConfirmPassword == hideConfirmPassword)&&(identical(other.blockRecommends, blockRecommends) || other.blockRecommends == blockRecommends));
}


@override
int get hashCode => Object.hash(runtimeType,emailError,passwordError,confirmPasswordError,submitting,hidePassword,hideConfirmPassword,blockRecommends);

@override
String toString() {
  return 'AuthFormState(emailError: $emailError, passwordError: $passwordError, confirmPasswordError: $confirmPasswordError, submitting: $submitting, hidePassword: $hidePassword, hideConfirmPassword: $hideConfirmPassword, blockRecommends: $blockRecommends)';
}


}

/// @nodoc
abstract mixin class _$AuthFormStateCopyWith<$Res> implements $AuthFormStateCopyWith<$Res> {
  factory _$AuthFormStateCopyWith(_AuthFormState value, $Res Function(_AuthFormState) _then) = __$AuthFormStateCopyWithImpl;
@override @useResult
$Res call({
 String? emailError, String? passwordError, String? confirmPasswordError, bool submitting, bool hidePassword, bool hideConfirmPassword, bool blockRecommends
});




}
/// @nodoc
class __$AuthFormStateCopyWithImpl<$Res>
    implements _$AuthFormStateCopyWith<$Res> {
  __$AuthFormStateCopyWithImpl(this._self, this._then);

  final _AuthFormState _self;
  final $Res Function(_AuthFormState) _then;

/// Create a copy of AuthFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? emailError = freezed,Object? passwordError = freezed,Object? confirmPasswordError = freezed,Object? submitting = null,Object? hidePassword = null,Object? hideConfirmPassword = null,Object? blockRecommends = null,}) {
  return _then(_AuthFormState(
emailError: freezed == emailError ? _self.emailError : emailError // ignore: cast_nullable_to_non_nullable
as String?,passwordError: freezed == passwordError ? _self.passwordError : passwordError // ignore: cast_nullable_to_non_nullable
as String?,confirmPasswordError: freezed == confirmPasswordError ? _self.confirmPasswordError : confirmPasswordError // ignore: cast_nullable_to_non_nullable
as String?,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,hidePassword: null == hidePassword ? _self.hidePassword : hidePassword // ignore: cast_nullable_to_non_nullable
as bool,hideConfirmPassword: null == hideConfirmPassword ? _self.hideConfirmPassword : hideConfirmPassword // ignore: cast_nullable_to_non_nullable
as bool,blockRecommends: null == blockRecommends ? _self.blockRecommends : blockRecommends // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
