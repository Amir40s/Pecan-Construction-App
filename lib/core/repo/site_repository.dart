import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fpdart/fpdart.dart';

import '../models/site_model.dart';
import '../widgets/failure.dart';

class SitesRepository {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  SitesRepository({
    FirebaseFirestore? db,
    FirebaseAuth? auth,
  })  : _db = db ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;
   final storage = FirebaseStorage.instance;
  ///  Realtime: current employee ke assigned sites stream
  Future<Either<Failure, Stream<List<SitesModel>>>> watchMyAssignedSites() async {
    try {
      final uid = _auth.currentUser?.uid.toString();
      if (uid == null) {
        return Left(Failure(message: "User not logged in"));
      }

      print("DEBUG: watchMyAssignedSites called for UID: $uid");

      final query = _db
          .collection("sites")
          .where("assignedEmployeeIds", arrayContains: uid);

      final stream = query.snapshots().map((snap) {
        print("DEBUG: Found ${snap.docs.length} sites in snapshot");

        return snap.docs.map((d) {
          final data = d.data();
          data["siteId"] = d.id;
          return SitesModel.fromJson(data);
        }).toList();
      });

      return Right(stream);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
  Stream<Either<Failure, List<SitesModel>>> fetchAllSitesRealtime() {
    try {
      return _db.collection("sites").snapshots()
          .map((snapshot) {

        /// Firestore documents ko model me convert karna
        final data = snapshot.docs
            .map((d) => SitesModel.fromJson(d.data()))
            .toList();

        /// Success case
        return Right(data);
      });
    } catch (e) {

      /// Agar stream setup me error aaye
      return Stream.value(
        Left(Failure(message: e.toString())),
      );
    }
  }

  Future<Either<Failure, String>> uploadEmployeePhoto({
    required String siteId,
    required File file,
  }) async {
    try {

      final fileName = DateTime.now().millisecondsSinceEpoch.toString();

      final ref = storage
          .ref()
          .child("sites")
          .child(siteId)
          .child("employeePhotos")
          .child("$fileName.jpg");

      final uploadTask = await ref.putFile(file);

      final url = await uploadTask.ref.getDownloadURL();

      await _db.collection("sites").doc(siteId).update({
        "employeePhotos": FieldValue.arrayUnion([url])
      });

      return Right(url);

    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }


}