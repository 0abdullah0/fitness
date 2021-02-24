import 'package:badges/badges.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:fitness/constants.dart';
import 'package:fitness/providers.dart';
import 'package:fitness/states/subscription_notifier.dart';
import 'package:fitness/widgets/Loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dateTime = DateTime.now();
  Icon expansionIcon =Icon(Icons.arrow_circle_down,size: 35,color: Colors.orange);
  bool expansionIconFlip=true;
  String times_of_work="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(dateTime.format(AmericanDateFormats.dayOfWeek).contains("Friday"))
      times_of_work=" From 1.00 pm to 9.00 pm ";
    else
      times_of_work=" From 12.00 pm to 1.00 am ";
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await context.read(subscriptionNotifierProvider).fetch_subscriptions();
    });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: Constants.backgroundColor,
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child:Column(
          children: [
            SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/4,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new ExactAssetImage('assets/images/fitness_home.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0,),
             Flexible(
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.grey[800],
                          child: ListTile(
                            title: Text("${dateTime.format(AmericanDateFormats.dayOfWeek)}",style: TextStyle(color: Colors.blue,fontSize: 18),),
                            subtitle: Text("Times of work :${times_of_work}",style: TextStyle(color: Colors.white,fontSize: 16),) ,
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        ProviderListener(
                            onChange: (context,state){
                              if(state is SubscriptionsError)
                              {
                                Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                              }
                            },
                          provider:subscriptionNotifierProvider.state,
                          child: Consumer(
                            builder: (context,watch,child){
                              final state= watch(subscriptionNotifierProvider.state);
                              if(state is SubscriptionsLoading)
                                return ColorLoader();
                              else if(state is SubscriptionsLoaded)
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Card(
                                    elevation: 8.0,
                                    color: state.subscriptions.length>0 ? Colors.grey[800]: Colors.black54,
                                    child: state.subscriptions.length>0 ? ExpansionTile
                                      (
                                      onExpansionChanged: (_){
                                        setState(() {
                                          if(expansionIconFlip)
                                            {
                                              expansionIcon =Icon(Icons.arrow_circle_up,size: 35,color: Colors.orange);
                                              expansionIconFlip=false;
                                            }
                                          else
                                            {
                                              expansionIcon =Icon(Icons.arrow_circle_down,size: 35,color: Colors.orange);
                                              expansionIconFlip=true;

                                            }
                                        });
                                      },
                                      trailing: expansionIcon,
                                      title: Text("Current Subscriptions",style: TextStyle(color: Colors.white,fontSize: 20),),
                                      children: state.subscriptions.map((subscription) {
                                        String freezed =subscription.freeze_availbilty ? "Yes": "No";
                                        String offer="";
                                        if(subscription.hasOffer){
                                          offer="+ (OFFER ^_^) : ${subscription.offer_description}";
                                        }
                                        return Badge(
                                          showBadge: subscription.hasOffer ,
                                          badgeColor:Colors.green,
                                          badgeContent: Icon(Icons.card_giftcard,color: Colors.white,size: 15,),
                                          position: BadgePosition.topEnd(end: 8,top: 1),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                            ),
                                            color: Colors.black54,
                                            child: ListTile(
                                              trailing: Text("Freeze ? ${freezed}",style: TextStyle(color: Colors.white),),
                                              title: Text("${subscription.price} EGP per ${subscription.duration}",style: TextStyle(color: Colors.blue,fontSize: 18),),
                                              subtitle: Text("${subscription.subscription_description} ${offer}",style: TextStyle(color: Colors.white,fontSize: 16),) ,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ): Text("No Subscriptions Now",style: TextStyle(color: Colors.red,fontSize: 20.0,fontWeight: FontWeight.bold),)
                                  ),
                                );
                              return Container();
                            },
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        SizedBox(
                          height: 130,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              Image.asset("assets/images/hall.png",width: 100,height: 100),
                              SizedBox(width: 10.0,),
                              Image.asset("assets/images/bodybuilding.png",width: 90,height: 50),
                              SizedBox(width: 10.0,),
                              Image.asset("assets/images/tips.png",width: 150,height: 150),
                              SizedBox(width: 10.0,),
                              Image.asset("assets/images/equipment.png",width: 150,height: 150),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
            )
          ],
        ) ,
      ),
    );
  }
}
