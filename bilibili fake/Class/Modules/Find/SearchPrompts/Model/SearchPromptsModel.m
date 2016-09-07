//
//  SearchPromptsModel.m
//  bilibili fake
//
//  Created by cxh on 16/9/7.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "SearchPromptsModel.h"
#import "SearchPromptsReqiest.h"

@implementation SearchPromptsModel{
    SearchPromptsReqiest* searchPromptsRequest;
}
-(instancetype)init{
    if (self = [super init]) {
        _historyWordArr = [[NSArray alloc] initWithContentsOfFile:[self getSavePath]];
        //调试
        _historyWordArr = @[@"1",@"2",@"3",@"4"];
        
        searchPromptsRequest =  [SearchPromptsReqiest request];
    }
    return self;
}

-(void)getPromptsWordArrWithKeyWord:(NSString*)keyword  success:(void (^)(void))success failure:(void (^)(NSString *errorMsg))failure{
    [searchPromptsRequest stop];
    searchPromptsRequest.keywork = keyword;
    [searchPromptsRequest startWithCompletionBlock:^(BaseRequest *request) {
        if (request.responseCode == 0) {
            NSDictionary* rawdic = request.responseObject;
            _promptsWordArr = [[NSMutableArray alloc] init];
            [rawdic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [_promptsWordArr addObject:[obj objectForKey:@"name"]];
            }];
            success();
        }else{
            if(failure)failure(request.errorMsg);
        }
    }];
}


//fileWriteRead
-(NSString*)getSavePath{
    NSString* path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [path stringByAppendingPathComponent:@"SearchHistory.plist"];
}

@end
