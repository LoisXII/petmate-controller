import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_transition/page_transition.dart';

class MyStoreTemplate extends StatelessWidget {
  int index;

  MyStoreTemplate({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    double mainw = MediaQuery.of(context).size.width;
    double mainh = MediaQuery.of(context).size.height;

    List<String> Images = [
      "https://i.pinimg.com/564x/ec/c6/4b/ecc64b742cfb907f60b1d5d2b3aec91a.jpg",
      "https://i.pinimg.com/564x/9c/3a/13/9c3a136a459391178f955e785e0a7698.jpg",
      "https://i.pinimg.com/736x/b3/c0/29/b3c02933b8e9ec8ec3478ae702f2a8a8.jpg",
      "https://i.pinimg.com/736x/22/f6/6c/22f66c7693b09bc828371b182fcea298.jpg",
      "https://i.pinimg.com/564x/61/b1/85/61b18522db35f3d2d9754a5660c9ce0c.jpg",
      "https://i.pinimg.com/564x/54/ad/d9/54add9a91d29a7a29a772e3ec6a513d7.jpg"
    ];
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(top: mainh * 0.03),
        width: mainw * .95,
        height: mainh * .15,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(1.5, 1.5),
              blurRadius: 2.5,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(-1.5, -1.5),
              blurRadius: 2.5,
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) => Row(
            children: [
              // space .
              SizedBox(
                width: constraints.maxWidth * 0.025,
                height: constraints.maxHeight,
              ),

              // image of store .
              Container(
                width: constraints.maxWidth * .35,
                height: constraints.maxHeight * .85,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      offset: Offset(1, 1),
                      blurRadius: 6,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      offset: Offset(-1, -1),
                      blurRadius: 6,
                    ),
                  ],
                  color: Colors.black,
                  image: DecorationImage(
                      image: NetworkImage(Images[index]), fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),

              // space .
              SizedBox(
                width: constraints.maxWidth * 0.025,
                height: constraints.maxHeight,
              ),

              // details .
              Container(
                width: constraints.maxWidth * .60,
                height: constraints.maxHeight,
                color: Colors.transparent,
                child: LayoutBuilder(
                  builder: (context, constraints) => Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // store name .
                      Container(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight * .30,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          "PET Mate Store ",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: constraints.maxHeight * .30 * .55,
                              ),
                        ),
                      ),

                      // horizental line .
                      Divider(
                        color: Colors.black.withOpacity(0.05),
                        endIndent: constraints.maxWidth * 0.025,
                        indent: constraints.maxWidth * 0.025,
                        thickness: 1,
                        height: constraints.maxHeight * 0.05,
                      ),

                      // rating + rating count
                      Container(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight * .35,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: LayoutBuilder(
                              builder: (context, constraints) => Row(
                                    children: [
                                      // rating .
                                      Container(
                                        width: constraints.maxWidth * .80,
                                        height: constraints.maxHeight,
                                        color: Colors.transparent,
                                        alignment: Alignment.center,
                                        child: RatingBarIndicator(
                                          rating: 4,
                                          itemCount: 5,
                                          itemSize: constraints.maxHeight * .60,
                                          itemBuilder: (context, index) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                          ),
                                        ),
                                      ),

                                      // rating count .
                                      Container(
                                        width: constraints.maxWidth * .20,
                                        height: constraints.maxHeight,
                                        color: Colors.transparent,
                                        alignment: Alignment.centerLeft,
                                        child: AutoSizeText(
                                          "(${154 * index + 1})",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    constraints.maxHeight * .35,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
