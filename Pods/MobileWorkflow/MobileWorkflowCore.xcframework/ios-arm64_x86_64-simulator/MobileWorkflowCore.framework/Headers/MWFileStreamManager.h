//
//  MWFileStreamManager.h
//  MobileWorkflowCore
//
//  Created by Igor Ferreira on 11/3/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(FileStreamManager)
@interface MWFileStreamManager : NSObject

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithOrigin:(NSFileManager *)origin
                 andDestination:(NSFileManager *)destionation
NS_DESIGNATED_INITIALIZER NS_SWIFT_NAME(init(origin:destination:));

- (void) copyFileFromURL:(NSURL *)fileURL
        toDestinationURL:(NSURL *)destinationURL
NS_SWIFT_NAME(copyFile(from:to:));

+ (nullable NSURL *) createEphemeralURLForFileURL:(nullable NSURL *)fileURL
NS_SWIFT_NAME(createEphemeralURL(for:));

+ (nullable NSURL *) extractOriginalFileURLFromEphemeralURL:(nullable NSURL *)ephemenralURL
NS_SWIFT_NAME(extractOriginalFileURL(from:));

@end

NS_ASSUME_NONNULL_END
