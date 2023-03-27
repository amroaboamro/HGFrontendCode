import 'package:flutter/material.dart';
import 'profileDetails.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        // leading: InkWell(
        //   onTap: () {
        //     Navigator.pop(context);
        //   },
        //   child: Icon(
        //     Icons.arrow_back_ios_outlined,
        //     color: Colors.grey[700],
        //     size: 18,
        //   ),
        // ),
        title: Text(
          'Allan Paterson',

        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              'https://static.thenounproject.com/png/658625-200.png',
              width: 35,
            ),
          )
        ],
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 22.0, top: 10),
                  child: Icon(
                    Icons.card_giftcard,
                    color: Colors.blue[600],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 10),
                  child: Text(
                    'Bio',

                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 25, left: 25, right: 25, bottom: 10),
              child: Text(
                'I lead innovation, design and digital transformation using technology. I am techincal advicer to technical fronthead. I work along side with Google people.',

                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_search_outlined,
                        color: Colors.greenAccent,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 4),
                        child: Text(
                          'Connections',

                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 14),
                  child: Text(
                    '12 mutual',

                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 130,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Material(
                          elevation: 6,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              height: 70,
                              width: 70,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  'https://bloximages.newyork1.vip.townnews.com/roanoke.com/content/tncms/assets/v3/editorial/d/da/ddac1f83-ffae-5e84-a8e5-e71f8ff18119/5f3176da21b5c.image.jpg?crop=650%2C650%2C175%2C0&resize=1200%2C1200&order=crop%2Cresize',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(
                            'Amy\nPatterson',

                            textAlign: TextAlign.center,
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Material(
                          elevation: 6,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              height: 70,
                              width: 70,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  'https://cdn.psychologytoday.com/sites/default/files/styles/image-article_inline_full/public/field_blog_entry_images/2018-09/shutterstock_648907024.jpg?itok=ji6Xj8tv',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 10),
                          child: Text(
                            'Buttle\nBenzos',

                            textAlign: TextAlign.center,
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Material(
                          elevation: 6,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              height: 70,
                              width: 70,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  'https://www.theglobeandmail.com/resizer/a1tsouRgbsPGVK8OvdFYJqxNhEo=/4415x0/filters:quality(80)/arc-anglerfish-tgam-prod-tgam.s3.amazonaws.com/public/5HSZVXDII5BRRHH4S6KE4WZ7RE.jpg',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 10),
                          child: Text(
                            'Trump\nDonald',

                            textAlign: TextAlign.center,
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Material(
                          elevation: 6,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              height: 70,
                              width: 70,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  'https://www.readersdigest.ca/wp-content/uploads/2017/08/being-a-good-person.jpg',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 10),
                          child: Text(
                            'Amy\nPatterson',

                            textAlign: TextAlign.center,
                          )),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Material(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
              elevation: 2,
              child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width / 1.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Center(
                      child: Text(
                        'View All',

                        textAlign: TextAlign.center,
                      ))),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Icon(
                    Icons.person_search_outlined,
                    color: Colors.orange[400],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 4),
                    child: Text(
                      'Sound Bytes',

                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                height: 87,
                width: MediaQuery.of(context).size.width / 1.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, top: 13),
                          child: Text(
                            'Tips For Bloggers Pro',

                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Container(
                                // height: 100,
                                // width: MediaQuery.of(context).size.width / 1.1,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(color: Colors.orange.shade400),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12, top: 4, bottom: 4),
                                  child: Text(
                                    'Advice',

                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Oct 6 - 7:21',

                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 15.0,
                      ),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.orange[400],
                              borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                          )),
                    )
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            Container(
                height: 87,
                width: MediaQuery.of(context).size.width / 1.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, top: 13),
                          child: Text(
                            'New Video For Editors',

                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Container(
                                // height: 100,
                                // width: MediaQuery.of(context).size.width / 1.1,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(color: Colors.orange.shade400),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12, top: 4, bottom: 4),
                                  child: Text(
                                    'Pro Tip',

                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Oct 8 - 8:50',

                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 15.0,
                      ),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.orange[400],
                              borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                          )),
                    )
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_activity,
                        color: Colors.purple,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 0),
                        child: Text(
                          'My activity',

                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 14),
                  child: Text(
                    'View All',

                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                color: Colors.white,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new ProfileDetails(),
                );

                Navigator.of(context).push(route);
              },
              child: Material(
                color: Colors.orange,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                elevation: 2,
                child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.orange, width: 1),
                    ),
                    child: Center(
                        child: Text(
                          'My Profile Details',

                          textAlign: TextAlign.center,
                        ))),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}