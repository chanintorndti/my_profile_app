import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_profile_app/views/your_about_ui.dart';
import 'package:my_profile_app/views/your_email_ui.dart';
import 'package:my_profile_app/views/your_name_ui.dart';
import 'package:my_profile_app/views/your_phone_ui.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({Key? key}) : super(key: key);

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  //สร้าง Controller ของแต่ละ TextField เพื่อที่จะเอาค่าจาก SharedPreference มาแสดง
  TextEditingController yournameCtrl = TextEditingController(text: '');
  TextEditingController yourphoneCtrl = TextEditingController(text: '');
  TextEditingController youremailCtrl = TextEditingController(text: '');
  TextEditingController youraboutCtrl = TextEditingController(text: '');

  //สร้าง object ที่ใช้ในการเก็บรูป
  File? _image;

  //สร้างเมธอดเอารูปจาก Camera โดยการเปิดกล้องและถ่ายรูป
  //แล้วบันทึกลง SharedPreferences
  getImageFromCameraAndSaveToSF() async {
    //เปิดกล้องเพื่อถ่ายรูปเก็บใน picImage
    XFile? pickImage = await ImagePicker().pickImage(source: ImageSource.camera);

    //เอารูปจาก picImage กำหนดให้กับตำแหน่งตรงที่จะแสดงผล
    if (pickImage != null) {
      setState(() {
        _image = File(pickImage.path);
      });
    }

    //บันทึกข้อมูลรูปที่ถ่ายจาก Camera เก็บในเครื่อง
    Directory imageDir = await getApplicationDocumentsDirectory();
    String imagePath = imageDir.path;
    var imageName = basename(pickImage!.path);
    File localImage = await File(pickImage.path).copy('$imagePath/$imageName');

    //บันทึก path รูปที่บันทึกเก็บไว้ในเครื่องลง SharedPreferences
    SharedPreferences prefer = await SharedPreferences.getInstance();
    prefer.setString('yourimage', localImage.path);
  }

  //สร้างเมธอดเอารูปจาก Gallery โดยการเปิดกล้องและถ่ายรูป
  //แล้วบันทึกลง SharedPreferences
  getImageFromGalleryAndSaveToSF() async {
    //เปิดแกลอรี่เพื่อเลือกรูปเก็บใน picImage
    XFile? pickImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    //เอารูปจาก picImage กำหนดให้กับตำแหน่งตรงที่จะแสดงผล
    if (pickImage != null) {
      setState(() {
        _image = File(pickImage.path);
      });
    }

    //บันทึกข้อมูลจากรูปที่เลือกจากแกลอรี่เก็บในเครื่อง
    Directory imageDir = await getApplicationDocumentsDirectory();
    String imagePath = imageDir.path;
    var imageName = basename(pickImage!.path);
    File localImage = await File(pickImage.path).copy('$imagePath/$imageName');

    //บันทึก path รูปที่บันทึกเก็บไว้ในเครื่องลง SharedPreferences
    SharedPreferences prefer = await SharedPreferences.getInstance();
    prefer.setString('yourimage', localImage.path);
  }

  //เมธอดตรวจสอบว่า sharepreferences มีค่าหรือไม่ถ้ามีให้เอามาแสดงที่ TextFieldถ้าไม่มีก็ไม่ต้องทำอะไร
  check_and_show_data() async {
    //เริ่มจากสร้าง object ของ sharepreferences
    SharedPreferences prefer = await SharedPreferences.getInstance();

    //อ่านค่า Key ต่างๆ จาก SharedPreferences ว่าคีย์นั้นๆ มีไหม
    //ถ้ามีจะเก็บ True ในตัวแปร ถ้าไม่มีจะเก็บ False ในตัวแปร
    bool yournameKey = prefer.containsKey('yourname');
    bool yourphoneKey = prefer.containsKey('yourphone');
    bool youremailKey = prefer.containsKey('youremail');
    bool youraboutKey = prefer.containsKey('yourabout');
    bool yourimageKey = prefer.containsKey('yourimage');

    //ตรวจสอบ Key แล้วก็แสดงผลที่ TextField ผ่านตัว controller ที่สร้างไว้
    if (yournameKey == true) {
      setState(() {
        yournameCtrl.text = prefer.getString('yourname')!;
      });
    }

    if (yourphoneKey == true) {
      setState(() {
        yourphoneCtrl.text = prefer.getString('yourphone')!;
      });
    }

    if (youremailKey == true) {
      setState(() {
        youremailCtrl.text = prefer.getString('youremail')!;
      });
    }

    if (youraboutKey == true) {
      setState(() {
        youraboutCtrl.text = prefer.getString('yourabout')!;
      });
    }

    if (yourimageKey == true) {
      setState(() {
        _image = File(prefer.getString('yourimage')!);
      });
    }
  }

  //เมธอด initState นี้จะทำงานเป็นลำดับแรกทุกครั้้งที่หน้าจอนี้ถูกเปิดขึ้นมา
  @override
  void initState() {
    //จะตรวจสอบว่า sharepreferences มีค่าหรือไม่ถ้ามีให้เอามาแสดงที่ TextField ถ้าไม่มีก็ไม่ต้องทำอะไร
    check_and_show_data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text(
          'My Profile',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _image == null
                      ? Container(
                          height: MediaQuery.of(context).size.width * 0.5,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green,
                              width: 5.0,
                            ),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/myprofile.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.width * 0.5,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green,
                              width: 5.0,
                            ),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: FileImage(
                                _image!,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  IconButton(
                    onPressed: () {
                      getImageFromCameraAndSaveToSF();
                    },
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      size: MediaQuery.of(context).size.width * 0.08,
                      color: Colors.green[800],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 35.0,
                  left: 35.0,
                ),
                child: TextField(
                  controller: yournameCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    label: Text(
                      'Your name :',
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'Your name',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => YourNameUI(),
                          ),
                        ).then((value) {
                          check_and_show_data();
                        });
                      },
                      icon: Icon(
                        Icons.edit,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 35.0,
                  left: 35.0,
                ),
                child: TextField(
                  controller: yourphoneCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    label: Text(
                      'Your phone :',
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'Your phone',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => YourPhoneUI(),
                          ),
                        ).then((value) {
                          check_and_show_data();
                        });
                      },
                      icon: Icon(
                        Icons.edit,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 35.0,
                  left: 35.0,
                ),
                child: TextField(
                  controller: youremailCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    label: Text(
                      'Your email :',
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'Your email',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => YourEmail(),
                          ),
                        ).then((value) {
                          check_and_show_data();
                        });
                      },
                      icon: Icon(
                        Icons.edit,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 35.0,
                  left: 35.0,
                ),
                child: TextField(
                  controller: youraboutCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    label: Text(
                      'Your about :',
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'Your about',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => YourAboutUI(),
                          ),
                        ).then((value) {
                          check_and_show_data();
                        });
                      },
                      icon: Icon(
                        Icons.edit,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
