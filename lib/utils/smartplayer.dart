//
//  smartplayer.dart
//  smartplayer
//
//  GitHub: https://github.com/daniulive/SmarterStreaming
//  website: https://www.daniulive.com
//
//  Created by daniulive on 2019/02/25.
//  Copyright © 2014~2019 daniulive. All rights reserved.
//
 
import 'dart:async';
import 'dart:convert';
 
import 'package:flutter/services.dart';
 
class EVENTID {
  static const EVENT_DANIULIVE_COMMON_SDK = 0x00000000;
  static const EVENT_DANIULIVE_PLAYER_SDK = 0x01000000;
  static const EVENT_DANIULIVE_PUBLISHER_SDK = 0x02000000;
 
  static const EVENT_DANIULIVE_ERC_PLAYER_STARTED =
      EVENT_DANIULIVE_PLAYER_SDK | 0x1;
  static const EVENT_DANIULIVE_ERC_PLAYER_CONNECTING =
      EVENT_DANIULIVE_PLAYER_SDK | 0x2;
  static const EVENT_DANIULIVE_ERC_PLAYER_CONNECTION_FAILED =
      EVENT_DANIULIVE_PLAYER_SDK | 0x3;
  static const EVENT_DANIULIVE_ERC_PLAYER_CONNECTED =
      EVENT_DANIULIVE_PLAYER_SDK | 0x4;
  static const EVENT_DANIULIVE_ERC_PLAYER_DISCONNECTED =
      EVENT_DANIULIVE_PLAYER_SDK | 0x5;
  static const EVENT_DANIULIVE_ERC_PLAYER_STOP =
      EVENT_DANIULIVE_PLAYER_SDK | 0x6;
  static const EVENT_DANIULIVE_ERC_PLAYER_RESOLUTION_INFO =
      EVENT_DANIULIVE_PLAYER_SDK | 0x7;
  static const EVENT_DANIULIVE_ERC_PLAYER_NO_MEDIADATA_RECEIVED =
      EVENT_DANIULIVE_PLAYER_SDK | 0x8;
  static const EVENT_DANIULIVE_ERC_PLAYER_SWITCH_URL =
      EVENT_DANIULIVE_PLAYER_SDK | 0x9;
  static const EVENT_DANIULIVE_ERC_PLAYER_CAPTURE_IMAGE =
      EVENT_DANIULIVE_PLAYER_SDK | 0xA;
 
  static const EVENT_DANIULIVE_ERC_PLAYER_RECORDER_START_NEW_FILE =
             EVENT_DANIULIVE_PLAYER_SDK | 0x21; /*Write video to new file*/
  static const EVENT_DANIULIVE_ERC_PLAYER_ONE_RECORDER_FILE_FINISHED =
             EVENT_DANIULIVE_PLAYER_SDK | 0x22; /*One video file complete*/
 
  static const EVENT_DANIULIVE_ERC_PLAYER_START_BUFFERING =
      EVENT_DANIULIVE_PLAYER_SDK | 0x81;
  static const EVENT_DANIULIVE_ERC_PLAYER_BUFFERING =
      EVENT_DANIULIVE_PLAYER_SDK | 0x82;
  static const EVENT_DANIULIVE_ERC_PLAYER_STOP_BUFFERING =
      EVENT_DANIULIVE_PLAYER_SDK | 0x83;
 
  static const EVENT_DANIULIVE_ERC_PLAYER_DOWNLOAD_SPEED =
      EVENT_DANIULIVE_PLAYER_SDK | 0x91;
}
 
typedef SmartEventCallback = void Function(int, String, String, String);
 
class SmartPlayerController {
  MethodChannel _channel;
  EventChannel _eventChannel;
  SmartEventCallback _eventCallback;
 
  void init(int id) {
    _channel = MethodChannel('smartplayer_plugin_$id');
    _eventChannel = EventChannel('smartplayer_event_$id');
    _eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }
 
  void setEventCallback(SmartEventCallback callback) {
    _eventCallback = callback;
  }
 
  void _onEvent(Object event) {
    if (event != null) {
      Map valueMap = json.decode(event);
      String param = valueMap['param'];
      onSmartEvent(param);
    }
  }
 
  void _onError(Object error) {
    // print('error:'+ error);
  }
 
  Future<dynamic> _smartPlayerCall(String funcName) async {
    var ret = await _channel.invokeMethod(funcName);
    return ret;
  }
 
  Future<dynamic> _smartPlayerCallInt(String funcName, int param) async {
    var ret = await _channel.invokeMethod(funcName, {
      'intParam': param,
    });
    return ret;
  }
 
  Future<dynamic> _smartPlayerCallIntInt(
      String funcName, int param1, int param2) async {
    var ret = await _channel.invokeMethod(funcName, {
      'intParam': param1,
      'intParam2': param2,
    });
    return ret;
  }
 
  Future<dynamic> _smartPlayerCallString(String funcName, String param) async {
    var ret = await _channel.invokeMethod(funcName, {
      'strParam': param,
    });
    return ret;
  }
 
     /// Set the decoding method false soft decoding true hard decoding default is false
  /// </summary>
  /// <param name="isHwDecoder"></param>
  Future<dynamic> setVideoDecoderMode(int isHwDecoder) async {
    return _smartPlayerCallInt('setVideoDecoderMode', isHwDecoder);
  }
 
  /// <summary>
     /// Set the audio output mode: if 0: automatic selection; if with 1: audiotrack mode, this interface is only for Android platform
  /// </summary>
  /// <param name="use_audiotrack"></param>
  Future<dynamic> setAudioOutputType(int useAudiotrack) async {
    return _smartPlayerCallInt('setAudioOutputType', useAudiotrack);
  }
 
  /// <summary>
     /// Set the buffer size of the player, the default is 200 milliseconds
  /// </summary>
  /// <param name="buffer"></param>
  Future<dynamic> setBuffer(int buffer) async {
    return _smartPlayerCallInt('setBuffer', buffer);
  }
 
  /// <summary>
     /// The interface can be called in real time: set whether to mute in real time, 1: mute; 0: unmute
  /// </summary>
  /// <param name="is_mute"></param>
  Future<dynamic> setMute(int isMute) async {
    return _smartPlayerCallInt('setMute', isMute);
  }
 
  /// <summary>
     /// Set RTSP TCP mode, 1: TCP; 0: UDP
  /// </summary>
  /// <param name="is_using_tcp"></param>
  Future<dynamic> setRTSPTcpMode(int isUsingTcp) async {
    return _smartPlayerCallInt('setRTSPTcpMode', isUsingTcp);
  }
 
  /// <summary>
     /// Set RTSP timeout time, timeout unit is second, must be greater than 0
  /// </summary>
  /// <param name="timeout"></param>
  Future<dynamic> setRTSPTimeout(int timeout) async {
    return _smartPlayerCallInt('setRTSPTimeout', timeout);
  }
 
  /// <summary>
     /// Set RTSP TCP/UDP automatic switch
     /// For RTSP, some may support rtp over udp, and some may support rtp over tcp.
     /// For ease of use, you can turn on the automatic try switch in some scenarios. If udp cannot be played after it is turned on, sdk will automatically try tcp, if tcp cannot be played, sdk will automatically try udp.
  /// </summary>
  /// <param name="is_auto_switch_tcp_udp"></param>
  Future<dynamic> setRTSPAutoSwitchTcpUdp(int is_auto_switch_tcp_udp) async {
    return _smartPlayerCallInt('setRTSPAutoSwitchTcpUdp', is_auto_switch_tcp_udp);
  }
 
  /// <summary>
     /// Set the quick start mode,
  /// </summary>
  /// <param name="is_fast_startup"></param>
  Future<dynamic> setFastStartup(int isFastStartup) async {
    return _smartPlayerCallInt('setFastStartup', isFastStartup);
  }
 
  /// <summary>
     /// Set ultra-low latency mode false not open true open default false
  /// </summary>
  /// <param name="mode"></param>
  Future<dynamic> setPlayerLowLatencyMode(int mode) async {
    return _smartPlayerCallInt('setPlayerLowLatencyMode', mode);
  }
 
  /// <summary>
     /// Set video vertical inversion
  /// </summary>
  /// <param name="is_flip"></param>
  Future<dynamic> setFlipVertical(int is_flip) async {
    return _smartPlayerCallInt('setFlipVertical', is_flip);
  }
 
  /// <summary>
     /// Set the video level to reverse
  /// </summary>
  /// <param name="is_flip"></param>
  Future<dynamic> setFlipHorizontal(int is_flip) async {
    return _smartPlayerCallInt('setFlipHorizontal', is_flip);
  }
 
  /// <summary>
     /// Set clockwise rotation, note that in addition to 0 degrees, other angles will consume additional performance
     /// degress: currently supports 0 degree, 90 degree, 180 degree, 270 degree rotation
  /// </summary>
  /// <param name="degress"></param>
  Future<dynamic> setRotation(int degress) async {
    return _smartPlayerCallInt('setRotation', degress);
  }
 
  /// <summary>
  /// Set whether to call back the download speed
     /// is_report: if 1: report download speed, 0: do not report.
     /// report_interval: report interval, in seconds, >0.
  /// </summary>
  /// <param name="is_report"></param>
  /// <param name="report_interval"></param>
  Future<dynamic> setReportDownloadSpeed(
      int isReport, int reportInterval) async {
    return _smartPlayerCallIntInt(
        'setReportDownloadSpeed', isReport, reportInterval);
  }
 
  /// <summary>
     /// Set playback orientation, this interface is only applicable to Android platform
  /// </summary>
  /// <param name="surOrg"></param>
  /// surOrg: current orientation,  PORTRAIT 1, LANDSCAPE with 2
  Future<dynamic> setOrientation(int surOrg) async {
    return _smartPlayerCallInt('setOrientation', surOrg);
  }
 
  /// <summary>
     /// Set whether to take a snapshot during playback or recording
  /// </summary>
  /// <param name="is_save_image"></param>
  Future<dynamic> setSaveImageFlag(int isSaveImage) async {
    return _smartPlayerCallInt('setSaveImageFlag', isSaveImage);
  }
 
  /// <summary>
     /// Snapshot during playback or recording
  /// </summary>
  /// <param name="imageName"></param>
  Future<dynamic> saveCurImage(String imageName) async {
    return _smartPlayerCallString('saveCurImage', imageName);
  }
 
  /// <summary>
     /// During playback or recording, quickly switch url
  /// </summary>
  /// <param name="uri"></param>
  Future<dynamic> switchPlaybackUrl(String uri) async {
    return _smartPlayerCallString('switchPlaybackUrl', uri);
  }
 
  /// <summary>
     /// Create video storage path
  /// </summary>
  /// <param name="path"></param>
  Future<dynamic> createFileDirectory(String path) async {
    return _smartPlayerCallString('createFileDirectory', path);
  }
 
  /// <summary>
     /// Set video storage path
  /// </summary>
  /// <param name="path"></param>
  Future<dynamic> setRecorderDirectory(String path) async {
    return _smartPlayerCallString('setRecorderDirectory', path);
  }
 
  /// <summary>
     /// Set the size of a single video file
  /// </summary>
  /// <param name="size"></param>
  Future<dynamic> setRecorderFileMaxSize(int size) async {
    return _smartPlayerCallInt('setRecorderFileMaxSize', size);
  }
 
  /// <summary>
     /// Set the switch of audio to AAC encoding during recording
     /// Aac is more general, sdk adds the function of converting other audio coding (such as speex, pcmu, pcma, etc.) to aac.
  /// </summary>
  /// <param name="is_transcode"></param>
     /// is_transcode: If it is set to 1, if the audio code is not aac, it will be converted to aac, if it is aac, no conversion will be done. If it is set to 0, no conversion will be done. The default is 0.
  Future<dynamic> setRecorderAudioTranscodeAAC(int is_transcode) async {
    return _smartPlayerCallInt('setRecorderAudioTranscodeAAC', is_transcode);
  }
 
  /// <summary>
     /// Set playback path
  /// </summary>
  Future<dynamic> setUrl(String url) async {
    return _smartPlayerCallString('setUrl', url);
  }
 
  /// <summary>
     /// Start playing 
  /// </summary>
  Future<dynamic> startPlay() async {
    return _smartPlayerCall('startPlay');
  }
 
  /// <summary>
     /// Stop play 
  /// </summary>
  Future<dynamic> stopPlay() async {
    return _smartPlayerCall('stopPlay');
  }
 
  /// <summary>
     /// Start recording
  /// </summary>
  Future<dynamic> startRecorder() async {
    return _smartPlayerCall('startRecorder');
  }
 
  /// <summary>
     /// Stop recording
  /// </summary>
  Future<dynamic> stopRecorder() async {
    return _smartPlayerCall('stopRecorder');
  }
 
  /// <summary>
     /// Close playback
  /// </summary>
  Future<dynamic> dispose() async {
    return await _channel.invokeMethod('dispose');
  }
 
  void onSmartEvent(String param) {
    if (!param.contains(",")) {
             print("[onNTSmartEvent] android parameter passing error");
      return;
    }
 
    List<String> strs = param.split(',');
 
    String code = strs[1];
    String param1 = strs[2];
    String param2 = strs[3];
    String param3 = strs[4];
    String param4 = strs[5];
 
    int evCode = int.parse(code);
 
    var p1, p2, p3;
    switch (evCode) {
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_STARTED:
                 print("Start...");
        break;
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_CONNECTING:
                 print("Connecting...");
        break;
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_CONNECTION_FAILED:
                 print("Connection failed...");
        break;
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_CONNECTED:
                 print("The connection is successful...");
        break;
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_DISCONNECTED:
                 print("The connection is disconnected...");
        break;
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_STOP:
                 print("Stop playing...");
        break;
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_RESOLUTION_INFO:
                 print("Resolution information: width: "+ param1 + ", height:" + param2);
        p1 = param1;
        p2 = param2;
        break;
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_NO_MEDIADATA_RECEIVED:
                 print("Cannot receive media data, it may be url error...");
        break;
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_SWITCH_URL:
                 print("Switch playback URL..");
        break;
 
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_CAPTURE_IMAGE:
                 print("Snapshot: "+ param1 +" Path: "+ param3);
 
        if (int.parse(param1) == 0) {
                       print("Successfully captured the snapshot..");
        } else {
                       print("Failed to take snapshot..");
        }
        p1 = param1;
        p2 = param3;
        break;
 
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_RECORDER_START_NEW_FILE:
                 print("[record] start a new recording file: "+ param3);
        p3 = param3;
        break;
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_ONE_RECORDER_FILE_FINISHED:
                 print("[record] has generated a video file: "+ param3);
        p3 = param3;
        break;
 
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_START_BUFFERING:
        print("Start_Buffering");
        break;
 
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_BUFFERING:
        print("Buffering: " + param1 + "%");
        p1 = param1;
        break;
 
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_STOP_BUFFERING:
        print("Stop_Buffering");
        break;
 
      case EVENTID.EVENT_DANIULIVE_ERC_PLAYER_DOWNLOAD_SPEED:
         print("download_speed:" + (double.parse(param1) * 8 / 1000).toStringAsFixed(0) + "kbps" + ", " + (double.parse(param1) / 1024).toStringAsFixed(0) + "KB/s");
        p1 = param1;
        break;
    }
    if (_eventCallback != null) {
      _eventCallback(evCode, p1, p2, p3);
    }
  }
}