import 'package:fitness/constants.dart';
import 'package:fitness/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String freezed;
  String attened;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(context.read(TraineeDataProvider).trainee.isAttened)
        attened="Yes";
    else
      attened="No";
    if(context.read(TraineeDataProvider).trainee.isFreezed)
      freezed="Yes";
    else
      freezed="No";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Constants.backgroundColor,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Consumer(
            builder: (context,watch,child){
              final traineeDataProvider=watch(TraineeDataProvider);
              return Column(
                children: [
                  SizedBox(height: 10.0,),
                  QrImage(
                    backgroundColor: Colors.white,
                    data: "${traineeDataProvider.trainee.id}",
                    version: QrVersions.auto,
                    size: 250.0,
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Colors.transparent,
                              child: ListTile(
                                title: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: ClipRRect(
                                    child: Image.asset('assets/images/avatar.png'),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  radius: 30.0,//radius of the circle avatar
                                ),
                                subtitle: Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Name: ${traineeDataProvider.trainee.name}",style: TextStyle(color: Colors.white,fontSize: 20),),
                                        Text("Phone: ${traineeDataProvider.trainee.phone}",style: TextStyle(color: Colors.white,fontSize: 20),),
                                        Text("Gender: ${traineeDataProvider.trainee.gender}",style: TextStyle(color: Colors.white,fontSize: 20),),
                                        Text("Age: ${traineeDataProvider.trainee.age}",style: TextStyle(color: Colors.white,fontSize: 20),),
                                        Text("Region: ${traineeDataProvider.trainee.region}",style: TextStyle(color: Colors.white,fontSize: 20),),
                                        SizedBox(height: 20.0,),
                                        Text("Freezed ? ${freezed}",style: TextStyle(color: Colors.blue,fontSize: 20),),
                                        Text("Attend Today ? ${attened}",style: TextStyle(color: Colors.blue,fontSize: 20),),
                                      ],
                                    )
                                ) ,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
