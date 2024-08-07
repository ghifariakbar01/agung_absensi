// ignore_for_file: non_constant_identifier_names

import 'package:face_net_authentication/widgets/v_button.dart';
import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/v_dialogs.dart';
import '../application/shared/tc_providers.dart';

final CB1 = StateProvider<bool>((ref) => false);
final CB2 = StateProvider<bool>((ref) => false);

class TCPage extends ConsumerWidget {
  const TCPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPrivacy = ref.watch(CB1);
    final isTerms = ref.watch(CB2);

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Palette.primaryColor.withOpacity(0.1),
            ),
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bigHeadingText('Privacy Policy'),
                SizedBox(
                  height: 8,
                ),
                normalText(
                    'Agung Logistics built the E-FINGER app as a Free app. This SERVICE is provided by Agung Logistics at no cost and is intended for use as is. This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service. If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy. The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at E-FINGER unless otherwise defined in this Privacy Policy.'), //
                //
                SizedBox(
                  height: 16,
                ),

                headingText('Information Collection and Use'),
                normalText(
                    'For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to employee username, employee password. The information that we request will be retained by us and used as described in this privacy policy. The app does use third-party services that may collect information used to identify you. Link to the privacy policy of third-party service providers used by the app'),
                SizedBox(
                  height: 8,
                ),
                InkWell(
                    onTap: () => launchUrl(
                        Uri.parse('https://policies.google.com/privacy')),
                    child: Text(
                      'Google Play Services',
                      style: Themes.customColor(
                        12,
                      ),
                    )),
                SizedBox(
                  height: 8,
                ),
                InkWell(
                    onTap: () => launchUrl(Uri.parse(
                        'https://www.apple.com/legal/internet-services/itunes/appstore/dev/stdeula')),
                    child: Text(
                      'Apple’s Standard License Agreement',
                      style: Themes.customColor(
                        12,
                      ),
                    )),
                //
                SizedBox(
                  height: 16,
                ),

                headingText('Log Data'),
                normalText(
                    'We want to inform you that whenever you use our Service, in a case of an error in the app we collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.'),
                //
                SizedBox(
                  height: 16,
                ),
                headingText('Cookies'),
                normalText(
                    'Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your devices internal memory.This Service does not use these “cookies” explicitly. However, the app may use third-party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.'),
                //
                SizedBox(
                  height: 16,
                ),
                headingText('Service Providers'),
                normalText(
                    'We may employ third-party companies and individuals due to the following reasons:To facilitate our Service; To provide the Service on our behalf; To perform Service-related services; or To assist us in analyzing how our Service is used. We want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.'),
                //
                SizedBox(
                  height: 16,
                ),
                headingText('Security'),
                normalText(
                    'We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.'),
                //
                SizedBox(
                  height: 16,
                ),
                headingText('Links to Other Sites'),
                normalText(
                    'This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these websites. We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.'),
                //
                SizedBox(
                  height: 16,
                ),
                headingText('Children’s Privacy'),
                normalText(
                    'These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13 years of age. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do the necessary actions.'),
                //
                SizedBox(
                  height: 16,
                ),
                headingText('Changes to This Privacy Policy'),
                normalText(
                    'We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page.This policy is effective as of 2023-07-28'),
                //
                SizedBox(
                  height: 16,
                ),
                headingText('Contact Us'),
                normalText(
                    'If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at (62-21)31905712'),
                SizedBox(
                  height: 16,
                ),
                //
                bigHeadingText('Terms & Conditions'),
                SizedBox(
                  height: 8,
                ),
                normalText(
                    'By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages or make derivative versions. The app itself, and all the trademarks, copyright, database rights, and other intellectual property rights related to it, still belong to PT Agung Logistics. PT Agung Logistics is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for. The E-FINGER app stores and processes personal data that you have provided to us, to provide our Service. It’s your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that the E-FINGER app won’t work properly or at all. The app does use third-party services that declare their Terms and Conditions. Link to Terms and Conditions of third-party service providers used by the app'),
                SizedBox(
                  height: 8,
                ),
                InkWell(
                    onTap: () => launchUrl(
                        Uri.parse('https://policies.google.com/terms')),
                    child: Text(
                      'Google Play Services',
                      style: Themes.customColor(
                        12,
                      ),
                    )),
                SizedBox(
                  height: 8,
                ),
                normalText(
                    'You should be aware that there are certain things that PT Agung Logistics will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi or provided by your mobile network provider, but PT Agung Logistics cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left. If you’re using the app outside of an area with Wi-Fi, you should remember that the terms of the agreement with your mobile network provider will still apply. As a result, you may be charged by your mobile provider for the cost of data for the duration of the connection while accessing the app, or other third-party charges. In using the app, you’re accepting responsibility for any such charges, including roaming data charges if you use the app outside of your home territory (i.e. region or country) without turning off data roaming. If you are not the bill payer for the device on which you’re using the app, please be aware that we assume that you have received permission from the bill payer for using the app. Along the same lines, PT Agung Logistics cannot always take responsibility for the way you use the app i.e. You need to make sure that your device stays charged – if it runs out of battery and you can’t turn it on to avail the Service, PT Agung Logistics cannot accept responsibility. With respect to PT Agung Logistics’s responsibility for your use of the app, when you’re using the app, it’s important to bear in mind that although we endeavor to ensure that it is updated and correct at all times, we do rely on third parties to provide information to us so that we can make it available to you. PT Agung Logistics accepts no liability for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of the app. At some point, we may wish to update the app. The app is currently available on Android & iOS – the requirements for the both systems(and for any additional systems we decide to extend the availability of the app to) may change, and you’ll need to download the updates if you want to keep using the app. PT Agung Logistics does not promise that it will always update the app so that it is relevant to you and/or works with the Android & iOS version that you have installed on your device. However, you promise to always accept updates to the application when offered to you, We may also wish to stop providing the app, and may terminate use of it at any time without giving notice of termination to you. Unless we tell you otherwise, upon any termination, (a) the rights and licenses granted to you in these terms will end; (b) you must stop using the app, and (if needed) delete it from your device.'),
                SizedBox(
                  height: 16,
                ),
                //
                headingText('Changes to This Terms and Conditions'),
                normalText(
                    'We may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Terms and Conditions on this page. These terms and conditions are effective as of 2023-07-28'),
              ],
            ),
          ),
          //
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Checkbox(
                  key: UniqueKey(),
                  checkColor: Theme.of(context).primaryColorLight,
                  fillColor: WidgetStateProperty.resolveWith(
                      (state) => getColor(state, context)),
                  value: isPrivacy,
                  onChanged: (_) =>
                      ref.read(CB1.notifier).state = (toggleBool(isPrivacy))),
              SizedBox(
                width: 4,
              ),
              Text(
                'Agree to Privacy Policy',
                style: Themes.customColor(14),
              )
            ],
          ),

          SizedBox(
            height: 8,
          ),

          Row(
            children: [
              Checkbox(
                  key: UniqueKey(),
                  checkColor: Theme.of(context).primaryColorLight,
                  fillColor: WidgetStateProperty.resolveWith(
                      (state) => getColor(state, context)),
                  value: isTerms,
                  onChanged: (_) =>
                      ref.read(CB2.notifier).state = (toggleBool(isTerms))),
              SizedBox(
                width: 4,
              ),
              Text(
                'Agree to Terms & Conditions',
                style: Themes.customColor(14),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Center(
            child: VButton(
                fontSize: 12,
                height: 50,
                textAlign: TextAlign.center,
                label: 'CONTINUE',
                isEnabled: isPrivacy && isTerms,
                onPressed: () {
                  return showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => VAlertDialog(
                          label:
                              'Agree to Terms & Conditions, and Privacy Policy ?',
                          labelDescription:
                              'I acknowledge that I have read and understand the terms of this agreement as detailed above.',
                          backPressedLabel: 'No',
                          pressedLabel: 'Yes',
                          onPressed: () async {
                            final save = '${DateTime.now()}';
                            await ref
                                .read(tcNotifierProvider.notifier)
                                .saveVisitedTC(save);

                            await ref
                                .read(tcNotifierProvider.notifier)
                                .checkAndUpdateStatusTC();
                          }));
                }),
          )
        ],
      ),
    ));
  }
}

Widget normalText(String text) => Text(
      text,
      style: Themes.customColor(
        12,
      ),
      textAlign: TextAlign.justify,
    );

Widget headingText(String text) => Text(
      text,
      style: Themes.customColor(
        12,
        fontWeight: FontWeight.bold,
      ),
    );

Widget bigHeadingText(String text) => Text(
      text,
      style: Themes.customColor(
        14,
        fontWeight: FontWeight.bold,
      ),
    );

bool toggleBool(bool toggled) {
  return toggled ? false : true;
}

Color getColor(Set<WidgetState> states, BuildContext context) {
  const Set<WidgetState> interactiveStates = <WidgetState>{
    WidgetState.pressed,
    WidgetState.hovered,
    WidgetState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return Palette.primaryColor;
  }
  return Palette.primaryColor;
}
