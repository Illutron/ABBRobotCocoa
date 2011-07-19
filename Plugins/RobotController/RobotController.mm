#import "RobotController.h"


@implementation RobotController
@synthesize statusLabel;

- (id)init
{
    self = [super init];
    if (self) {
        robot = new ofxABBRobot();

        tickTimer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                                     target:self
                                                   selector:@selector(tick:)
                                                   userInfo:NULL
                                                    repeats:YES];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(void)setup{
    
}

- (void)tick:(NSTimer *)theTimer{
    robot->update();   
}

- (IBAction)updateStatus:(id)sender {
   // ARAPMessage msg = robot->parser->constructMessage(READSTATUS, nil, 0);
    //robot->com->queueMessage(msg);
    ARAP_STATUS status = robot->readStatus();
    switch (status.mode) {
        case 0:
            [statusLabel setStringValue:@"Status: Stand by"];
            break;
        case 1:
            [statusLabel setStringValue:@"Status: Operation"];
            break;
        case 2:
            [statusLabel setStringValue:@"Status: Execution"];
            break;
        case 3:
            [statusLabel setStringValue:@"Status: Emergency stop!"];
            break;
        default:
            break;
    }
        
}
@end
