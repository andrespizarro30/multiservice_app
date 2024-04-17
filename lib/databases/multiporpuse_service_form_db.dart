
import 'dart:io';

import 'package:multiservice_app/utils/app_constants.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/multiporpuse_job_detail_model.dart';

class MultiporpuseServiceFormDatabase{

  Future<Database> CreateTable() async {

    var appDirectory = Platform.isAndroid ? await getDownloadsDirectory() : await getApplicationDocumentsDirectory();

    String appImagesPath = appDirectory!.path;

    Directory folderDir = Directory("${appImagesPath}/databases");

    if (await folderDir.exists() == false) {
      await folderDir.create(recursive: true);
    }

    var database = openDatabase(
        join(folderDir.path, 'saved_jobs_database.db'),
        onCreate: (db, version){
          return db.execute(
            AppConstants.CREATEMULTIPORPUSEJOBSDB
          );
        },
        version: 1
    );

    return database;
  }

  Future<void> saveNewJob(MultiporpuseJobDetail multiporpuseJobDetail,Database database)async{

    final Database db = database;

    await db.insert('MultiporpuseSavedJobs', multiporpuseJobDetail.toJson(),conflictAlgorithm: ConflictAlgorithm.replace);

  }

  Future<List<MultiporpuseJobDetail>> getSavedJobData(Database database,String orderNumber) async{

    final List<Map<String,dynamic>> maps = await database.query("MultiporpuseSavedJobs",where: "OrderNumber='"+ orderNumber +"'");

    List<MultiporpuseJobDetail> multiPorpuseJobDetailList = [];

    if(maps.isNotEmpty){
      maps.forEach((element) {
        multiPorpuseJobDetailList.add(MultiporpuseJobDetail.fromJson(element));
      });
    }

    return multiPorpuseJobDetailList;

  }

  Future<List<MultiporpuseJobDetail>> getAllSavedPendingJobsData(Database database) async{

    final List<Map<String,dynamic>> maps = await database.query("MultiporpuseSavedJobs",where: "LoadedJob='NO'");

    List<MultiporpuseJobDetail> multiPorpuseJobDetailList = [];

    if(maps.isNotEmpty){
      maps.forEach((element) {
        multiPorpuseJobDetailList.add(MultiporpuseJobDetail.fromJson(element));
      });
    }

    return multiPorpuseJobDetailList;

  }



}