import 'package:flutter/material.dart';
import 'package:hostel_finder/language/appLocalizations.dart';
import 'package:hostel_finder/models/hotel_list_data.dart';
import 'package:hostel_finder/providers/theme_provider.dart';
import 'package:hostel_finder/utils/enum.dart';
import 'package:hostel_finder/utils/helper.dart';
import 'package:hostel_finder/utils/text_styles.dart';
import 'package:hostel_finder/utils/themes.dart';
import 'package:hostel_finder/widgets/common_card.dart';
import 'package:hostel_finder/widgets/list_cell_animation_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HotelListViewData extends StatelessWidget {
  final bool isShowDate;
  final VoidCallback callback;
  final Map hotelData;
  final AnimationController animationController;
  final Animation<double> animation;

  const HotelListViewData(
      {Key? key,
      required this.hotelData,
      required this.animationController,
      required this.animation,
      required this.callback,
      this.isShowDate = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListCellAnimationView(
      animation: animation,
      animationController: animationController,
      child: Padding(
        padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          onTap: () {
            try {
              callback();
            } catch (e) {}
          },
          child: Row(
            children: <Widget>[
              isShowDate ? getUI(context) : SizedBox(),
              CommonCard(
                color: AppTheme.backgroundColor,
                radius: 16,
                child: SizedBox(
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Image.network(
                        hotelData['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              !isShowDate ? getUI(context) : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getUI(BuildContext context) {
    return Expanded(
      child: Container(
        height: 150,
        padding: EdgeInsets.only(
            left: !isShowDate ? 16 : 8,
            top: 8,
            bottom: 8,
            right: isShowDate ? 16 : 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              isShowDate ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              hotelData['name'],
              maxLines: 2,
              textAlign: isShowDate ? TextAlign.right : TextAlign.left,
              style: TextStyles(context).getBoldStyle().copyWith(
                    fontSize: 16,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              hotelData['location'],
              style: TextStyles(context).getDescriptionStyle().copyWith(
                    fontSize: 14,
                  ),
            ),
            // Text(
            //   Helper.getDateText(hotelData.date!),
            //   maxLines: 2,
            //   textAlign: isShowDate ? TextAlign.right : TextAlign.left,
            //   style: TextStyles(context).getRegularStyle().copyWith(
            //         fontSize: 12,
            //       ),
            //   overflow: TextOverflow.ellipsis,
            // ),
            // Text(
            //   Helper.getRoomText(hotelData.roomData!),
            //   maxLines: 2,
            //   textAlign: isShowDate ? TextAlign.right : TextAlign.left,
            //   style: TextStyles(context).getRegularStyle().copyWith(
            //         fontSize: 12,
            //       ),
            //   overflow: TextOverflow.ellipsis,
            // ),
            Expanded(
              child: FittedBox(
                child: SizedBox(
                  width: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: isShowDate
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: isShowDate
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.mapMarkerAlt,
                            size: 12,
                            color: Theme.of(context).primaryColor,
                          ),
                          Text(
                            hotelData['price'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles(context)
                                .getDescriptionStyle()
                                .copyWith(
                                  fontSize: 14,
                                ),
                          ),
                          Text(
                            AppLocalizations(context).of("km_to_city"),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles(context)
                                .getDescriptionStyle()
                                .copyWith(
                                  fontSize: 14,
                                ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: isShowDate
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "GHC ${hotelData['price']}",
                            textAlign: TextAlign.left,
                            style:
                                TextStyles(context).getRegularStyle().copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: context
                                            .read<ThemeProvider>()
                                            .languageType ==
                                        LanguageType.ar
                                    ? 4.0
                                    : 2.0),
                            child: Text(
                              AppLocalizations(context).of("per_night"),
                              style: TextStyles(context)
                                  .getDescriptionStyle()
                                  .copyWith(
                                    fontSize: 14,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
