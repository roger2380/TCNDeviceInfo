//
//  NSData+TCNGzip.m
//  TCNDataEncoding
//
//  Created by zhou on 2017/7/10.
//  Copyright © 2017年 tangyiyuan. All rights reserved.
//

#import "NSData+TCNGzip.h"
#include <zlib.h>

@implementation NSData (TCNGzip)

- (NSData *)gzip {
  NSMutableData *compressedData = [NSMutableData dataWithLength:[self length]];
  z_stream strm;
  strm.next_in = (Bytef *)[self bytes];
  strm.avail_in = (uInt)[self length];
  strm.total_out = 0;
  strm.zalloc = Z_NULL;
  strm.zfree = Z_NULL;
  strm.opaque = Z_NULL;
  if (deflateInit(&strm, 7) == Z_OK){
    strm.avail_out = (uInt)[self length];
    strm.next_out = (Bytef *)[compressedData bytes];
    deflate(&strm, Z_FINISH);
    [compressedData setLength:strm.total_out];
  }
  deflateEnd(&strm);
  return [NSData dataWithData:compressedData];
}

@end
