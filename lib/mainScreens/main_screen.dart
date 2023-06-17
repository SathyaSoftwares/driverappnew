import 'package:driverappnew/tabPages/earning_tab.dart';
import 'package:driverappnew/tabPages/home_tab.dart';
import 'package:driverappnew/tabPages/profile_tab.dart';
import 'package:driverappnew/tabPages/rating_tab.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin{

  TabController? tabController;
  int selectedIndex = 0;

  onItemClicked(int index){
    setState(() {
      selectedIndex=index;
      tabController!.index = selectedIndex;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController=TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const[
          HomeTabPage(),
          EarningTabPage(),
          //RatingTabPage(),
          ProfileTabPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label: "Earnings"
          ),
          /*BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: "Ratings"
          ),*/
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Account"
          )
        ],
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.black,
        backgroundColor: Color(0xFFe2fefc),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
    );
  }
}
