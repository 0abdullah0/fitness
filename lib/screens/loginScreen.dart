import 'package:fitness/constants.dart';
import 'package:fitness/providers.dart';
import 'package:fitness/screens/homeScreen.dart';
import 'package:fitness/screens/navigationScreen.dart';
import 'package:fitness/states/authentication_notifier.dart';
import 'package:fitness/widgets/Loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: ProviderListener(
          onChange:(context,state){
            if(state is AuthenticationError)
            {
              Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          provider: authenticationNotifierProvider.state,
          child: Consumer(
            builder: (context,watch,child){
              final state= watch(authenticationNotifierProvider.state);
              final traineeProvider=watch(TraineeDataProvider);
              if (state is AuthenticationInitial)
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    gradient: Constants.backgroundColor,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("assets/images/fitness.png",width: 300,height: 300,),
                        ),
                        SizedBox(height: 40.0,),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: TextField(
                            controller: _textController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.blue[300],
                              hintStyle: TextStyle(color: Colors.white),
                              hintText: "Enter your ID here",
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.black54,
                                    width: 3,
                                  )
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.black54,
                                    width: 3,
                                  )),
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.black54,
                                    width: 3,
                                  )),
                            ),
                          ),
                        ),
                        RaisedButton(
                            color: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.black54)
                            ),
                            onPressed:(){
                              if(_textController.text.isEmpty)
                                Scaffold.of(context).showSnackBar(SnackBar(content: Text("ID can't be empty",style: TextStyle(fontWeight: FontWeight.bold))));
                              else
                                context.read(authenticationNotifierProvider).authenticate_trainee(_textController.text);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Login",style: TextStyle(fontSize: 18.0,color: Colors.white),),
                                SizedBox(width: 5.0,),
                                Icon(Icons.lock_open_rounded,color: Colors.white,)
                              ],
                            )
                        ),
                        Visibility(
                          child: ColorLoader(),
                          visible: state is AuthenticationLoading,
                        )
                      ],
                    ),
                  ),
                );
              if(state is AuthenticationLoaded)
              {
                traineeProvider.set_trainee(state.trainee);
                //_textController.clear();
                if(state.trainee.name=="")
                  {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("WRONG ID")));
                    });
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        gradient: Constants.backgroundColor,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset("assets/images/fitness.png",width: 300,height: 300,),
                            ),
                            SizedBox(height: 40.0,),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextField(
                                controller: _textController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.blue[300],
                                  hintStyle: TextStyle(color: Colors.white),
                                  hintText: "Enter your ID here",
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                        color: Colors.black54,
                                        width: 3,
                                      )
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                        color: Colors.black54,
                                        width: 3,
                                      )),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                        color: Colors.black54,
                                        width: 3,
                                      )),
                                ),
                              ),
                            ),
                            RaisedButton(
                                color: Colors.blueGrey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.black54)
                                ),
                                onPressed:(){
                                  if(_textController.text.isEmpty)
                                    Scaffold.of(context).showSnackBar(SnackBar(content: Text("ID can't be empty",style: TextStyle(fontWeight: FontWeight.bold),)));
                                  else
                                    context.read(authenticationNotifierProvider).authenticate_trainee(_textController.text);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Login",style: TextStyle(fontSize: 18.0,color: Colors.white),),
                                    SizedBox(width: 5.0,),
                                    Icon(Icons.lock_open_rounded,color: Colors.white,)
                                  ],
                                )
                            ),
                            Visibility(
                              child: ColorLoader(),
                              visible: state is AuthenticationLoading,
                            )
                          ],
                        ),
                      ),
                    );
                  }
                else
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => NavigationScreen()));
                  });
              }
              return Container(
                height: MediaQuery.of(context).size.height ,
                width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: Constants.backgroundColor,
                  ),
                child: Center(
                  child: ColorLoader(),
                )
                ,
              );
            },
          ),
        )
      ),
    );
  }
}
