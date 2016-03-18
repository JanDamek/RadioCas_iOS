//
//  comPlayer.m
//  ABradio
//
//  Created by Jan Damek on 28.02.13.
//  Copyright (c) 2013 droidsoft.eu. All rights reserved.
//

#import "comPlayer.h"

@implementation comPlayer

@synthesize delegate, streamURL = _streamURL, player = _player;

static void *comSecondViewControllerCurrentItemObservationContext = &comSecondViewControllerCurrentItemObservationContext;
static void *comSecondViewControllerPlayerItemStatusObserverContext = &comSecondViewControllerPlayerItemStatusObserverContext;
static void *comSecondViewControllerTimedMetadataObserverContext = &comSecondViewControllerTimedMetadataObserverContext;

NSString *kCurrentItemKey	= @"currentItem";
NSString *kStatusKey		= @"status";
NSString *kTimedMetadataKey	= @"timedMetadata";
NSString *kTracksKey		= @"tracks";
NSString *kPlayableKey		= @"playable";

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if ([self.delegate respondsToSelector:@selector(stopPlaying:)]) {
        [self.delegate stopPlaying:self];
    }
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(stopPlaying:)]) {
        [self.delegate stopPlaying:self];
    }
}
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    if ([self.delegate respondsToSelector:@selector(startInteruptPlaying:)]) {
        [self.delegate startInteruptPlaying:self];
    }
}
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags NS_AVAILABLE_IOS(6_0){
    if ([self.delegate respondsToSelector:@selector(stopInteruptPlaying:)]) {
        [self.delegate stopInteruptPlaying:self];
    }
};
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags NS_DEPRECATED_IOS(4_0, 6_0){
    if ([self.delegate respondsToSelector:@selector(stopInteruptPlaying:)]) {
        [self.delegate stopInteruptPlaying:self];
    }
};
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player NS_DEPRECATED_IOS(2_2, 6_0){
    if ([self.delegate respondsToSelector:@selector(stopInteruptPlaying:)]) {
        [self.delegate stopInteruptPlaying:self];
    }
};
-(void)playerItemDidReachEnd:(AVPlayerItem*)_player{
    [self stop];
    //    if ([self.delegate respondsToSelector:@selector(stopPlaying:)]) {
    //        [self.delegate stopPlaying:self];
    //    }
}


-(id)init{
    if (self=[super init]){
        [comPlayer prepareBackgroundPlayAndSetDefaultSoundRoute];
        
    }
    _streamURL = @"";
    _playerItem = nil;
    _player = nil;
    return self;
}

-(id)initWithURL:(NSString *)streamURL
{
    if (self = [super init]){
        _streamURL = streamURL;
        [comPlayer prepareBackgroundPlayAndSetDefaultSoundRoute];
    } else {
        _streamURL = @"";
    }
    
    _playerItem = nil;
    _player = nil;
    return self;
}

+(void)prepareBackgroundPlayAndSetDefaultSoundRoute
{
    NSError *sessionError = nil;
//    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
//    UInt32 doChangeDefaultRoute = 1;
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
}

-(void)dealloc
{
    [self stop];
    
#if !__has_feature(objc_arc)
    [_playerItem release];
    [_player release];
#endif
    _playerItem = nil;
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(void)play
{
    NSURL *newMovieURL = [NSURL URLWithString:_streamURL];
    if ([newMovieURL scheme])	// test na pravost url
    {
        
        // vytvoreni URLAsset pro klice "tracks", "playable".
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:newMovieURL options:nil];
        NSArray *requestedKeys = [NSArray arrayWithObjects:kTracksKey, kPlayableKey, nil];
        
        /* natazeni klicu to asset, pokud uz neni nahrany. */
        [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
         ^{
             dispatch_async( dispatch_get_main_queue(),
                            ^{
                                /* priprava prehravace */
                                [self prepareToPlayAsset:asset withKeys:requestedKeys];
                                
                                if ([self.delegate respondsToSelector:@selector(preparePlay:)]) {
                                    [self.delegate preparePlay:self];
                                }
                                
                            });
         }];
        
    }
}

-(void)stop
{
    [_player pause];
    
    if ([self.delegate respondsToSelector:@selector(stopPlaying:)]) {
        [self.delegate stopPlaying:self];
    }
}

-(float)getRate{
    return [_player rate];
}

- (void)handleTimedMetadata:(AVMetadataItem*)timedMetadata
{
    NSString *metastr = [timedMetadata stringValue];
    
    if ([self.delegate respondsToSelector:@selector(metaData:meta:)]) {
        [self.delegate metaData:self meta:metastr];
    }
}

-(void)assetFailedToPrepareForPlayback:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(stopPlaying:)]) {
        [self.delegate stopPlaying:self];
    }
}

- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
	for (NSString *thisKey in requestedKeys)
    {
		NSError *error = nil;
		AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
		if (keyStatus == AVKeyValueStatusFailed)
        {
			[self assetFailedToPrepareForPlayback:error];
			return;
        }
    }
    
    // nelze prehravat
    if (!asset.playable)
    {
		NSString *localizedDescription = NSLocalizedString(@"Item cannot be played", @"Item cannot be played description");
		NSString *localizedFailureReason = NSLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
		NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
								   localizedDescription, NSLocalizedDescriptionKey,
								   localizedFailureReason, NSLocalizedFailureReasonErrorKey,
								   nil];
		NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"player" code:0 userInfo:errorDict];
        
        [self assetFailedToPrepareForPlayback:assetCannotBePlayedError];
        
        return;
    }
	
    // existujici polozka prehravace
    if (_playerItem)
    {
        // je ji nutno vyradit ze sledovani
        if (_regTimedMeta){
            [_player.currentItem removeObserver:self forKeyPath:kTimedMetadataKey];
            _regTimedMeta = NO;
        }
        
        [_playerItem removeObserver:self forKeyPath:kStatusKey];
		
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:_playerItem];
    }
	
    // vytvorit novou plozku prehravace
    _playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    //zarazeni k sledovani stavu
    [_playerItem addObserver:self
                  forKeyPath:kStatusKey
                     options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                     context:comSecondViewControllerPlayerItemStatusObserverContext];
	
    //zarazeni k sledovani konce
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:_playerItem];
	
    //pokud neni prehravac tak zalozit novy
    if (!_player)
    {
        // vyrvoreni noveho prehravace z polozky
#if !__has_feature(objc_arc)
        //Do manual memory management...
        _player = [[AVPlayer playerWithPlayerItem:_playerItem] retain];
#else
        //Usually do nothing...
        _player = [AVPlayer playerWithPlayerItem:_playerItem];
#endif
		
        //sledovani pro aktualni polozku
        [_player addObserver:self
                  forKeyPath:kCurrentItemKey
                     options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                     context:comSecondViewControllerCurrentItemObservationContext];
        
    }
    
    // pokud neni aktualni polozka polozkou k prehravani
    if (![_player.currentItem isEqual:_playerItem])
    {
        //vymenit aktualni polozku
        [_player replaceCurrentItemWithPlayerItem:_playerItem];
    }
    
}

- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
    // zmena stavu prehravace
	if (context == comSecondViewControllerPlayerItemStatusObserverContext)
    {
        
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status)
        {
                
            case AVPlayerStatusUnknown:
            {
                
                if ([self.delegate respondsToSelector:@selector(stopPlaying:)]) {
                    [self.delegate stopPlaying:self];
                }
                
            }
                break;
                
            case AVPlayerStatusReadyToPlay:
            {
                // prehravac je pripraven a nabuffrovan
                
                [_player play];
                
                if ([self.delegate respondsToSelector:@selector(startPlaying:)]) {
                    [self.delegate startPlaying:self];
                }
                
                //sledovani metatagu
                [_player.currentItem addObserver:self
                                      forKeyPath:kTimedMetadataKey
                                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                                         context:comSecondViewControllerTimedMetadataObserverContext];
                _regTimedMeta = YES;
                
            }
                break;
                
            case AVPlayerStatusFailed:
            {
                // nastala chyba v inicializaci, nebo streamu
                
                AVPlayerItem *thePlayerItem = (AVPlayerItem *)object;
                [self assetFailedToPrepareForPlayback:thePlayerItem.error];
                
                if ([self.delegate respondsToSelector:@selector(stopPlaying:)]) {
                    [self.delegate stopPlaying:self];
                }
            }
                break;
        }
    }
	
    //zmena polozky pro prehravani
	else if (context == comSecondViewControllerCurrentItemObservationContext)
    {
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        
        // neni polozka k prehravani
        if (newPlayerItem == (id)[NSNull null])
        {
        }
        else
        {
            
        }
        
    }
	
    // dorazili timetMetaData provede pro vseechny key volani handle
	else if (context == comSecondViewControllerTimedMetadataObserverContext)
    {
		NSArray* array = [[_player currentItem] timedMetadata];
		for (AVMetadataItem *metadataItem in array)
        {
			[self handleTimedMetadata:metadataItem];
        }
    }
	else
    {
		[super observeValueForKeyPath:path ofObject:object change:change context:context];
    }
    
    return;
}

-(BOOL)getIsPlaying{
    if (_player){
        return _player.rate != 0;
    }else return  NO;
}

-(NSString *)decodeCZ:(NSString *)inText{
    NSString *metastr = inText;
    NSString *znak;
    NSString *metafinal = [[NSString alloc]init];
    
    for (int i=0;i<[metastr length];i++) {
        if ([metastr characterAtIndex:i]!=0xc3 && [metastr characterAtIndex:i] != 0xc2 && [metastr characterAtIndex:i] != 0xbe && [metastr characterAtIndex:i] != 0xc5 && [metastr characterAtIndex:i] != 0xc4){
            unichar okznak = [metastr characterAtIndex:i];
            znak = [NSString stringWithCharacters:&okznak length:1];
            metafinal = [metafinal stringByAppendingFormat:@"%@", znak];
        }else {
            if ([metastr length]>i+1){
                unichar strRidici = [metastr characterAtIndex:i];
                i++;
                unichar strZnak = [metastr characterAtIndex:i];
                switch (strRidici) {
                    case 195:
                        switch (strZnak) {
                            case 173:
                                znak = @"í";
                                break;
                            case 161:
                                znak = @"á";
                                break;
                            case 169:
                                znak = @"é";
                                break;
                            case 189:
                                znak = @"ý";
                                break;
                            case 186:
                                znak = @"ú";
                                break;
                            case 157:
                                znak = @"Ý";
                                break;
                            case 129:
                                znak = @"Á";
                                break;
                            case 141:
                                znak = @"Í";
                                break;
                            case 137:
                                znak = @"É";
                                break;
                            case 154:
                                znak = @"Ú";
                                break;
                            case 179:
                                znak = @"ó";
                                break;
                            case 147:
                                znak = @"Ó";
                                break;
                            case 130:
                                znak = @"'";
                                break;
                                
                            default:
                                znak = [NSString stringWithFormat:@"%d-%d", strRidici, strZnak];
                                break;
                        }
                        break;
                    case 197:
                        switch (strZnak) {
                            case 174:
                                znak = @"Ů";
                                break;
                            case 189:
                                znak = @"Ž";
                                break;
                            case 160:
                                znak = @"Š";
                                break;
                            case 161:
                                znak = @"š";
                                break;
                            case 153:
                                znak = @"ř";
                                break;
                            case 190:
                                znak = @"ž";
                                break;
                            case 175:
                                znak = @"ů";
                                break;
                            case 152:
                                znak = @"Ř";
                                break;
                            case 165:
                                znak = @"ť";
                                break;
                            case 164:
                                znak = @"Ť";
                                break;
                            case 136:
                                znak = @"ň";
                                break;
                            case 135:
                                znak = @"Ň";
                                break;
                                
                                
                            default:
                                znak = [NSString stringWithFormat:@"%d-%d", strRidici, strZnak];
                                break;
                        }
                        break;
                    case 196:
                        switch (strZnak) {
                            case 0xa1:
                                znak = @"š";
                                break;
                            case 0xaf:
                                znak = @"ů";
                                break;
                            case 0x8c:
                                znak = @"Č";
                                break;
                            case 0x8d:
                                znak = @"č";
                                break;
                            case 0x99:
                                znak = @"ř";
                                break;
                            case 165:
                                znak = @"ť";
                                break;
                            case 155:
                                znak = @"ě";
                                break;
                            case 154:
                                znak = @"Ě";
                                break;
                            case 143:
                                znak = @"ď";
                                break;
                            case 142:
                                znak = @"Ď";
                                break;
                            case 190:
                                znak = @"ľ";
                                break;
                            case 189:
                                znak = @"Ľ";
                                break;
                                
                            default:
                                znak = [NSString stringWithFormat:@"%d-%d", strRidici, strZnak];
                                break;
                        }
                        break;
                        
                    default:
                        // neni definovan
                        znak = [NSString stringWithFormat:@"%d-%d", strRidici, strZnak];
                        break;
                }
                
                metafinal = [metafinal stringByAppendingFormat:@"%@", znak];
            }
        }
    }
    
    return metafinal;
}

@end
