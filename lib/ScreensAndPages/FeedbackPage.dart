import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController sampledata1 = new TextEditingController();
  TextEditingController sampledata2 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2b3f5c),
        centerTitle: true,
        elevation: 50.0,
        title: Text('WallClod',
          style: TextStyle(letterSpacing: 5, fontFamily: 'Pacifico'),),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),),
      ),
      backgroundColor: Color(0xFF272727),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0, bottom: 5.0,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.feedback,
                      color: Colors.yellowAccent,
                    ),
                    SizedBox(width: 10.0,),
                    Text("Help and support Center",
                      style: TextStyle(
                        fontSize: 17,
                        letterSpacing: 3,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: sampledata1,
                  style: TextStyle(color: Colors.white),
                  validator: (String value) {
                    if (value.isEmpty ||value == null) {
                      return 'Topic cannot be empty';
                    } else if (value.length < 3) {
                      return 'Topic must be at least 3 characters long.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Title of discussion' ,
                    hintStyle: TextStyle(fontSize: 11,color: Colors.white54),
                    prefixIcon: const Icon(Icons.topic, color: Colors.yellowAccent,),
                    labelText: 'Topic',labelStyle: TextStyle(fontSize: 12,color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: sampledata2,
                  style: TextStyle(color: Colors.white),
                  validator: (String value) {
                    if (value.isEmpty || value == null) {
                      return 'Comments cannot be empty';
                    } else if (value.length < 3) {
                      return 'Comments must be at least 3 characters long.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'We would be more than happy to hear from you' ,
                    hintStyle: TextStyle(fontSize: 11,color: Colors.white54),
                    prefixIcon: const Icon(Icons.help_center, color: Colors.yellowAccent,),
                    labelText: 'Comments',labelStyle: TextStyle(fontSize: 12,color: Colors.white),
                    helperText: "Please keep it short and to the point",
                    helperStyle: TextStyle(fontSize: 10,color: Colors.white30),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  maxLines: 5,
                ),
              ),

              SizedBox(height: 15.0,),
              Center(
                child: ElevatedButton(
                  onPressed: () async{
                    saveFeedback();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellowAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(color: Colors.yellow,width: 2)
                    ),
                    shadowColor: Colors.yellow,
                    elevation: 7,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 10.0,bottom: 10.0),
                    child: Text("Submit",style: TextStyle(fontSize: 15,color: Colors.black),),
                  ),

                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
  void saveFeedback(){
    final FormState form = _formKey.currentState;
    if(form.validate()) {
      Map<String, String> data = {
        "Topic": sampledata1.text,
        "Feedback": sampledata2.text
      };
      FirebaseFirestore.instance.collection("Help And Support").add(data);
      form.reset();
    }
  }
}
