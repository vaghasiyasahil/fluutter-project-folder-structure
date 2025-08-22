import '../../export.dart';

class TabControllerX extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
  }

  void changeTab(int index) {
    tabController.index = index;
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TabControllerX controller = Get.put(TabControllerX());

    return Scaffold(
      appBar: AppBar(
        title: const Text('GetX TabController Example'),
        bottom: TabBar(
          controller: controller.tabController,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: "Home"),
            Tab(icon: Icon(Icons.search), text: "Search"),
            Tab(icon: Icon(Icons.person), text: "Profile"),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: const [
          Center(child: Text("Home Page")),
          Center(child: Text("Search Page")),
          Center(child: Text("Profile Page")),
        ],
      ),
    );
  }
}


