import 'package:flutter/material.dart';
import 'package:flutter_callkeep/flutter_callkeep.dart';
import 'package:test_call/navigation_service.dart';
import 'package:uuid/uuid.dart';

import 'app_router.dart';

Future<void> displayIncomingCall(String uuid) async {
  ;
  final config = CallKeepIncomingConfig(
    uuid: uuid,
    callerName: 'Hien Nguyen',
    appName: 'CallKeep',
    avatar: 'https://i.pravatar.cc/100',
    handle: '0123456789',
    hasVideo: false,
    duration: 30000,
    acceptText: 'Accept',
    declineText: 'Decline',
    missedCallText: 'Missed call',
    callBackText: 'Call back',
    extra: <String, dynamic>{'userId': '1a2b3c4d'},
    headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
    androidConfig: CallKeepAndroidConfig(
      logo: "ic_logo",
      showCallBackAction: true,
      showMissedCallNotification: true,
      ringtoneFileName: 'system_ringtone_default',
      accentColor: '#0955fa',
      backgroundUrl: 'assets/test.png',
      incomingCallNotificationChannelName: 'Incoming Calls',
      missedCallNotificationChannelName: 'Missed Calls',
    ),
    iosConfig: CallKeepIosConfig(
      iconName: 'CallKitLogo',
      handleType: CallKitHandleType.generic,
      isVideoSupported: true,
      maximumCallGroups: 2,
      maximumCallsPerCallGroup: 1,
      audioSessionActive: true,
      audioSessionPreferredSampleRate: 44100.0,
      audioSessionPreferredIOBufferDuration: 0.005,
      supportsDTMF: true,
      supportsHolding: true,
      supportsGrouping: false,
      supportsUngrouping: false,
      ringtoneFileName: 'system_ringtone_default',
    ),
  );
  await CallKeep.instance.displayIncomingCall(config);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final Uuid uuid;
  String? currentUuid;

  @override
  void initState() {
    super.initState();
    uuid = const Uuid();
    WidgetsBinding.instance.addObserver(this);
    //Check call when open app from terminated
    checkAndNavigationCallingPage();
  }

  Future<CallKeepCallData?> getCurrentCall() async {
    //check current call from pushkit if possible
    var calls = await CallKeep.instance.activeCalls();
    if (calls.isNotEmpty) {
      currentUuid = calls[0].uuid;
      return calls[0];
    } else {
      currentUuid = "";
      return null;
    }
  }

  checkAndNavigationCallingPage() async {
    var currentCall = await getCurrentCall();
    if (currentCall != null) {
      NavigationService.instance.pushNamedIfNotCurrent(AppRoute.callingPage,
          args: currentCall.toMap());
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      checkAndNavigationCallingPage();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      onGenerateRoute: AppRoute.generateRoute,
      initialRoute: AppRoute.homePage,
      navigatorKey: NavigationService.instance.navigationKey,
      navigatorObservers: <NavigatorObserver>[
        NavigationService.instance.routeObserver
      ],
    );
  }

  Future<void> getDevicePushTokenVoIP() async {
    var devicePushTokenVoIP = await CallKeep.instance.getDevicePushTokenVoIP();
    print(devicePushTokenVoIP);
  }
}
