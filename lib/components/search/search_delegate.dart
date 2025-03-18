import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kunet_app/helper/preference/preference_manager.dart';
import 'package:kunet_app/helper/state/state_manager.dart';

class CustomSearchDelegate extends SearchDelegate {
  final PreferenceManager manager;
  final _controller = Get.find<StateController>();
// Demo list to show querying
  List<String> searchTerms = [
    "Apple",
    "Banana",
  ];

  CustomSearchDelegate({required this.manager});

// first overwrite to
// clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

// second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    // debugPrint("ACC TOKN :: ${manager.getAccessToken()}");
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

// third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    // List<String> matchQuery = [];A
    // for (var fruit in searchTerms) {
    //   if (fruit.toLowerCase().contains(query.toLowerCase())) {
    //     matchQuery.add(fruit);
    //   }
    // }

    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return Container(
      color: Colors.red,
      width: double.infinity,
      height: 200,
    );
  }

// last overwrite to show the
// querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox();
    // query.isEmpty
    //     ? const SizedBox()
    //     : FutureBuilder<http.Response>(
    // future: APIService().getSearchResults(
    //     manager.getAccessToken(), query.toLowerCase()),
    // builder: (context, snapshot) {
    //   if (snapshot.connectionState == ConnectionState.waiting) {
    //     return ListView.separated(
    //       itemCount: 5,
    //       separatorBuilder: (BuildContext context, int index) {
    //         return const SizedBox(height: 21);
    //       },
    //       itemBuilder: (BuildContext context, int index) {
    //         return const SizedBox(
    //           height: 28,
    //           child: BannerShimmer(),
    //         );
    //       },
    //     );
    //   }

    //   if (snapshot.hasError) {
    //     return const Center(
    //       child:
    //           Text("An error occured. Check your internet connection!"),
    //     );
    //   }

    //   if (!snapshot.hasData) {
    //     return const Center(
    //       child: Text("No data found!"),
    //     );
    //   }

    //   final data = snapshot.data;
    //   debugPrint("SEARCH DATA RESPONSE >> ${data!.body}");
    //   Map<String, dynamic> map = jsonDecode(data.body);

    //   return ListView.builder(
    // itemCount: map['data']?.length,
    // itemBuilder: (context, index) {
    //   // var result = matchQuery[index];
    //   return ListTile(
    //     onTap: () {
    //       // Navigator.push(
    //       //   context,
    //       //   MaterialPageRoute(
    //       //     builder: (context) => map['data'][index]['email'] ==
    //       //             manager.getUser()['email']
    //       //         ? MyProfile(manager: manager)
    //       //         : UserProfile(
    //       //             manager: manager,
    //       //             data: map['data'][index],
    //       //             triggerHire: false,
    //       //           ),
    //       //   ),
    //       // );
    //     },
    //     title: Row(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         ClipOval(
    //           child: Image.network(
    //             "${map['data'][index]['bio']['image']}",
    //             width: 48,
    //             height: 48,
    //             fit: BoxFit.cover,
    //             errorBuilder: (context, error, stackTrace) =>
    //                 SvgPicture.asset(
    //               "assets/images/personal.svg",
    //               width: 48,
    //               height: 48,
    //               fit: BoxFit.cover,
    //             ),
    //           ),
    //         ),
    //         const SizedBox(width: 10.0),
    //         Column(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             TextSmall(
    //               text:
    //                   "${map['data'][index]['bio']['firstname']} ${map['data'][index]['bio']['middlename']} ${map['data'][index]['bio']['lastname']}"
    //                       .capitalize,
    //               fontWeight: FontWeight.w600,
    //             ),
    //             TextBody1(
    //               text:
    //                   "${map['data'][index]['accountType'].toString().toLowerCase() == "professional" ? "Professional" : "Recruiter"} - ${map['data'][index]['reviews']?.length} reviews",
    //             )
    //               ],
    //             )
    //           ],
    //         ),
    //       );
    //     },
    //   );
    // },
    // );
  }
}
