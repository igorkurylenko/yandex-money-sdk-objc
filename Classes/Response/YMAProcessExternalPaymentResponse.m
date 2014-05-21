//
// Created by Alexander Mertvetsov on 29.01.14.
// Copyright (c) 2014 Yandex.Money. All rights reserved.
//

#import "YMAProcessExternalPaymentResponse.h"
#import "YMAAsc.h"
#import "YMACard.h"
#import "YMAMoneySource.h"

static NSString *const kParameterAcsUrl = @"acs_uri";
static NSString *const kParameterAcsParams = @"acs_params";
static NSString *const kParameterMoneySource = @"money_source";
static NSString *const kParameterType = @"type";
static NSString *const kParameterPaymentCardType = @"payment_card_type";
static NSString *const kParameterPanFragment = @"pan_fragment";
static NSString *const kParameterMoneySourceToken = @"money_source_token";
static NSString *const kParameterInvoceId = @"invoice_id";

static NSString *const kMoneySourceTypePaymentCard = @"payment-card";

@implementation YMAProcessExternalPaymentResponse

#pragma mark -
#pragma mark *** Overridden methods ***
#pragma mark -

- (void)parseJSONModel:(id)responseModel {
    [super parseJSONModel:responseModel];

    NSString *acsUrl = [responseModel objectForKey:kParameterAcsUrl];

    if (acsUrl) {
        NSDictionary *acsParams = [responseModel objectForKey:kParameterAcsParams];
        _asc = [YMAAsc ascWithUrl:[NSURL URLWithString:acsUrl] andParams:acsParams];
    }

    NSDictionary *moneySource = [responseModel objectForKey:kParameterMoneySource];

    if (moneySource) {
        NSString *type = [moneySource objectForKey:kParameterType];

        if ([type isEqual:kMoneySourceTypePaymentCard]) {
            NSString *paymentCardTypeString = [moneySource objectForKey:kParameterPaymentCardType];
            YMAPaymentCardType paymentCardType = [YMACard paymentCardTypeByString:paymentCardTypeString];

            NSString *panFragment = [moneySource objectForKey:kParameterPanFragment];
            NSString *moneySourceToken = [moneySource objectForKey:kParameterMoneySourceToken];

            _moneySource = [YMACard cardSourceWithCardType:paymentCardType panFragment:panFragment moneySourceToken:moneySourceToken];

        } else
            _moneySource = [[YMAMoneySource alloc] initWithSourceType:YMAMoneySourceUnknown];
    }
    
    _invoiceId = [responseModel objectForKey:kParameterInvoceId];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, %@>", [self class], (__bridge void *) self,
                                      @{
                                              @"asc" : [self.asc description],
                                              @"moneySource" : [self.moneySource description]
                                      }];
}

@end