import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_preview/flutter_file_preview.dart';
import 'package:dio/dio.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }


  static Future<Directory> getLocalPath({String childPath}) async {
    Directory appDir;
    if (Platform.isIOS) {
      appDir = await getApplicationDocumentsDirectory();
    } else {
      appDir = await getExternalStorageDirectory();
    }

    PermissionStatus status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      if (statuses[Permission.storage] != PermissionStatus.granted) {
        return Future.error("未授权");
      }
    }
    String appDocPath = appDir.path + "/eco_app"+(childPath!=null&&childPath!=""?"/${childPath}":"");
    Directory appPath = Directory(appDocPath);
    try {
      await appPath.create(recursive: true);
    } catch (e) {
      print(e.toString());
    }
    return Future.value(appPath);
  }


  static String getUUid() {
    String randomstr = Random().nextInt(10).toString();
    for (var i = 0; i < 3; i++) {
      var str = Random().nextInt(10);
      randomstr = "$randomstr" + "$str";
    }
    var timenumber = DateTime.now().millisecondsSinceEpoch;//时间
    var uuid = "$randomstr" + "$timenumber";
    return uuid.toString();
  }

  static Future<String> downloadFile(url) async {
    Dio dio = new Dio();
    Directory localPath = await getLocalPath();

    var name = getUUid()+url
        .toString()
        .substring(url.toString().lastIndexOf(".") , url.toString().length);
    String localFilePath = localPath.path +"/" +name;
    File localFile = File(localPath.path+"/" + name);

    bool exist = await localFile.exists();
    if (exist) {
      return Future.value(localFilePath);
    } else {

      //设置连接超时时间
      dio.options.connectTimeout = 100000;
      //设置数据接收超时时间
      dio.options.receiveTimeout = 100000;
      Response response;
      try {
        response = await dio.download(url, localFilePath,onReceiveProgress: (received,total){
          if (total != -1) {
            ///当前下载的百分比例
            print("下载比例：："+(received / total * 100).toStringAsFixed(0) + "%");

          }
        });
        if (response.statusCode == 200) {
          print('下载请求成功');
          return Future.value(localFilePath);
        } else {
          throw Exception('接口出错');
        }
      } catch (e) {
        print('ERROR:======>$e');
      }
      return Future.value("");
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Column(
          children: <Widget>[
            new Container(
              height: 20,
            ),
            new FlatButton(
                child: new Text("Open Debug"),
                onPressed: () {
                  FlutterFilePreview.openDebug();
                }),
            new Container(
              height: 20,
            ),
            new FlatButton(
                child: new Text("Open Online Pdf"),
                onPressed: () async{
                  String filePath="http://180.97.207.131:8081/park//6436e5c2c7d74bf0b6570155067bfdb6/20190829/昆山石梅一期工程环境影响报告书.pdf";
                  String localFilePath=await downloadFile(filePath);
                  if(localFilePath!=null&&localFilePath!=""){
                    FlutterFilePreview.openFile(
                        localFilePath,
                        title: 'Online PDF');
                  //  FlutterFilePreview.openFile(localFilePath, title: '查看文件');
                  }

                }),
            new Container(
              height: 20,
            ),
            new FlatButton(
                child: new Text("Open Online Docx"),
                onPressed: () {
                  FlutterFilePreview.openFile(
                      "https://gitee.com/kongkongss/flutter_file_preview/raw/master/test/docs/test_file_for.docx",
                      title: 'Online Docx');
                }),
            new Container(
              height: 20,
            ),
            new FlatButton(
                child: new Text("Open Online Xls"),
                onPressed: () {
                  FlutterFilePreview.openFile(
                      "https://gitee.com/kongkongss/flutter_file_preview/raw/master/test/docs/test_file_for.xlsx",
                      title: 'Online Xls');
                }),
          ],
        ),
      ),
    );
  }
}
