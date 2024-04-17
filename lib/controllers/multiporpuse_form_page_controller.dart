
import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../databases/multiporpuse_service_form_db.dart';
import '../models/multiporpuse_job_detail_model.dart';
import '../repositories/multiporpuse_form_repository.dart';

class MultiPorpuseFormPageController extends GetxController implements GetxService{

  MultiPorpusePageRepo multiPorpusePageRepo;

  MultiPorpuseFormPageController({
    required this.multiPorpusePageRepo
  });

  Map<String,List<String>> _jobPhotosList = {};
  Map<String,List<String>> get jobPhotosList => _jobPhotosList;

  MultiporpuseJobDetail _multiporpuseJobDetail = MultiporpuseJobDetail();
  MultiporpuseJobDetail get multiporpuseJobDetail => _multiporpuseJobDetail;

  List<MultiporpuseJobDetail> _pendingServicesList = [];
  List<MultiporpuseJobDetail> get pendingServicesList => _pendingServicesList;

  String _photoStringList = "";

  void setJobPhotos(String serviceOrderNumber,File image){

    List<String> pathParts = image.path.split("/");
    String filePath = "/${pathParts[pathParts!.length!-4]}/${pathParts[pathParts.length-3]}/${pathParts[pathParts.length-2]}/${pathParts[pathParts.length-1]}";

    if(!_jobPhotosList.containsKey(serviceOrderNumber)){

      _jobPhotosList.putIfAbsent(serviceOrderNumber, (){
        List<String> fileList = [];
        fileList.add(filePath);
        return fileList;
      });
    }else{
      List<String> fileList = _jobPhotosList[serviceOrderNumber]!;
      fileList.add(filePath);
      _jobPhotosList.update(serviceOrderNumber, (value){
        return fileList;
      });
    }

    _photoStringList = "";
    _jobPhotosList[serviceOrderNumber]!.forEach((file) {
      _photoStringList = _photoStringList + file + ";";
    });

    multiporpuseJobDetail.FilesPath = _photoStringList;

    update();

  }

  void setJobPhotosNoUpdate(String serviceOrderNumber,File image){

    List<String> pathParts = image.path.split("/");
    String filePath = "/${pathParts[pathParts!.length!-4]}/${pathParts[pathParts.length-3]}/${pathParts[pathParts.length-2]}/${pathParts[pathParts.length-1]}";

    if(!_jobPhotosList.containsKey(serviceOrderNumber)){

      _jobPhotosList.putIfAbsent(serviceOrderNumber, (){
        List<String> fileList = [];
        fileList.add(filePath);
        return fileList;
      });
    }else{
      List<String> fileList = _jobPhotosList[serviceOrderNumber]!;
      fileList.add(filePath);
      _jobPhotosList.update(serviceOrderNumber, (value){
        return fileList;
      });
    }

    _photoStringList = "";
    _jobPhotosList[serviceOrderNumber]!.forEach((file) {
      _photoStringList = _photoStringList + file + ";";
    });

    multiporpuseJobDetail.FilesPath = _photoStringList;

  }

  void assignToCurrentModel(MultiporpuseJobDetail multiporpuseJobDetail){

    _jobPhotosList = {};

    _multiporpuseJobDetail = multiporpuseJobDetail;

    multiporpuseJobDetail.FilesPath!.split(";").forEach((path) {
      if(path.isNotEmpty){
        if(path.isNotEmpty){
          setJobPhotosNoUpdate(multiporpuseJobDetail.OrderNumber!, File(path));
        }
      }
    });

    update();

  }

  void partialSaving(MultiporpuseJobDetail multiporpuseJobDetail) async{

    multiporpuseJobDetail.RequestedDate = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

    MultiporpuseServiceFormDatabase mpsdb = MultiporpuseServiceFormDatabase();

    Database database = await mpsdb.CreateTable();

    mpsdb.saveNewJob(multiporpuseJobDetail, database);

    getPendingServices();

  }
  
  void getPendingServices() async{

    MultiporpuseServiceFormDatabase mpsdb = MultiporpuseServiceFormDatabase();

    Database database = await mpsdb.CreateTable();

    _pendingServicesList = await mpsdb.getAllSavedPendingJobsData(database);

    update();
    
  }

}