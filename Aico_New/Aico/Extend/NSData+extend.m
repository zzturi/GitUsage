//
//  NSData+extend.m
//  Aico
//
//  Created by cienet on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSData+extend.h"
#import "zlib.h"

@implementation NSData(extend)
+ (NSData *)uncompressData:(NSData *)compressedData
{   
    if ([compressedData length] == 0) return compressedData;  



    unsigned full_length = [compressedData length];  



    unsigned half_length = [compressedData length] / 2;  

    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];  

    BOOL done = NO;  

    int status;  

    z_stream strm;  

    strm.next_in = (Bytef *)[compressedData bytes];  

    strm.avail_in = [compressedData length];  

    strm.total_out = 0;  

    strm.zalloc = Z_NULL;  

    strm.zfree = Z_NULL;  

    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;  

    while (!done) {  
        
        // Make sure we have enough room and reset the lengths.  
        
        if (strm.total_out >= [decompressed length]) {  
            
            [decompressed increaseLengthBy: half_length];  
            
        }  
        
        strm.next_out = [decompressed mutableBytes] + strm.total_out;  
        
        strm.avail_out = [decompressed length] - strm.total_out;  
        
        // Inflate another chunk.  
        
        status = inflate (&strm, Z_SYNC_FLUSH);  
        
        if (status == Z_STREAM_END) {  
            
            done = YES;  
            
        } else if (status != Z_OK) {  
            
            break;  
            
        }  
        
        
        
    }  

    if (inflateEnd (&strm) != Z_OK) return nil;  

    // Set real length.  

    if (done) {  
        
        [decompressed setLength: strm.total_out];  
        
        return [NSData dataWithData: decompressed];  
        
    } else {  
        
        return nil;  
        
    }  
}
@end
