#import "RobotController.h"


@implementation RobotController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(void)setup{
    
}

-(void)draw:(NSDictionary *)drawingInformation{
    ofSetColor(255, 00, 0);
    
    
    ofRect(0.5,0,0.5*sin(ofGetElapsedTimeMillis()/700.0),1);
}

@end
