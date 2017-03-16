//
//  main.m
//  input
//
//  Created by Charles on 16/03/17.
//  Copyright © 2017 Charles. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NumberIndex(index) [NSNumber numberWithInteger:index]
#define IntegerWithChar(inputChar) [NSString stringWithUTF8String:inputChar].integerValue

@interface linkGame : NSObject

@end

@implementation linkGame

- (NSMutableDictionary *)createDictionaryWithCharacter:(NSString *)string split:(NSString *)split {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *characterArray = [string componentsSeparatedByString:split];
    NSMutableArray *copyArray = [characterArray mutableCopy];
    
    for (NSUInteger i = 0; i < characterArray.count; i++) {
        NSUInteger randomIndex = arc4random() % copyArray.count;
        dic[[NSNumber numberWithInteger:i]] = copyArray[randomIndex];
        [copyArray removeObjectAtIndex:randomIndex];
    }
    NSLog(@"Tell you a secret, there are %@ in boxes", dic);
    return dic;
}

- (NSArray *)showExistingIndexWithBoxes:(NSMutableDictionary *)boxes {
    NSMutableArray *array = [NSMutableArray array];
    [boxes enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [array addObject:key];
    }];
    
    return array;
}

- (NSUInteger)checkInput:(NSUInteger)input WithExistingBoxes:(NSArray *)existingArray {
    
    while (![existingArray containsObject:NumberIndex(input)]) {
        NSLog(@"Plase enter valid number");
        char inputChar[40];
        scanf("%s", inputChar);
        input = IntegerWithChar(inputChar);
    }
    
    return input;
}


@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSUInteger maxTryCount = 40;
        NSUInteger hasTriedCount = 0;
        linkGame *game = [linkGame new];
        NSMutableDictionary *boxes = [game createDictionaryWithCharacter:@"a a b b c c d d e e f f g g h h i i j j"
                                      split:@" "];
        
        while (boxes.count > 1 && hasTriedCount < maxTryCount) {
            NSArray *existingArray = [game showExistingIndexWithBoxes:boxes];
            NSLog(@"Existing number are : %@ \n please choose from them", existingArray);
            char char1[40];
            char char2[40];
            NSUInteger input1;
            NSUInteger input2;
            
            scanf("%s", char1);
            input1 = IntegerWithChar(char1);
            input1 = [game checkInput:input1 WithExistingBoxes:existingArray];
            
            scanf("%s", char2);
            input2 = IntegerWithChar(char2);
            input2 = [game checkInput:input2 WithExistingBoxes:existingArray];

            while (input1 == input2) {
                NSLog(@"Please choose a different box!");
                scanf("%s", char2);
                input2 = IntegerWithChar(char2);
            }
            
            if ([boxes[NumberIndex(input1)] isEqualToString:boxes[NumberIndex(input2)]]) {
                NSLog(@"Correct! There are both %@. You have %ld changes left", boxes[NumberIndex(input1)], maxTryCount - ++hasTriedCount);
                [boxes removeObjectsForKeys:@[NumberIndex(input1), NumberIndex(input2)]];
            } else {
                NSLog(@"Wrong! There are %@ and %@. You have %ld changes left", boxes[NumberIndex(input1)], boxes[NumberIndex(input2)], maxTryCount - ++hasTriedCount);
            }
        }
        
        return hasTriedCount <= maxTryCount;
    }
    return 0;
}

