//
//  DownloadOperation.m
//  bilibili fake
//
//  Created by 翟泉 on 2016/8/3.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "DownloadOperation.h"
#import "NSString+MD5.h"


@protocol __DownloadOperationDelegate <NSObject>

- (void)start;
- (void)stop;

@end

@interface __DownloadOperation : NSOperation
{
    BOOL _finished;
    BOOL _executing;
    BOOL _cancelled;
}

@property (assign, nonatomic) id<__DownloadOperationDelegate> delegate;

- (void)finish;

@end





@interface DownloadOperation ()
<__DownloadOperationDelegate>

@property (strong, nonatomic, readonly, nonnull) __DownloadOperation *operation;
@property (weak, nonatomic, nullable) NSOperationQueue *weakQueue;

@property (weak, nonatomic) NSURLSession *session;
@property (weak, nonatomic) NSURLSessionDataTask *dataTask;

@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSFileHandle *fileHandle;

@property (assign, nonatomic) unsigned long long downloadOffset;

@property (assign, nonatomic) CFAbsoluteTime time;
@property (assign, nonatomic) unsigned long long bytesReceived;

@end

@implementation DownloadOperation

- (instancetype)initWithURL:(NSURL *)url session:(NSURLSession *)session queue:(NSOperationQueue *)queue {
    if (self = [super init]) {
        _url = [url copy];
        _session = session;
        _status = DownloadOperationStatusNone;
        _operation = [[__DownloadOperation alloc] init];
        _operation.delegate = self;
        self.weakQueue = queue;
    }
    return self;
}

- (void)resume {
    if (self.status == DownloadOperationStatusNone ||
        self.status == DownloadOperationStatusPause) {
        [self.weakQueue addOperation:self.operation];
        self.status = DownloadOperationStatusWaiting;
    }
}
- (void)pause {
    [self.dataTask suspend];
    [self.operation finish];
    _operation = [[__DownloadOperation alloc] init];
    _operation.delegate = self;
    self.status = DownloadOperationStatusPause;
}

- (void)stop {
    [self.dataTask cancel];
}

#pragma mark __DownloadOperationDelegate
- (void)start {
    self.status = DownloadOperationStatusRuning;
    if (_dataTask) {
        [_dataTask resume];
    }
    else {
        [self.dataTask resume];
    }
}

#pragma mark NSURLSessionDelegate
- (void)receiveData:(NSData *)data {
    _bytesReceived += data.length;
    
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
    if (currentTime - _time > 1 || _speed == 0) {
        _speed = _bytesReceived / (currentTime - _time);
        _time = currentTime;
        _bytesReceived = 0;
    }
    
    [_fileHandle writeData:data];
    [_fileHandle seekToEndOfFile];
}

- (void)completeWithError:(NSError *)error {
    [_fileHandle closeFile];
    if (error) {
        [[NSFileManager defaultManager] removeItemAtPath:_filePath error:NULL];
        self.status = DownloadOperationStatusFailure;
    }
    else {
        NSString *toPath = [_filePath stringByAppendingPathExtension:_dataTask.response.suggestedFilename.pathExtension];
        NSURL *toURL = [NSURL fileURLWithPath:toPath];
        [[NSFileManager defaultManager] moveItemAtURL:[NSURL fileURLWithPath:_filePath] toURL:toURL error:NULL];
        self.status = DownloadOperationStatusSuccess;
    }
}

#pragma mark get / set

- (void)setStatus:(DownloadOperationStatus)status {
    _status = status;
    switch (status) {
        case DownloadOperationStatusFailure:
        case DownloadOperationStatusSuccess:
            [self.operation finish];
            break;
            
        default:
            break;
    }
}

- (NSURLSessionDataTask *)dataTask {
    if (!_dataTask) {
        _filePath = [NSString stringWithFormat:@"%@/%@",self.downloadDirectory, _url.absoluteString.md5];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_filePath]) {
            [[NSFileManager defaultManager] createFileAtPath:_filePath contents:NULL attributes:NULL];
        }
        
        _fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.filePath];
        [_fileHandle seekToEndOfFile];
        _downloadOffset = _fileHandle.offsetInFile;
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
        NSString *range = [NSString stringWithFormat:@"bytes=%llu-", _downloadOffset];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        _dataTask = [_session dataTaskWithRequest:request];
        _dataTask.operation = self;
    }
    return _dataTask;
}

- (unsigned long long)countOfBytesReceived {
    return _downloadOffset + _dataTask.countOfBytesReceived;
}

- (unsigned long long)countOfBytesExpectedToReceive {
    return _downloadOffset + _dataTask.countOfBytesExpectedToReceive;
}

- (NSString *)downloadDirectory {
    if (!_downloadDirectory) {
        _downloadDirectory = @"/Users/cezr/Desktop/Download";
    }
    BOOL isDirectory;
    [[NSFileManager defaultManager] fileExistsAtPath:_downloadDirectory isDirectory:&isDirectory];
    if (!isDirectory) {
        [[NSFileManager defaultManager] createDirectoryAtPath:_downloadDirectory withIntermediateDirectories:YES attributes:NULL error:NULL];
    }
    return _downloadDirectory;
}

@end



#pragma mark - Operation

@implementation __DownloadOperation

- (void)finish {
    [self setExecuting:NO];
    [self setFinished:YES];
    NSLog(@"finish");
}

- (void)start {
    if (self.isCancelled) {
        [self.delegate stop];
        return;
    }
    [self.delegate start];
    [self setExecuting:YES];
}

- (void)cancel {
    if (self.isExecuting) {
        [self.delegate stop];
        self.executing = NO;
    }
    [self setFinished:YES];
}

#pragma mark Get/Set

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isFinished {
    return _finished;
}
- (BOOL)finished {
    return _finished;
}
- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}


- (BOOL)isExecuting {
    return _executing;
}
- (BOOL)executing {
    return _executing;
}
- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}


- (BOOL)isCancelled {
    return _cancelled;
}
- (BOOL)cancelled {
    return _cancelled;
}
- (void)setCancelled:(BOOL)cancelled {
    [self willChangeValueForKey:@"isCancelled"];
    _cancelled = cancelled;
    [self didChangeValueForKey:@"isCancelled"];
}


@end


#pragma mark - NSURLSessionTask+Download

@implementation NSURLSessionTask (__Download)

- (void)setOperation:(DownloadOperation *)operation {
    objc_setAssociatedObject(self, @selector(operation), operation, OBJC_ASSOCIATION_ASSIGN);
}
- (DownloadOperation *)operation {
    DownloadOperation *operation = objc_getAssociatedObject(self, @selector(operation));
    if ([operation isKindOfClass:[DownloadOperation class]]) {
        return operation;
    }
    else {
        return NULL;
    }
}


@end