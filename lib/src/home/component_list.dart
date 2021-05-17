import 'package:flutter/material.dart';

class ComponentList extends StatelessWidget {
  final components;

  ComponentList(this.components);

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      leading: Icon(Icons.remove_red_eye),
      title: Text("Drishti"),
    );

    // allocate equal height for each component
    double listItemHeight = (MediaQuery.of(context).size.height -
            appBar.preferredSize.height -
            MediaQuery.of(context).padding.top) /
        components.length;

    /// return the components of Drishti App
    return Scaffold(
        appBar: appBar,
        body: ListView(
          children: [
            ...(this.components).map((component) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => component['viewScreen']));
                  },
                  child: Container(
                      color: component['color'],
                      height: listItemHeight,
                      child: Row(children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width *
                                        0.05,
                                    left: MediaQuery.of(context).size.width *
                                        0.03),
                                child: Text(
                                  component['name'],
                                  semanticsLabel:
                                      component['name'].replaceAll('\n', ' '),
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xffFFFFFF),
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 10.0,
                                        color: Color.fromARGB(100, 0, 0, 0),
                                      ),
                                      Shadow(
                                        offset: Offset(0.0, 10.0),
                                        blurRadius: 15.0,
                                        color: Color.fromARGB(70, 0, 0, 255),
                                      ),
                                    ],
                                  ),
                                ))),
                        // ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Image.asset(component['imagePath'])),
                        ),
                      ])));
            }).toList()
          ],
        ));
  }
}
