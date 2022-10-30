// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: json['id'] as String,
      pubkey: json['pubkey'] as String,
      createdAt: _dateTimeFromJson(json['created_at'] as int),
      kind: json['kind'] as int,
      tags: (json['tags'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
      content: json['content'] as String,
      sig: json['sig'] as String,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'pubkey': instance.pubkey,
      'created_at': _dateTimeToJson(instance.createdAt),
      'kind': instance.kind,
      'tags': instance.tags,
      'content': instance.content,
      'sig': instance.sig,
    };
