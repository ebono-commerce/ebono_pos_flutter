import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/custom_keyboard/custom_querty_pad.dart';
import 'package:ebono_pos/ui/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchWidget extends StatefulWidget {
  final BuildContext dialogContext;

  const SearchWidget(this.dialogContext, {super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late ThemeData theme;
  HomeController homeController = Get.find<HomeController>();
  final TextEditingController searchTextController = TextEditingController();
  final TextEditingController _qwertyPadController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  FocusNode? activeFocusNode;
  bool isGridView = false;
  final ScrollController _scrollController = ScrollController();

  void toggleView() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void scrollToTop() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    if (!searchFocusNode.hasFocus) {
      searchFocusNode.requestFocus();
    }
    activeFocusNode = searchFocusNode;

    searchFocusNode.addListener(() {
      setState(() {
        if (searchFocusNode.hasFocus) {
          activeFocusNode = searchFocusNode;
        }
        _qwertyPadController.text = searchTextController.text;
      });
    });

    _qwertyPadController.addListener(() {
      setState(() {
        //if (_qwertyPadController.text.isNotEmpty) {
        if (activeFocusNode == searchFocusNode) {
          searchTextController.text = _qwertyPadController.text;
        }
        //}
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: 40),
        SizedBox(
          width: 900,
          height: 350,
          child: Row(
            children: [
              Expanded(
                  child: isGridView
                      ? _buildListView(context, homeController)
                      : _buildGridView(context, homeController)),
              SizedBox(
                width: 100,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    _buildCloseButton(),
                    SizedBox(
                      height: 5,
                    ),
                    _buildUpButton(),
                    SizedBox(
                      height: 5,
                    ),
                    _buildDownButton(),
                    SizedBox(
                      height: 5,
                    ),
                    _buildGridNListButton(),
                    Spacer(),
                    _buildClearButton(),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: 900,
          child: _buildTextField(
            label: "",
            controller: searchTextController,
            focusNode: searchFocusNode,
            onChanged: (value) => homeController.customerName.value = value,
            //readOnly: homeController.phoneNumber.isEmpty,
            suffixIcon: _buildSelectButton(),
          ),
        ),
        SizedBox(
          width: 900,
          child: CustomQwertyPad(
            textController: _qwertyPadController,
            focusNode: activeFocusNode!,
            onEnterPressed: (value) {},
          ),
        ),
      ],
    );
  }

  Widget _buildGridNListButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      width: 100,
      height: 60,
      child: ElevatedButton(
        onPressed: toggleView,
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: CustomColors.primaryColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white,
        ),
        child: Center(
          child: SizedBox(
            width: 80,
            child: Row(
              children: [
                Icon(
                  isGridView ? Icons.grid_on : Icons.list,
                  size: 20,
                  color: CustomColors.primaryColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  isGridView ? "Images" : "List",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: CustomColors.primaryColor),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context, HomeController homeController) {
    List<int> searchItems = List.generate(20, (index) => index + 1);
    return Container(
      padding: EdgeInsets.only(bottom: 2),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          )),
      child: Column(
        children: [
          Table(
            columnWidths: {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(3),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    )), // Header background color
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Item Code",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w100,
                                color: CustomColors.greyFont),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Name",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w100,
                                color: CustomColors.greyFont),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Category",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w100,
                                color: CustomColors.greyFont),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Price₹",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w100,
                                color: CustomColors.greyFont),
                      )),
                ],
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Table(
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(3),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                },
                children: searchItems.map((itemData) {
                  return TableRow(
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1)),
                    children: [
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "999999999",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: CustomColors.black),
                            )),
                      ),
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Dawat basmati rice 1kg Dawat basmati rice 1kg",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: CustomColors.black),
                            )),
                      ),
                      Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Grocery',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: CustomColors.black),
                              ))),
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "99999.99",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: CustomColors.black),
                            )),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(BuildContext context, HomeController homeController) {
    List<int> searchItems = List.generate(20, (index) => index + 1);
    return Container(
        padding: EdgeInsets.only(bottom: 2),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            )),
        child: SizedBox(
          child: GridView.builder(
            physics: ScrollPhysics(),
            controller: _scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3.2,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
            ),
            itemCount: searchItems.length,
            itemBuilder: (context, index) {
              return buildCard();
            },
          ),
        ));
  }

  Widget buildCard() {
    return Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: CustomColors.cardBackground,
              //Border color
              width: 1, // Border width
            )),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://via.placeholder.com/100',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ratnagiri Alphonso...",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: CustomColors.black),
                    ),
                    SizedBox(height: 1),
                    Row(
                      children: [
                        Text(
                          "Code: ",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.greyFont),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "123456789",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: CustomColors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 1),
                    Row(
                      children: [
                        Text(
                          "Price: ",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: CustomColors.greyFont),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "₹1200",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: CustomColors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required ValueChanged<String> onChanged,
    bool readOnly = false,
    Widget? suffixIcon,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        readOnly: readOnly,
        decoration: _buildInputDecoration(label, suffixIcon),
      ),
    );
  }

  Widget _buildSelectButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      width: 100,
      // height: 50,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color:
                  //  homeController.customerName.isNotEmpty?
                  CustomColors.secondaryColor
              // : CustomColors.cardBackground
              ,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor:
              // homeController.customerName.isNotEmpty? CustomColors.secondaryColor:
              CustomColors.secondaryColor,
        ),
        child: Center(
          child: Icon(
            Icons.search,
            color: CustomColors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      width: 100,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: CustomColors.red,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: CustomColors.red,
        ),
        child: Center(
          child: Text(
            "Close",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      width: 100,
      height: 60,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: CustomColors.primaryColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white,
        ),
        child: Center(
          child: Text(
            "Clear",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500, color: CustomColors.primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildDownButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      width: 100,
      height: 60,
      child: ElevatedButton(
        onPressed: scrollToBottom,
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: CustomColors.primaryColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white,
        ),
        child: Center(
          child: Icon(
            Icons.expand_more,
            size: 30,
            color: CustomColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildUpButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      width: 100,
      height: 60,
      child: ElevatedButton(
        onPressed: scrollToTop,
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: CustomColors.primaryColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white,
        ),
        child: Center(
          child: Icon(
            Icons.expand_less,
            size: 30,
            color: CustomColors.primaryColor,
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, Widget? suffixIcon) {
    return InputDecoration(
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.red,
          width: 1,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      label: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: label,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      suffixIcon: suffixIcon,
    );
  }
}
