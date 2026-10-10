import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:picklaundry/services/auth_service.dart';
import '../models/user_model.dart';


class UsersScreen extends StatefulWidget {

  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();

}


class _UsersScreenState extends State<UsersScreen>
    with SingleTickerProviderStateMixin {


  final AuthService userService = AuthService();

  List<UserModel> users = [];

  bool loading = true;


  late AnimationController animationController;



  @override
  void initState() {

    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );


    loadUsers();

  }



  Future<void> loadUsers() async {


    try {

      users = await userService.getAllUsers();


      animationController.forward();


      setState(() {
        loading = false;
      });


    } catch(e){

      print(e);

      setState(() {
        loading = false;
      });

    }

  }



  @override
  void dispose(){

    animationController.dispose();

    super.dispose();

  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor: const Color(0xff081120),


      appBar: AppBar(

        title: Text(
          "All Users",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold
          ),
        ),

        backgroundColor: Colors.transparent,

        elevation:0,

      ),



      body:


      loading

      ?

      const Center(
        child:CircularProgressIndicator(
          color: Colors.teal,
        ),
      )


      :


      users.isEmpty

      ?

      const Center(
        child: Text(
          "No Users Found",
          style: TextStyle(
              color: Colors.white
          ),
        ),
      )



      :


      ListView.builder(

        padding: const EdgeInsets.all(16),


        itemCount: users.length,


        itemBuilder:(context,index){


          final user = users[index];



          return AnimatedBuilder(

            animation: animationController,


            builder:(context,child){


              return Transform.translate(

                offset: Offset(
                    0,
                    50*(1-animationController.value)
                ),


                child: Opacity(

                  opacity: animationController.value,


                  child: child,


                ),

              );


            },



            child:userCard(user),


          );


        },


      ),


    );


  }







Widget userCard(UserModel user){


return Container(


margin: const EdgeInsets.only(
    bottom:15
),


padding: const EdgeInsets.all(18),


decoration: BoxDecoration(


color: const Color(0xff162033),


borderRadius: BorderRadius.circular(25),


boxShadow:[

BoxShadow(

color:Colors.black.withOpacity(.3),

blurRadius:15,

offset:const Offset(0,8)

)

]


),



child:Column(

crossAxisAlignment: CrossAxisAlignment.start,


children:[



Row(

children:[



CircleAvatar(

radius:28,

backgroundColor:Colors.teal,


child:Text(

user.fullName[0].toUpperCase(),

style:const TextStyle(

fontSize:25,

fontWeight:FontWeight.bold,

color:Colors.white

),

),


),


const SizedBox(width:15),




Expanded(

child:Column(

crossAxisAlignment:CrossAxisAlignment.start,


children:[


Text(

user.fullName,

style:GoogleFonts.poppins(

color:Colors.white,

fontSize:18,

fontWeight:FontWeight.bold

),

),



Container(

padding:const EdgeInsets.symmetric(
horizontal:12,
vertical:5
),


decoration:BoxDecoration(

color:user.role=="CUSTOMER"

?

Colors.green.withOpacity(.2)

:

Colors.orange.withOpacity(.2),


borderRadius:BorderRadius.circular(20)

),


child:Text(

user.role,

style:TextStyle(

color:user.role=="CUSTOMER"

?Colors.green

:Colors.orange,


fontWeight:FontWeight.bold

),

),

)



],

),

)


],

),



const SizedBox(height:20),




info(
Icons.phone,
user.mobile
),


const SizedBox(height:10),



info(
Icons.email,
user.email
),



const SizedBox(height:10),



info(
Icons.verified_user,
user.active?"Active":"Inactive"
),



],

),


);


}





Widget info(
IconData icon,
String text
){

return Row(

children:[


Icon(
icon,
color:Colors.teal,
size:20,
),


const SizedBox(width:10),



Expanded(

child:Text(

text,

style:GoogleFonts.poppins(

color:Colors.white70,

fontSize:14

),

),

)



],

);


}



}