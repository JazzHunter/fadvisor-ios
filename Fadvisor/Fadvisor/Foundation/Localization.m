//
//  Localization.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/24.
//

#import "Localization.h"

@interface Localization ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSBundle *> *moduleBundleMap;

@end

@implementation Localization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.moduleBundleMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSBundle *)addModule:(NSString *)module {
    NSBundle *bundle = [self.moduleBundleMap objectForKey:module];
    if (bundle) {
        return bundle;
    }
    
    NSString *path = [NSBundle.mainBundle.resourcePath stringByAppendingPathComponent:[module stringByAppendingString:@".bundle/Localization"]];
    bundle = [NSBundle bundleWithPath:path];
    [self.moduleBundleMap setObject:bundle forKey:module];
    return bundle;
}

+ (Localization *)shared {
    static Localization *_global = nil;
    if (!_global) {
        _global = [Localization new];
    }
    
    return _global;
}

+ (NSString *)stringWithKey:(NSString *)key withModule:(NSString *)module {
    NSBundle *bundle = [[self shared] addModule:module];
    return NSLocalizedStringFromTableInBundle(key, nil, bundle, nil);
}

@end
