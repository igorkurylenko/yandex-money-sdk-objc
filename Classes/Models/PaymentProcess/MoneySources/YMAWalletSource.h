//
// Created by mertvetcov on 21.05.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMAWalletSource : YMAMoneySourceGroup

+ (instancetype)walletMoneySourceWithAllowed:(BOOL)allowed;

@end