//
//  HKURLImageView.m
//  hkutil2
//
//  Created by akwei on 13-4-22.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKURLImageView.h"
#import "HKDownloader.h"

static NSCache* _shareImageCache;
static HKDownloaderMgr* _shareDownloaderMgr;
static NSTimeInterval _globalTimeout;
@implementation HKURLImageView{
    NSData* _imageData;
    NSString* _imageUrl;
}

+(void)setGlobalTimeout:(NSTimeInterval)t{
    _globalTimeout = t;
}

+(NSTimeInterval)getGlobalTimeout{
    return _globalTimeout;
}

-(id)init{
    self = [super init];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareDownloaderMgr = [[HKDownloaderMgr alloc] init];
            _shareImageCache = [[NSCache alloc] init];
            _shareImageCache.countLimit = 100;
            _shareImageCache.totalCostLimit = 100 * 1024 * 1024;
        });
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareDownloaderMgr = [[HKDownloaderMgr alloc] init];
            _shareImageCache = [[NSCache alloc] init];
            _shareImageCache.countLimit = 100;
            _shareImageCache.totalCostLimit = 100 * 1024 * 1024;
        });
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareDownloaderMgr = [[HKDownloaderMgr alloc] init];
            _shareImageCache = [[NSCache alloc] init];
            _shareImageCache.countLimit = 100;
            _shareImageCache.totalCostLimit = 100 * 1024 * 1024;
        });
    }
    return self;
}

-(void)loadFromUrl:(NSString *)url onErrorBlock:(void (^)(void))onErrorBlock{
    BOOL isCanLoadFromUrl = NO;
    if (!_imageUrl) {
        _imageUrl = [url copy];
        isCanLoadFromUrl = YES;
    }
    else if ([_imageUrl isEqualToString:url]) {//还是同样的url
        if (_imageData) {
            isCanLoadFromUrl = NO;
        }
        else{
            //load local
            _imageData = [_shareImageCache objectForKey:_imageUrl];
            if (_imageData) {
                isCanLoadFromUrl = NO;
            }
            else{
                isCanLoadFromUrl = YES;
            }
        }
    }
    else{//url不同了，需要加载不同图片
        _imageUrl = [url copy];
        _imageData = [_shareImageCache objectForKey:_imageUrl];
        if (_imageData) {
            isCanLoadFromUrl = NO;
        }
        else{
            isCanLoadFromUrl = YES;
        }
    }
    if (isCanLoadFromUrl) {
        HKCallbackHandler * handler = [[HKCallbackHandler alloc] init];
        [handler setOnFinishBlock:^(NSString *url, NSData *data, NSHTTPURLResponse *httpResponse) {
            if (httpResponse.statusCode == 200) {
                [_shareImageCache setObject:data forKey:url cost:[data length]];
                if ([_imageUrl isEqualToString:url]) {
                    _imageData = data;
                    [self showImage];
                }
            }
            else{
                //NSLog(@"http statusCode:%d",httpResponse.statusCode);
                if (onErrorBlock) {
                    onErrorBlock();
                }
            }
        }];
        [handler setOnErrorBlock:^(NSString *url, NSError *error, NSHTTPURLResponse *httpResponse) {
            //NSLog(@"can not load data from url:%@",url);
            if (onErrorBlock) {
                onErrorBlock();
            }
        }];
        NSTimeInterval t = _globalTimeout;
        if (self.timeout > 0) {
            t = self.timeout;
        }
        [_shareDownloaderMgr downloadWithUrl:_imageUrl callbackHandler:handler timeout:t];
    }
    else{
        [self showImage];
    }
}

-(void)showImage{
    self.image = [[UIImage alloc] initWithData:_imageData];
}

-(void)clear{
    self.image = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
