import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pfeappadmin/db/category.dart';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController categoryController = TextEditingController();

  GlobalKey<FormState> _categoryFormKey = GlobalKey();

  CategoryService _categoryService = CategoryService();

  bool isloading=false;

  File _imageCat;

  final picker = ImagePicker();
  Future getImageCat() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageCat = File(pickedFile.path);
    });
  }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      color: Colors.blueGrey,
      inAsyncCall: isloading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Category'),
        ),
        body: Form(
            key: _categoryFormKey,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text("Category images:",style: TextStyle(fontWeight: FontWeight.bold),)),
                ),

                AddPicture(
                  child:displayChild1() ,
                  onPress: (){
                    getImageCat();
                  },

                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text("Category images:",style: TextStyle(fontWeight: FontWeight.bold),)),
                ),
                TextFormField(

                  controller: categoryController,
                  validator: (value){
                    if(value.isEmpty){
                      return 'category cannot be empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: "add category",
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40,8,40,8),
                  child: FlatButton(
                    onPressed: () {
                      validateAndUpload();
                    },
                    child: Text(
                      "ADD CATEGORY",
                      style: TextStyle(
                        fontSize: 25,

                      ),
                    ),
                    color: Colors.deepOrange,
                    padding: EdgeInsets.all(20),

                  ),
                )
              ],
            ),
        ),
      ),
    );
  }

  Widget displayChild1() {
    if(_imageCat==null){
      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 25, 8, 25),
        child:Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    }else{
      return Image.file(_imageCat,fit: BoxFit.fill,);
    }
  }

  //========== Upload images ===============
  void validateAndUpload() async{
    if(_categoryFormKey.currentState.validate()){
      setState(() {
        isloading=true;
      });
      if(_imageCat != null ) {
        String imageUrl;

        final FirebaseStorage storage = FirebaseStorage.instance;

        final String picture1 ="1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
        StorageUploadTask task1=storage.ref().child(picture1).putFile(_imageCat);

        task1.onComplete.then((snapshot)async{
          imageUrl=await snapshot.ref.getDownloadURL();

          print("test 1: $imageUrl");

          _categoryService.createCategory(
            name: categoryController.text,
            picture: imageUrl,
          );
          _categoryFormKey.currentState.reset();
          setState(() {
            isloading=false;
          });
          Fluttertoast.showToast(msg: "Category added",
            backgroundColor: Colors.grey,
          );
          Navigator.pop(context);

        });

      }else {
        setState(() {
          isloading=false;
        });
        Fluttertoast.showToast(msg: "must upload the pictures");
      }
    }
  }
}
class AddPicture extends StatelessWidget {
  AddPicture({@required this.onPress,this.child});
  final child;
  final onPress;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlineButton(
        onPressed:onPress,
        child: child,
      ),
    );
  }


}