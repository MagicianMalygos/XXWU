//
//  ZCPOpenUDID.m
//  ZCPKit
//
//  Created by 朱超鹏 on 2018/8/1.
//  Copyright © 2018年 zcp. All rights reserved.
//

#import "ZCPOpenUDID.h"
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIPasteboard.h>
#import <UIKit/UIKit.h>

static NSString * kOpenUDIDSessionCache = nil;
static NSString * const kOpenUDIDKey = @"OpenUDID";
static NSString * const kOpenUDIDSlotKey = @"OpenUDID_slot";
static NSString * const kOpenUDIDAppUIDKey = @"OpenUDID_appUID";
static NSString * const kOpenUDIDTSKey = @"OpenUDID_createdTS";
static NSString * const kOpenUDIDOOTSKey = @"OpenUDID_optOutTS";
static NSString * const kOpenUDIDDomain = @"pafang.OpenUDID";
static NSString * const kOpenUDIDSlotPBPrefix = @"pafang.OpenUDID.slot.";
static int const kOpenUDIDRedundancySlots = 100;




@implementation ZCPOpenUDID


// Archive a NSDictionary inside a pasteboard of a given type
// Convenience method to support iOS & Mac OS X
//
+ (void) _setDict:(id)dict forPasteboard:(id)pboard {
    [pboard setData:[NSKeyedArchiver archivedDataWithRootObject:dict] forPasteboardType:kOpenUDIDDomain];
}

// Retrieve an NSDictionary from a pasteboard of a given type
// Convenience method to support iOS & Mac OS X
//
+ (NSMutableDictionary*) _getDictFromPasteboard:(id)pboard {
    id item = [pboard dataForPasteboardType:kOpenUDIDDomain];
    if (item) {
        @try{
            item = [NSKeyedUnarchiver unarchiveObjectWithData:item];
        } @catch(NSException* e) {
            item = nil;
        }
    }
    
    // return an instance of a MutableDictionary
    return [NSMutableDictionary dictionaryWithDictionary:(item == nil || [item isKindOfClass:[NSDictionary class]]) ? item : nil];
}

// Private method to create and return a new OpenUDID
// Theoretically, this function is called once ever per application when calling [OpenUDID value] for the first time.
// After that, the caching/pasteboard/redundancy mechanism inside [OpenUDID value] returns a persistent and cross application OpenUDID
//
+ (NSString*) _generateFreshOpenUDID {
    
    NSString* _openUDID = nil;
    if (_openUDID==nil) {
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef cfstring = CFUUIDCreateString(kCFAllocatorDefault, uuid);
        const char *cStr = CFStringGetCStringPtr(cfstring,CFStringGetFastestEncoding(cfstring));
        unsigned char result[16];
        CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
        CFRelease(uuid);
        CFRelease(cfstring);
        
        _openUDID = [NSString stringWithFormat:
                     @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%08lx",
                     result[0], result[1], result[2], result[3],
                     result[4], result[5], result[6], result[7],
                     result[8], result[9], result[10], result[11],
                     result[12], result[13], result[14], result[15],
                     (unsigned long)(arc4random() % NSUIntegerMax)];
    }
    return _openUDID;
}



+ (NSString*) value {
    return [ZCPOpenUDID valueWithError:nil];
}

+ (NSString*) valueWithError:(NSError **)error {
    if (kOpenUDIDSessionCache!=nil) {
        if (error!=nil)
            *error = [NSError errorWithDomain:kOpenUDIDDomain
                                         code:kOpenUDIDErrorNone
                                     userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"OpenUDID in cache from first call",@"description", nil]];
        return kOpenUDIDSessionCache;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // The AppUID will uniquely identify this app within the pastebins
    //
    NSString * appUID = [defaults objectForKey:kOpenUDIDAppUIDKey];
    if(appUID == nil)
    {
        // generate a new uuid and store it in user defaults
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        CFStringRef appUIDRef = CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
        appUID = (__bridge NSString *)appUIDRef;
        CFRelease(appUIDRef);
    }
    
    NSString* openUDID = nil;
    NSString* myRedundancySlotPBid = nil;
    NSDate* optedOutDate = nil;
    BOOL optedOut = NO;
    BOOL saveLocalDictToDefaults = NO;
    BOOL isCompromised = NO;
    
    // Do we have a local copy of the OpenUDID dictionary?
    // This local copy contains a copy of the openUDID, myRedundancySlotPBid (and unused in this block, the local bundleid, and the timestamp)
    //
    id localDict = [defaults objectForKey:kOpenUDIDKey];
    if ([localDict isKindOfClass:[NSDictionary class]]) {
        localDict = [NSMutableDictionary dictionaryWithDictionary:localDict]; // we might need to set/overwrite the redundancy slot
        openUDID = [localDict objectForKey:kOpenUDIDKey];
        myRedundancySlotPBid = [localDict objectForKey:kOpenUDIDSlotKey];
        optedOutDate = [localDict objectForKey:kOpenUDIDOOTSKey];
        optedOut = optedOutDate!=nil;
    }
    
    // Here we go through a sequence of slots, each of which being a UIPasteboard created by each participating app
    // The idea behind this is to both multiple and redundant representations of OpenUDIDs, as well as serve as placeholder for potential opt-out
    //
    NSString* availableSlotPBid = nil;
    NSMutableDictionary* frequencyDict = [NSMutableDictionary dictionaryWithCapacity:kOpenUDIDRedundancySlots];
    for (int n=0; n<kOpenUDIDRedundancySlots; n++) {
        NSString* slotPBid = [NSString stringWithFormat:@"%@%d",kOpenUDIDSlotPBPrefix,n];
        UIPasteboard* slotPB = [UIPasteboard pasteboardWithName:slotPBid create:NO];
        if (slotPB==nil) {
            // assign availableSlotPBid to be the first one available
            if (availableSlotPBid==nil) availableSlotPBid = slotPBid;
        } else {
            NSDictionary* dict = [ZCPOpenUDID _getDictFromPasteboard:slotPB];
            NSString* oudid = [dict objectForKey:kOpenUDIDKey];
            
            if (oudid==nil) {
                // availableSlotPBid could inside a non null slot where no oudid can be found
                if (availableSlotPBid==nil) availableSlotPBid = slotPBid;
            } else {
                // increment the frequency of this oudid key
                int count = [[frequencyDict valueForKey:oudid] intValue];
                [frequencyDict setObject:[NSNumber numberWithInt:++count] forKey:oudid];
            }
            // if we have a match with the app unique id,
            // then let's look if the external UIPasteboard representation marks this app as OptedOut
            NSString* gid = [dict objectForKey:kOpenUDIDAppUIDKey];
            if (gid!=nil && [gid isEqualToString:appUID]) {
                myRedundancySlotPBid = slotPBid;
                // the local dictionary is prime on the opt-out subject, so ignore if already opted-out locally
                if (optedOut) {
                    optedOutDate = [dict objectForKey:kOpenUDIDOOTSKey];
                    optedOut = optedOutDate!=nil;
                }
            }
        }
    }
    
    // sort the Frequency dict with highest occurence count of the same OpenUDID (redundancy, failsafe)
    // highest is last in the list
    //
    NSArray* arrayOfUDIDs = [frequencyDict keysSortedByValueUsingSelector:@selector(compare:)];
    NSString* mostReliableOpenUDID = (arrayOfUDIDs!=nil && [arrayOfUDIDs count]>0)? [arrayOfUDIDs lastObject] : nil;
    
    // if openUDID was not retrieved from the local preferences, then let's try to get it from the frequency dictionary above
    //
    if (openUDID==nil) {
        if (mostReliableOpenUDID==nil) {
            // this is the case where this app instance is likely to be the first one to use OpenUDID on this device
            // we create the OpenUDID, legacy or semi-random (i.e. most certainly unique)
            //
            openUDID = [ZCPOpenUDID _generateFreshOpenUDID];
        } else {
            // or we leverage the OpenUDID shared by other apps that have already gone through the process
            //
            openUDID = mostReliableOpenUDID;
        }
        // then we create a local representation
        //
        if (localDict==nil) {
            localDict = [NSMutableDictionary dictionaryWithCapacity:4];
            [localDict setObject:openUDID forKey:kOpenUDIDKey];
            [localDict setObject:appUID forKey:kOpenUDIDAppUIDKey];
            [localDict setObject:[NSDate date] forKey:kOpenUDIDTSKey];
            if (optedOut) [localDict setObject:optedOutDate forKey:kOpenUDIDTSKey];
            saveLocalDictToDefaults = YES;
        }
    }
    else {
        // Sanity/tampering check
        //
        if (mostReliableOpenUDID!=nil && ![mostReliableOpenUDID isEqualToString:openUDID])
            isCompromised = YES;
    }
    
    // Here we store in the available PB slot, if applicable
    
    if (availableSlotPBid!=nil && (myRedundancySlotPBid==nil || [availableSlotPBid isEqualToString:myRedundancySlotPBid])) {
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
        UIPasteboard* slotPB = [UIPasteboard pasteboardWithName:availableSlotPBid create:YES];
        [slotPB setPersistent:YES];
#else
        NSPasteboard* slotPB = [NSPasteboard pasteboardWithName:availableSlotPBid];
#endif
        
        // save slotPBid to the defaults, and remember to save later
        //
        if (localDict) {
            [localDict setObject:availableSlotPBid forKey:kOpenUDIDSlotKey];
            saveLocalDictToDefaults = YES;
        }
        
        // Save the local dictionary to the corresponding UIPasteboard slot
        //
        if (openUDID && localDict)
            [ZCPOpenUDID _setDict:localDict forPasteboard:slotPB];
    }
    
    // Save the dictionary locally if applicable
    //
    if (localDict && saveLocalDictToDefaults)
        [defaults setObject:localDict forKey:kOpenUDIDKey];
    
    // If the UIPasteboard external representation marks this app as opted-out, then to respect privacy, we return the ZERO OpenUDID, a sequence of 40 zeros...
    // This is a *new* case that developers have to deal with. Unlikely, statistically low, but still.
    // To circumvent this and maintain good tracking (conversion ratios, etc.), developers are invited to calculate how many of their users have opted-out from the full set of users.
    // This ratio will let them extrapolate convertion ratios more accurately.
    //
    if (optedOut) {
        if (error!=nil) *error = [NSError errorWithDomain:kOpenUDIDDomain
                                                     code:kOpenUDIDErrorOptedOut
                                                 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Application with unique id %@ is opted-out from OpenUDID as of %@",appUID,optedOutDate],@"description", nil]];
        
        kOpenUDIDSessionCache = [NSString stringWithFormat:@"%040x",0];
        return kOpenUDIDSessionCache;
    }
    
    // return the well earned openUDID!
    //
    if (error!=nil) {
        if (isCompromised)
            *error = [NSError errorWithDomain:kOpenUDIDDomain
                                         code:kOpenUDIDErrorCompromised
                                     userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Found a discrepancy between stored OpenUDID (reliable) and redundant copies; one of the apps on the device is most likely corrupting the OpenUDID protocol",@"description", nil]];
        else
            *error = [NSError errorWithDomain:kOpenUDIDDomain
                                         code:kOpenUDIDErrorNone
                                     userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"OpenUDID succesfully retrieved",@"description", nil]];
    }
    kOpenUDIDSessionCache = openUDID;
    return kOpenUDIDSessionCache;
}

+ (void) setOptOut:(BOOL)optOutValue {
    
    // init call
    [ZCPOpenUDID value];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // load the dictionary from local cache or create one
    id dict = [defaults objectForKey:kOpenUDIDKey];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        dict = [NSMutableDictionary dictionaryWithDictionary:dict];
    } else {
        dict = [NSMutableDictionary dictionaryWithCapacity:2];
    }
    
    // set the opt-out date or remove key, according to parameter
    if (optOutValue)
        [dict setObject:[NSDate date] forKey:kOpenUDIDOOTSKey];
    else
        [dict removeObjectForKey:kOpenUDIDOOTSKey];
    
    // store the dictionary locally
    [defaults setObject:dict forKey:kOpenUDIDKey];
    
    // reset memory cache
    kOpenUDIDSessionCache = nil;
    
}

@end
