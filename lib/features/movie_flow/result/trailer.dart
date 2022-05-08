import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Trailer extends Equatable {
  const Trailer({
    required this.key,
    required this.official,
    required this.site,
    required this.type,
  });

  factory Trailer.fromMap(Map<String, dynamic> map) {
    return Trailer(
      key: map['key'],
      official: map['official'],
      site: map['site'],
      type: map['type'],
    );
  }

  final String key;
  final bool official;
  final String site;
  final String type;

  @override
  // TODO: implement props
  List<Object?> get props => [key, official, site, type];
}
