import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/models/scan_products_response.dart';
import 'package:ebono_pos/ui/custom_keyboard/custom_querty_pad.dart';
import 'package:ebono_pos/ui/search/bloc/search_bloc.dart';
import 'package:ebono_pos/ui/search/data/search_products_table_data.dart';
import 'package:ebono_pos/utils/price.dart';
import 'package:ebono_pos/widgets/custom_table/custom_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SearchProductsView extends StatefulWidget {
  final BuildContext dialogContext;

  const SearchProductsView(this.dialogContext, {super.key});

  @override
  State<SearchProductsView> createState() => _SearchProductsViewState();
}

class _SearchProductsViewState extends State<SearchProductsView> {
  late ThemeData theme;
  late SearchBloc searchBloc;
  late SearchProductsTableData searchProductsTableData;

  final TextEditingController searchTextController = TextEditingController();
  final TextEditingController _qwertyPadController = TextEditingController();

  FocusNode searchFocusNode = FocusNode();
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
    searchBloc = Get.put<SearchBloc>(SearchBloc(Get.find()));
    searchProductsTableData = SearchProductsTableData(context: context);

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
        if (activeFocusNode == searchFocusNode) {
          searchTextController.text = _qwertyPadController.text;
        }
      });
    });
  }

  @override
  void dispose() {
    if (mounted) {
      searchBloc.add(ResetSearchEvent());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return BlocProvider.value(
      value: searchBloc,
      child: BlocConsumer<SearchBloc, SearchState>(
        listener: (context, state) {
          if (state.isError) {
            Get.snackbar('ERROR', state.errorMessage);
          }
        },
        buildWhen: (previous, current) => current.isResetAll == false,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  flex: 5,
                  child: Row(
                    children: [
                      Expanded(
                        child: isGridView
                            ? CustomTableWidget(
                                scrollController: _scrollController,
                                headers: searchProductsTableData
                                    .buildScanProductsTableHeaders(),
                                tableRowsData:
                                    searchProductsTableData.buildTableRows(
                                  scanProductResponseList:
                                      state.searchResultsData,
                                ),
                                emptyDataMessage: "No Products Found",
                                columnWidths: {
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(3),
                                  2: FlexColumnWidth(1.5),
                                  3: FlexColumnWidth(1),
                                },
                              )
                            : _buildGridView(state.searchResultsData),
                      ),
                      SizedBox(
                        width: 150,
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            _buildCloseButton(),
                            Spacer(),
                            _buildUpButton(),
                            Spacer(),
                            _buildDownButton(),
                            Spacer(),
                            _buildGridNListButton(),
                            Spacer(),
                            _buildClearButton(),
                            Spacer(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: FittedBox(
                    child: SizedBox(
                      width: 900,
                      child: Column(
                        children: [
                          Container(
                            height: 55,
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 40),
                            child: _buildTextField(
                              label: "",
                              controller: searchTextController,
                              focusNode: searchFocusNode,
                              onChanged: (value) {},
                              suffixIcon: _buildSelectButton(
                                  isLoading: state.isLoading),
                            ),
                          ),
                          CustomQwertyPad(
                            textController: _qwertyPadController,
                            focusNode: activeFocusNode!,
                            onEnterPressed: (value) {
                              if (state.isLoading == false &&
                                  value.isNotEmpty &&
                                  mounted) {
                                context
                                    .read<SearchBloc>()
                                    .add(TriggerSearchEvent(value));
                              } else {
                                Get.snackbar("SEARCH CANNOT BE EMPTY",
                                    "please enter the product name");
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
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
      padding: const EdgeInsets.all(2),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        readOnly: readOnly,
        decoration: _buildInputDecoration(label, suffixIcon),
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

  Widget _buildGridNListButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      width: 140,
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

  Widget _buildGridView(List<ScanProductsResponse> searchResults) {
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
              crossAxisCount: 5,
              childAspectRatio: 2.8,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
            ),
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              return buildCard(searchResults[index]);
            },
          ),
        ));
  }

  Widget buildCard(ScanProductsResponse searchResult) {
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
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(10),
              //   child: (searchResult.mediaUrl != null &&
              //           searchResult.mediaUrl?.isNotEmpty == true)
              //       ? Image.network(
              //           searchResult.mediaUrl!,
              //           width: 50,
              //           height: 50,
              //           fit: BoxFit.cover,
              //         )
              //       : SvgPicture.asset(
              //           'assets/images/pos_logo.svg',
              //           width: 50,
              //           height: 50,
              //           fit: BoxFit.cover,
              //         ),
              // ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: (searchResult.mediaUrl != null &&
                        searchResult.mediaUrl?.isNotEmpty == true)
                    ? CachedNetworkImage(
                        imageUrl: searchResult.mediaUrl!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SvgPicture.asset(
                          'assets/images/pos_logo.svg',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => SvgPicture.asset(
                          'assets/images/pos_logo.svg',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      )
                    : SvgPicture.asset(
                        'assets/images/pos_logo.svg',
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
                      searchResult.skuTitle ?? 'NA',
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
                          searchResult.skuCode ?? 'NA',
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
                          searchResult.priceList?.isNotEmpty == true
                              ? getActualPrice(
                                  searchResult.priceList?.first.sellingPrice
                                      ?.centAmount,
                                  searchResult
                                      .priceList?.first.sellingPrice?.fraction,
                                  includeRupee: false,
                                )
                              : '',
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

  Widget _buildSelectButton({bool isLoading = false}) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      width: 100,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          if (searchTextController.text.trim().isNotEmpty &&
              isLoading == false) {
            searchBloc.add(TriggerSearchEvent(searchTextController.text));
          } else {
            Get.snackbar(
                "SEARCH CANNOT BE EMPTY", "please enter the product name");
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: CustomColors.secondaryColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: CustomColors.secondaryColor,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(),
                )
              : Icon(
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
      width: 140,
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
      width: 140,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          searchBloc.add(ClearSearchEvent());
          _qwertyPadController.clear();
          searchTextController.clear();
        },
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
      width: 140,
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
      width: 140,
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
}
