import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'create_page.dart';
import 'detail_post_page.dart';

class SearchPage extends StatelessWidget {
  final FirebaseUser user;
  SearchPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.create),
        onPressed: () {
          print('눌림');
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => CreatePage(user)));
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        'Instagram Clone',
        style: GoogleFonts.pacifico(),
      ),
    );
  }

  // Widget _buildBody(context) {
  //   print('search_page created');
  //   return Scaffold(
  //     body: GridView.builder(
  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 3,
  //           childAspectRatio: 1.0,
  //           mainAxisSpacing: 1.0,
  //           crossAxisSpacing: 1.0),
  //       itemCount: 3,
  //       itemBuilder: (BuildContext context, int index) {
  //         return _buildListItem();
  //       },
  //     ),
  //   );
  // }

  // Widget _buildListItem() {
  //   return Image.network(
  //     '',
  //     fit: BoxFit.cover,
  //   );
  // }

  Widget _buildBody(context) {
    // 그리드뷰를 이용한 화면 만들기
    return StreamBuilder(
      stream: Firestore.instance.collection('post').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var items = snapshot.data.documents ?? [];
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 열은 3개
                childAspectRatio: 1.0, // 비율, 정사각형
                mainAxisSpacing: 1.0, // 사이 간격 메인축
                crossAxisSpacing: 1.0), // 사이 간격 교차축
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _buildListItem(context, items[index]);
            });
      },
    );
  }

  // Widget _buildListItem(BuildContext context, int index) {
  //   return Image.network(
  //       'http://www.shinhangroup.com/kr/asset/images/pr_center/character/character_bigs_01.png',
  //       fit: BoxFit.cover);
  // }
  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return Hero(
      tag:document['photoUrl'],
      child: Material(
              child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailPostPage(document, user)),
            );
          },
          child: Image.network(document['photoUrl'], fit: BoxFit.cover),
        ),
      ),
    );
  }
}
