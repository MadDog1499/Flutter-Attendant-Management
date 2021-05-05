import 'package:firebase_storage/firebase_storage.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:real_app/services/Cloud%20Firestore.dart';

Future<void> uploadFile(File filepath, String filename) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference storageReference = storage.ref().child('Face Data/$filename');
  UploadTask uploadTask = storageReference.putFile(filepath);
  await uploadTask;
  Fluttertoast.showToast(msg: 'Upload Image Complete');
}

Future<void> deleteFile(String filename) {
  FirebaseStorage storage = FirebaseStorage.instance;
  storage.ref().child('Face Data/${filename}').delete();
  Fluttertoast.showToast(msg: 'Delete Complete');
}

Future<void> singleDownload(String url, String filename, String old_file,
    String document_Id, String newlink) {
  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      print(DownloadsPathProvider.downloadsDirectory);
      return await DownloadsPathProvider.downloadsDirectory;
    }
    return await getApplicationDocumentsDirectory();
  }

  Future<bool> _requestPermissions() async {
    var permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
    }

    return permission == PermissionStatus.granted;
  }

  Future<void> _download() async {
    final Dio _dio = Dio();

    Future<void> _startDownload(String savePath) async {
      final response = await _dio.download(url, savePath);
    }

    final dir = await _getDownloadDirectory();
    final isPermissionStatusGranted = await _requestPermissions();

    if (isPermissionStatusGranted) {
      final savePath = path.join(dir.path, filename);
      await _startDownload(savePath);
      File uploadnew = File(savePath);
      uploadFile(uploadnew, filename);
      deleteFile(old_file);
      updateUserImageLink(document_Id, newlink);
    }
  }

  _download();
}
