class CLoudStorageException implements Exception {
  const CLoudStorageException();
}

//C in CRUD
class CouldNotCreateNoteException implements CLoudStorageException {}

//R in CRUD
class CouldNotGettAllNotesException implements CLoudStorageException {}

//U in CRUD
class CouldNotUpdateNotesException implements CLoudStorageException {}

//D in CRUD
class CouldNotDeleteNoteException implements CLoudStorageException {}
