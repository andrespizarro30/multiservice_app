
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../databases/multiporpuse_service_form_db.dart';
import '../models/multiporpuse_job_detail_model.dart';
import '../models/response_new_job_register.dart';
import '../repositories/multiporpuse_form_repository.dart';

class MultiPorpuseFormPageController extends GetxController implements GetxService{

  MultiPorpusePageRepo multiPorpusePageRepo;
  final FirebaseStorage firebaseStorage;

  MultiPorpuseFormPageController({
    required this.multiPorpusePageRepo,
    required this.firebaseStorage
  });

  Map<String,List<String>> _jobPhotosList = {};
  Map<String,List<String>> get jobPhotosList => _jobPhotosList;

  MultiporpuseJobDetail _multiporpuseJobDetail = MultiporpuseJobDetail();
  MultiporpuseJobDetail get multiporpuseJobDetail => _multiporpuseJobDetail;

  List<MultiporpuseJobDetail> _pendingServicesList = [];
  List<MultiporpuseJobDetail> get pendingServicesList => _pendingServicesList;

  ResponseNewJobRegisterModel _responseModel = ResponseNewJobRegisterModel(RegisteredJob: "NO");
  ResponseNewJobRegisterModel get responseModel => _responseModel;

  bool _isNewJobDataLoading = false;
  bool get isNewJobDataLoading => _isNewJobDataLoading;

  bool _isLoadingImages = false;
  bool get isLoadingImages => _isLoadingImages;

  List<String> urlsImages = [];

  bool _isFinishUpload = false;
  bool get isFinishUpload => _isFinishUpload;
  set setFinishedUpload(bool isFinishedUpload){
    _isFinishUpload = isFinishedUpload;
  }


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

    String _photoStringList = "";
    _jobPhotosList[serviceOrderNumber]!.forEach((file) {
      _photoStringList = _photoStringList + file + ";";
    });

    _multiporpuseJobDetail.FilesPath = _photoStringList;

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

    String _photoStringList = "";
    _jobPhotosList[serviceOrderNumber]!.forEach((file) {
      _photoStringList = _photoStringList + file + ";";
    });

    _multiporpuseJobDetail.FilesPath = _photoStringList;

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

  Future<void> registerNewJob(MultiporpuseJobDetail multiporpuseJobDetail)async{

    Response response = await multiPorpusePageRepo.registerNewJob(multiporpuseJobDetail);

    String _photoStringList = "";
    _jobPhotosList[multiporpuseJobDetail.OrderNumber]!.forEach((file) {
      _photoStringList = _photoStringList + file + ";";
    });

    multiporpuseJobDetail.FilesPath = _photoStringList;
    _multiporpuseJobDetail = multiporpuseJobDetail;

    if(response.statusCode==200){
      String registeredJob = response.body["RegisteredJob"];
      _responseModel = ResponseNewJobRegisterModel(RegisteredJob: registeredJob);
      multiporpuseJobDetail.LoadedJob = "OK";
    }else{
      _responseModel = ResponseNewJobRegisterModel(RegisteredJob: "NO");
    }
    _isFinishUpload = true;
    _isNewJobDataLoading = false;

    partialSaving(multiporpuseJobDetail);

  }

  Future<void> uploadJobImages(String appCurrentDirectory,MultiporpuseJobDetail multiporpuseJobDetail) async{

    _isNewJobDataLoading = true;
    update();

    String currentDate = multiporpuseJobDetail.RequestedDate!.substring(0,10).toString();

    List<String> imagesPaths = multiporpuseJobDetail.FilesPath!.split(";");

    int imagesUploaded = 0;

    imagesPaths.forEach((imagePath) async{

      String fileName = imagePath.split("/").last.replaceAll(" ", "");

      final Reference refStorage = firebaseStorage.ref().child("RegisteredJobs")
          .child(multiporpuseJobDetail.JobType!)
          .child(currentDate)
          .child(multiporpuseJobDetail.OrderNumber!)
          .child(fileName);

      if(imagePath.isNotEmpty){
        File imageFile = File("${appCurrentDirectory!}${imagePath}");

        final UploadTask uploadTask = refStorage.putFile(imageFile);

        final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => true);

        if(taskSnapshot.state == TaskState.success){
          final String url = await taskSnapshot.ref.getDownloadURL();
          urlsImages.add(url);
          imagesUploaded = imagesUploaded + 1;
        }

        if(imagesUploaded == imagesPaths.length - 1){
          String urlStringList = "";

          urlsImages.forEach((url) {
            urlStringList = urlStringList + url + ";";
          });

          multiporpuseJobDetail.FilesPath = urlStringList;

          registerNewJob(multiporpuseJobDetail);
        }
      }
    });

  }

}