#import "LinkerPlugin.h"


@interface Promise : NSObject

-(id) get;

-(void)set:(id)value;

@end


@interface Promise()
{
    id _value;
    NSCondition *_lock;
}

@end


@implementation Promise

-(id)init{
    if (self = [super init]){
        
        _lock = [[NSCondition alloc]init];
    }
    return self;
}


-(id)get{
    if(_value){
        return _value;
    }
    
    [_lock lock];
    while(!_value){
        [_lock wait];
    }
    [_lock unlock];
    return _value;
}

-(void)set:(id)value{
    [_lock lock];
    _value = value;
    [_lock signal];
    [_lock unlock];
}

@end


@interface LinkerPlugin()

@property (nonatomic,weak) FlutterMethodChannel* channel;

@end

@implementation LinkerPlugin



+(LinkerPlugin*)sharedInstance{
    static LinkerPlugin *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LinkerPlugin alloc]init];
    });
    return sharedInstance;
}


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"linker"
            binaryMessenger:[registrar messenger]];
    LinkerPlugin* instance = [LinkerPlugin sharedInstance];
    instance.channel = channel;
  [registrar addMethodCallDelegate:instance channel:channel];
}




-(BOOL)handleOpenURL:(NSURL *)url{
    Promise* promise = [[Promise alloc]init];
    [_channel invokeMethod:@"handleOpenURL" arguments:url.absoluteString result:^(id  _Nullable result) {
        [promise set:result];
    }];
    
    return [[promise get]boolValue];
    
}



- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* method = call.method;
    
  if ([@"openURL" isEqualToString:method]) {
      if (@available(iOS 10.0, *)) {
          [[UIApplication sharedApplication]openURL:[NSURL URLWithString:call.arguments] options:@{} completionHandler:^(BOOL success) {
              result(@(success));
          }];
      } else {
          BOOL success = [[UIApplication sharedApplication]openURL:[NSURL URLWithString:call.arguments]];
          result(@(success));
      }
  }else if([@"canOpenURL" isEqualToString:method]){
      
      BOOL value = [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:call.arguments]];
      result(@(value));
  }else if([@"openSetting" isEqualToString:method]){
      NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
      if([[UIApplication sharedApplication] canOpenURL:url]) {
          NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
         BOOL value =  [[UIApplication sharedApplication] openURL:url];
          result(@(value));
      }else{
          result(@(NO));
      }
  }  else {
    result(FlutterMethodNotImplemented);
  }
}

@end
