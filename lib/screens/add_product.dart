
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pfeappadmin/db/brand.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pfeappadmin/db/category.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pfeappadmin/db/product.dart';

class AddProduct extends StatefulWidget {
  static final String id = "add_product";
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  //============= declaration des variables ==================

  ProductService _productService =ProductService();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var productNameControl = TextEditingController();
  var qteControl = TextEditingController();
  var priceControl=TextEditingController();
  var descriptionControl=TextEditingController();

  List<DropdownMenuItem<String>> _dropDownMenuCategory;
  List<DropdownMenuItem<String>> _dropDownMenuBrand;

  String _selectCategory;
  String _selectBrand;

  Firestore _firestore = Firestore.instance;

  List<String> selectedSize = <String>[];

  bool isloading = false;
//============== Image Picker =========================
  File _image1;
  File _image2;
  File _image3;
  final picker = ImagePicker();
  Future getImage1() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image1 = File(pickedFile.path);
    });
  }
  Future getImage2() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image2 = File(pickedFile.path);
    });
  }
  Future getImage3() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image3 = File(pickedFile.path);
    });
  }

//=================== initiale state =======================
  @override
  void initState() {
    super.initState();
    buildDropDownMenuCat().then((val) {
      setState(() {});
      print("category success");
    }).catchError((error, stackTrace) {
      print("outer: $error");
    });
    buildDropDownMenuBrand().then((val) {
      setState(() {});
      print("brand success");
    }).catchError((error, stackTrace) {
      print("outer: $error");
    });
  }

//================ category menu ==============================

  Future buildDropDownMenuCat() async {
    List<DropdownMenuItem<String>> items = List();
    await _firestore.collection("categories").getDocuments().then((value) {
      for (DocumentSnapshot category in value.documents) {
        items.add(DropdownMenuItem(
          value: category.data['category'],
          child: Text('${category.data['category']}'),
        ));
      }
    });

    _dropDownMenuCategory = items;
    _selectCategory = _dropDownMenuCategory[0].value;
  }

  onChangeDropDownCat(String selectedCategory) {
    setState(() {
      _selectCategory = selectedCategory;
    });
  }

  //=================== brand menu ===================================

  Future buildDropDownMenuBrand() async {
    List<DropdownMenuItem<String>> items = List();
    await _firestore.collection("brands").getDocuments().then((value) {
      for (DocumentSnapshot category in value.documents) {
        items.add(DropdownMenuItem(
          value: category.data['brand'],
          child: Text('${category.data['brand']}'),
        ));
      }
    });

    _dropDownMenuBrand = items;
    _selectBrand = _dropDownMenuBrand[0].value;
  }

  onChangeDropDownBrand(String selectedbrand) {
    setState(() {
      _selectBrand = selectedbrand;
    });
  }

//=================== Scaffold==========================

  @override
  Widget build(BuildContext context) {

    return ModalProgressHUD(
      color: Colors.blueGrey,
      inAsyncCall: isloading,
      child: Scaffold(

        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Add Product",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),

        body: Form(
          key: _formKey,
          child:ListView(
            children: <Widget>[
              // ============ ADD Pictures ==============
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Add 3 pictures :",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: AddPicture(
                      onPress: (){
                        getImage1();
                      },
                      child: displayChild1(),
                    ),
                  ),

                  Expanded(
                    child: AddPicture(
                      child: displayChild2(),
                      onPress: (){
                        getImage2();
                      },
                    ),
                  ),

                  Expanded(
                    child: AddPicture(
                      child: displayChild3(),
                      onPress: (){
                        getImage3();
                      },
                    ),
                  ),

                ],
              ),

              // =============== Product name =============

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: productNameControl,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey, width: 2)),
                    hintText: 'product name',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "you must enter the product name";
                    }
                    return null;
                  },
                ),
              ),

              //============= Categories============

              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("select product's category : "),
                  ),
                  DropdownButton(
                    value: _selectCategory,
                    items: _dropDownMenuCategory,
                    onChanged: onChangeDropDownCat,
                  ),
                ],
              ),

              //============= Brand =================

              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("select product's brand : "),
                  ),
                  DropdownButton(
                    value: _selectBrand,
                    items: _dropDownMenuBrand,
                    onChanged: onChangeDropDownBrand,
                  ),
                ],
              ),

              //============= Quantité =============

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.numberWithOptions(),
                  controller: qteControl,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey, width: 2)),
                    hintText: 'product quantity',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "you must enter the product quantity";
                    }
                    return null;
                  },
                ),
              ),

              //============= price =============

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.numberWithOptions(),
                  controller: priceControl,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey, width: 2)),
                    hintText: 'Product Price',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "you must enter the price";
                    }
                    return null;
                  },
                ),
              ),

              //============ Description ===================

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: descriptionControl,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey, width: 2)),
                    hintText: 'Product description',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "you must enter the description";
                    }
                    return null;
                  },
                ),
              ),

              // =============== Select Size ===============

              Text(
                "Available Size : ",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: selectedSize.contains("XS") ,
                    onChanged: (value)=>changeSelectedSize("XS"),
                    activeColor: Colors.deepOrange,
                  ),
                  Text("XS"),
                  Checkbox(
                    value: selectedSize.contains("S") ,
                    onChanged: (value)=>changeSelectedSize("S"),
                    activeColor: Colors.deepOrange,
                  ),
                  Text("S"),
                  Checkbox(
                    value: selectedSize.contains("M") ,
                    onChanged: (value)=>changeSelectedSize("M"),
                    activeColor: Colors.deepOrange,
                  ),
                  Text("M"),
                  Checkbox(
                    value: selectedSize.contains("L") ,
                    onChanged: (value)=>changeSelectedSize("L"),
                    activeColor: Colors.deepOrange,
                  ),
                  Text("L"),
                  Checkbox(
                    value: selectedSize.contains("XL") ,
                    onChanged: (value)=>changeSelectedSize("XL"),
                    activeColor: Colors.deepOrange,
                  ),
                  Text("XL"),


                ],
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: selectedSize.contains("XXL") ,
                    onChanged: (value)=>changeSelectedSize("XXL"),
                    activeColor: Colors.deepOrange,
                  ),
                  Text("XXL"),
                  Checkbox(
                    value: selectedSize.contains("XXXL") ,
                    onChanged: (value)=>changeSelectedSize("XXXL"),
                    activeColor: Colors.deepOrange,
                  ),
                  Text("XXXL"),
                ],
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: selectedSize.contains("28") ,
                    onChanged: (value)=>changeSelectedSize("28"),
                    activeColor: Colors.deepOrange,
                  ),
                  Text("28"),
                  Checkbox(
                    value: selectedSize.contains("30") ,
                    onChanged: (value)=>changeSelectedSize("30"),
                    activeColor: Colors.deepOrange,
                  ),
                  Text("30"),
                  Checkbox(
                    value: selectedSize.contains("32") ,
                    onChanged: (value)=>changeSelectedSize("32"),
                    activeColor: Colors.deepOrange,
                  ),
                  Text("32"),
                  Checkbox(
                    value: selectedSize.contains("34") ,
                    onChanged: (value)=>changeSelectedSize("34"),
                    activeColor: Colors.deepOrange,
                  ),
                  Text("34"),
                  Checkbox(
                    value: selectedSize.contains("36") ,
                    onChanged: (value)=>changeSelectedSize("36"),
                    activeColor: Colors.deepOrange,
                  ),
                  Text("36"),
                ],
              ),
              Row(
                children: <Widget>[

                  Checkbox(
                    value: selectedSize.contains("40") ,
                    onChanged: (value)=>changeSelectedSize("40"),
                    activeColor: Colors.deepOrange,
                  ),
                  Text("40"),
                  Checkbox(
                    value: selectedSize.contains("41") ,
                    onChanged: (value)=>changeSelectedSize("41"),
                    activeColor: Colors.deepOrange,
                  ),
                  Text("41"),
                  Checkbox(
                    value: selectedSize.contains("42") ,
                    onChanged: (value)=>changeSelectedSize("42"),
                    activeColor: Colors.deepOrange,
                  ),
                  Text("42"),
                  Checkbox(
                    value: selectedSize.contains("43") ,
                    onChanged: (value)=>changeSelectedSize("43"),
                    activeColor: Colors.deepOrange,
                  ),
                  Text("43"),
                  Checkbox(
                    value: selectedSize.contains("44") ,
                    onChanged: (value)=>changeSelectedSize("44"),
                    activeColor: Colors.deepOrange,
                  ),
                  Text("44"),

                ],
              ),

              //============= validation bouton ========

              Padding(
                padding: const EdgeInsets.fromLTRB(40,8,40,8),
                child: FlatButton(
                  onPressed: () {
                    validateAndUpload();
                  },
                  child: Text(
                    "VALIDER",
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

  changeSelectedSize( String s) {
    if(selectedSize.contains(s)) {
      setState(() {
        selectedSize.remove(s);
      });
    }else{
      setState(() {
        selectedSize.insert(0, s);
      });
    }
  }

// ========== display images widgets =============
  Widget displayChild1() {
    if(_image1==null){
      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 25, 8, 25),
        child:Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    }else{
      return Image.file(_image1,fit: BoxFit.fill,);
    }
  }
  Widget displayChild2() {
    if(_image2==null){
      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 25, 8, 25),
        child:Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    }else{
      return Image.file(_image2,fit: BoxFit.fill,);
    }
  }
  Widget displayChild3() {
    if(_image3==null){
      return Padding(
        padding: const EdgeInsets.fromLTRB(8, 25, 8, 25),
        child:Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    }else{
      return Image.file(_image3,fit: BoxFit.fill);
    }
  }

  //========== Upload images ===============
  void validateAndUpload() async{
    if(_formKey.currentState.validate()){
      setState(() {
        isloading=true;
      });
      if(_image1 != null && _image2 != null && _image3 != null) {
        if(selectedSize.isNotEmpty) {
          String imageUrl1;
          String imageUrl2;
          String imageUrl3;
          final FirebaseStorage storage = FirebaseStorage.instance;

          final String picture1 ="1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          StorageUploadTask task1=storage.ref().child(picture1).putFile(_image1);
          final String picture2 ="2${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          StorageUploadTask task2=storage.ref().child(picture2).putFile(_image2);
          final String picture3 ="3${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          StorageUploadTask task3 =storage.ref().child(picture3).putFile(_image3);

          StorageTaskSnapshot snapshot1=await task1.onComplete.then((snapshot)=>snapshot);
          StorageTaskSnapshot snapshot2=await task2.onComplete.then((snapshot)=>snapshot);

          task3.onComplete.then((snapshot3)async{
            imageUrl1=await snapshot1.ref.getDownloadURL();
            imageUrl2=await snapshot2.ref.getDownloadURL();
            imageUrl3=await snapshot3.ref.getDownloadURL();
            print("test 1: $imageUrl1");
            print("test 2: $imageUrl2");
            print("test 3: $imageUrl3");
            List<String> imageList = [imageUrl1,imageUrl2,imageUrl3];
            _productService.createProduct(
              name: productNameControl.text,
              price: priceControl.text,
              sizes: FieldValue.arrayUnion(selectedSize) ,
              images:FieldValue.arrayUnion(imageList)  ,
              qte: int.parse(qteControl.text),
              cat: _selectCategory,
              brand: _selectBrand,
              description: descriptionControl.text,
            );
            _formKey.currentState.reset();
            setState(() {
              isloading=false;
            });
            Fluttertoast.showToast(msg: "Product added",
              backgroundColor: Colors.grey,
            );
            Navigator.pop(context);

          });


        }else {
          setState(() {
            isloading=false;
          });
          Fluttertoast.showToast(msg: "Size must be selected");
        }
      }else {
        setState(() {
          isloading=false;
        });
        Fluttertoast.showToast(msg: "must upload the 3 pictures");
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
