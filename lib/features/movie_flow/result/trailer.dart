import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Trailer extends Equatable {
  const Trailer({
    required this.key,
    required this.official,
    required this.site,
  });

  factory Trailer.fromMap(Map<String, dynamic> map) {
    return Trailer(
      key: map['key'],
      official: map['official'],
      site: map['site'],
    );
  }

  final String key;
  final bool official;
  final String site;

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
