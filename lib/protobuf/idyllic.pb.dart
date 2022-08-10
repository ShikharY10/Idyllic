///
//  Generated code. Do not modify.
//  source: idyllic.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class DashBoardHiveData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DashBoardHiveData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'main'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Address', protoName: 'Address')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Method', protoName: 'Method')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Protocol', protoName: 'Protocol')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'header')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'RequestBody', protoName: 'RequestBody')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ProtocolBody', protoName: 'ProtocolBody')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ResponseBody', protoName: 'ResponseBody')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'params')
    ..hasRequiredFields = false
  ;

  DashBoardHiveData._() : super();
  factory DashBoardHiveData({
    $core.String? address,
    $core.String? method,
    $core.String? protocol,
    $core.String? header,
    $core.String? requestBody,
    $core.String? protocolBody,
    $core.String? responseBody,
    $core.String? params,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    if (method != null) {
      _result.method = method;
    }
    if (protocol != null) {
      _result.protocol = protocol;
    }
    if (header != null) {
      _result.header = header;
    }
    if (requestBody != null) {
      _result.requestBody = requestBody;
    }
    if (protocolBody != null) {
      _result.protocolBody = protocolBody;
    }
    if (responseBody != null) {
      _result.responseBody = responseBody;
    }
    if (params != null) {
      _result.params = params;
    }
    return _result;
  }
  factory DashBoardHiveData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DashBoardHiveData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DashBoardHiveData clone() => DashBoardHiveData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DashBoardHiveData copyWith(void Function(DashBoardHiveData) updates) => super.copyWith((message) => updates(message as DashBoardHiveData)) as DashBoardHiveData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DashBoardHiveData create() => DashBoardHiveData._();
  DashBoardHiveData createEmptyInstance() => create();
  static $pb.PbList<DashBoardHiveData> createRepeated() => $pb.PbList<DashBoardHiveData>();
  @$core.pragma('dart2js:noInline')
  static DashBoardHiveData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DashBoardHiveData>(create);
  static DashBoardHiveData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get method => $_getSZ(1);
  @$pb.TagNumber(2)
  set method($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMethod() => $_has(1);
  @$pb.TagNumber(2)
  void clearMethod() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get protocol => $_getSZ(2);
  @$pb.TagNumber(3)
  set protocol($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasProtocol() => $_has(2);
  @$pb.TagNumber(3)
  void clearProtocol() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get header => $_getSZ(3);
  @$pb.TagNumber(4)
  set header($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHeader() => $_has(3);
  @$pb.TagNumber(4)
  void clearHeader() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get requestBody => $_getSZ(4);
  @$pb.TagNumber(5)
  set requestBody($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRequestBody() => $_has(4);
  @$pb.TagNumber(5)
  void clearRequestBody() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get protocolBody => $_getSZ(5);
  @$pb.TagNumber(6)
  set protocolBody($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasProtocolBody() => $_has(5);
  @$pb.TagNumber(6)
  void clearProtocolBody() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get responseBody => $_getSZ(6);
  @$pb.TagNumber(7)
  set responseBody($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasResponseBody() => $_has(6);
  @$pb.TagNumber(7)
  void clearResponseBody() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get params => $_getSZ(7);
  @$pb.TagNumber(8)
  set params($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasParams() => $_has(7);
  @$pb.TagNumber(8)
  void clearParams() => clearField(8);
}

