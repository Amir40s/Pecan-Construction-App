import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import '../models/employeeModel.dart';
import '../widgets/failure.dart';

class EmployeeRepository {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Future<Either<Failure, EmployeeModel>> registeredEmployee(
      EmployeeModel employeeModel,
      ) async {
    try {
      UserCredential userCredential =
      await auth.createUserWithEmailAndPassword(
        email: employeeModel.email,
        password: employeeModel.password,
      );

      if (userCredential.user == null) {
        return Left(Failure(message: "employee not created"));
      }

      final payload = {
        "employeeId": userCredential.user!.uid,
        "name": employeeModel.name,
        "email": employeeModel.email,
        "password": employeeModel.password,
        "avatarUrl": employeeModel.avatarUrl,
        "assignedSites": employeeModel.assignedSites,
      };

      await firestore
          .collection("employees")
          .doc(userCredential.user!.uid)
          .set(payload);

      final savedEmployee = EmployeeModel.fromMap(
        payload,
        userCredential.user!.uid,
      );

      return Right(savedEmployee);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, Unit>> updateEmployeeProfile({
    required String uid,
    required String name,
    String? avatarUrl,
  }) async {
    try {
      final data = <String, dynamic>{
        "name": name,
      };

      if (avatarUrl != null && avatarUrl.trim().isNotEmpty) {
        data["avatarUrl"] = avatarUrl;
      }

      await firestore.collection("employees").doc(uid).update(data);
      return right(unit);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, EmployeeModel>> getEmployeeById(String uid) async {
    try {
      final doc = await firestore.collection("employees").doc(uid).get();
      if (!doc.exists) {
        return left(Failure(message: "Employee not found"));
      }
      return right(EmployeeModel.fromMap(doc.data()!, uid));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, String>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = cred.user;
      if (user == null) {
        return Left(Failure(message: "Login failed: user is null"));
      }

      return Right(user.uid);
    } on FirebaseAuthException catch (e) {
      return Left(
          Failure(message: "${e.code}: ${e.message ?? "Auth error"}"));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> fetchUserProfile({
    required String uid,
    String collection = "employees",
  }) async {
    try {
      final doc = await firestore.collection(collection).doc(uid).get();

      if (!doc.exists) {
        return Left(Failure(message: "Profile not found in $collection"));
      }

      return Right(doc.data() ?? {});
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, String>> uploadProfileImage({
    required String uid,
    File? file,
    Uint8List? bytes,
  }) async {
    try {
      final ref = storage
          .ref()
          .child("profiles/$uid/avatar_${DateTime.now().millisecondsSinceEpoch}.jpg");

      UploadTask task;

      if (kIsWeb) {
        if (bytes == null) {
          return Left(Failure(message: "Web bytes missing"));
        }

        task = ref.putData(
          bytes,
          SettableMetadata(contentType: "image/jpeg"),
        );
      } else {
        if (file == null) {
          return Left(Failure(message: "Image file missing"));
        }

        task = ref.putFile(
          file,
          SettableMetadata(contentType: "image/jpeg"),
        );
      }

      final snap = await task;
      final url = await snap.ref.getDownloadURL();

      return Right(url);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<void> logout() => auth.signOut();
}