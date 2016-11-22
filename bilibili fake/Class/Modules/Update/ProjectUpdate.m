//
//  ProjectUpdate.m
//  bilibili fake
//
//  Created by cxh on 16/11/22.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "ProjectUpdate.h"
#define UpdateAddressURL @"https://raw.githubusercontent.com/caixuehao/AnimationEffects/master/AnimationEffects/Resources/updateAddress.json"

static ProjectUpdate* shareProjecUpdate;

@implementation ProjectUpdate{
    UpdateAddressEntity* newEntity;
}
+(instancetype)share{
    @synchronized (self) {
        if (!shareProjecUpdate) {
            shareProjecUpdate = [[self alloc] init];
        }
    }
    return shareProjecUpdate;
}

-(void)update{
    NSString* updateAddressPath = [[NSBundle mainBundle] pathForResource:@"updateAddress" ofType:@"json"];
    NSDictionary* updateAddressDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:updateAddressPath] options:NSJSONReadingMutableLeaves error:nil];
    _entity = [UpdateAddressEntity mj_objectWithKeyValues:updateAddressDic];

    
    // NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    [[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:UpdateAddressURL]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary* dataDic =  [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            newEntity = [UpdateAddressEntity mj_objectWithKeyValues:[dataDic objectForKey:@"data"]];
            NSLog(@"newEntity:%@,Entity:%@",newEntity.version,_entity.version);
            if ([newEntity.version compare:_entity.version options:NSNumericSearch]== NSOrderedDescending) {
                NSLog(@"更新：%@",@"");
            }
        }
    }];
    
 

    
    
}
@end
