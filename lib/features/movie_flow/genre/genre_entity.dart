import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class GenreEntity extends Equatable {
  const GenreEntity({
    required this.id,
    required this.name,
  });

  factory GenreEntity.fromMap(Map<String, dynamic> map) {
    return GenreEntity(
      id: map['id'],
      name: map['name'],
    );
  }

  final int id;
  final String name;

  @override
  String toString() => 'GenreEntity(id: $id, name: $name)';

  @override
  List<Object?> get props => [id, name];
}
