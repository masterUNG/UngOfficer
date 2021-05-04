import 'dart:convert';

class JobModel {
  final String id;
  final String idUser;
  final String nameJob;
  final String detailJob;
  final String status;
  JobModel({
    this.id,
    this.idUser,
    this.nameJob,
    this.detailJob,
    this.status,
  });

  JobModel copyWith({
    String id,
    String idUser,
    String nameJob,
    String detailJob,
    String status,
  }) {
    return JobModel(
      id: id ?? this.id,
      idUser: idUser ?? this.idUser,
      nameJob: nameJob ?? this.nameJob,
      detailJob: detailJob ?? this.detailJob,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idUser': idUser,
      'nameJob': nameJob,
      'detailJob': detailJob,
      'status': status,
    };
  }

  factory JobModel.fromMap(Map<String, dynamic> map) {
    return JobModel(
      id: map['id'],
      idUser: map['idUser'],
      nameJob: map['nameJob'],
      detailJob: map['detailJob'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory JobModel.fromJson(String source) => JobModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'JobModel(id: $id, idUser: $idUser, nameJob: $nameJob, detailJob: $detailJob, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is JobModel &&
      other.id == id &&
      other.idUser == idUser &&
      other.nameJob == nameJob &&
      other.detailJob == detailJob &&
      other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      idUser.hashCode ^
      nameJob.hashCode ^
      detailJob.hashCode ^
      status.hashCode;
  }
}
