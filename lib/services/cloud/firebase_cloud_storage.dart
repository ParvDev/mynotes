import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:mynotes/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Stream<Iterable<CLoudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map(
            (event) => event.docs
                .map(
                  (doc) => CLoudNote.fromSnapshot(doc),
                )
                .where((note) => note.ownerUserId == ownerUserId),
          );

  Future<void> updateNote({
    required String documanetId,
    required String text,
  }) async {
    try {
      await notes.doc(documanetId).update(
        {textFieldName: text},
      );
    } catch (e) {
      throw CouldNotUpdateNotesException();
    }
  }

  Future<void> deleteNote({required String documanetId}) async {
    try {
      await notes.doc(documanetId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  void createNewNotes({required String ownerUserId}) async {
    await notes.add(
      {
        ownerUserIdFieldName: ownerUserId,
        textFieldName: '',
      },
    );
  }

  Future<Iterable<CLoudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) {
                return CLoudNote(
                  documentId: doc.id,
                  ownerUserId: doc.data()[ownerUserIdFieldName] as String,
                  text: doc.data()[textFieldName] as String,
                );
              },
            ),
          );
    } catch (e) {
      throw CouldNotGettAllNotesException();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
