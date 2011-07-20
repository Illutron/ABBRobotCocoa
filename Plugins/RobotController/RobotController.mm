#import "RobotController.h"


@implementation RobotController
@synthesize speedmm;
@synthesize speedprc;
@synthesize coordinateMode;
@synthesize locationX;
@synthesize locationY;
@synthesize locationZ;
@synthesize locationQ1;
@synthesize locationQ2;
@synthesize locationQ3;
@synthesize locationQ4;
@synthesize logArrayController;
@synthesize logArray,statusLabel;

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
        errorCheckCount = 0;
        
        
    }
    
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    logArray = [NSMutableArray  array];
    [logArrayController addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSDate date],@"date",@"Blablabla",@"message", nil]];
    
}
- (void)dealloc
{
    [super dealloc];
}

-(void)setup{
    
}

- (IBAction)move:(id)sender {
    ARAP_COORDINATE coord;
    coord.x = [locationX intValue];
    coord.y = [locationY intValue];
    coord.z = [locationZ intValue];
    coord.q1 = [locationQ1 intValue];
    coord.q2 = [locationQ2 intValue];
    coord.q3 = [locationQ3 intValue];
    coord.q4 = [locationQ4 intValue];
    robot->move(coord, [speedmm intValue], [speedprc intValue], true, [coordinateMode selectedRow]);
    
}

- (void)tick:(NSTimer *)theTimer{
    robot->update();  
    vector<ARAPMessage> messages = robot->com->readMessagesAfterCount(errorCheckCount);
    if(messages.size() > 0){
        errorCheckCount = robot->com->readMessageCounter;
        for(int i=0;i<messages.size();i++){
            if(robot->isErrorMessage(messages[i])){
                [logArrayController addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [NSDate date],@"date",
                                               [NSString stringWithCString:robot->errorMessageToString(messages[i]).c_str() encoding:NSUTF8StringEncoding],@"message", nil]];
            }
            if(robot->isWarningMessage(messages[i])){
                [logArrayController addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [NSDate date],@"date",
                                               [NSString stringWithCString:robot->warningMessageToString(messages[i]).c_str() encoding:NSUTF8StringEncoding],@"message", nil]];
            }
        }
    }
}

- (IBAction)updateStatus:(id)sender {
    // ARAPMessage msg = robot->parser->constructMessage(READSTATUS, nil, 0);
    //robot->com->queueMessage(msg);
    ARAP_STATUS status = robot->readStatus();
    currentMode = status.mode;
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
    [locationX setIntValue:status.location.x];
    [locationY setIntValue:status.location.y];
    [locationZ setIntValue:status.location.z];
    [locationQ1 setIntValue:status.location.q1];
    [locationQ2 setIntValue:status.location.q2];
    [locationQ3 setIntValue:status.location.q3];
    [locationQ4 setIntValue:status.location.q4];

//    [self performSelector:@selector(updateStatus:) withObject:self afterDelay:2.0];

}

- (IBAction)toggleMode:(id)sender {
    if(currentMode == OPERATION){
        robot->writeMode(STANDBY);
    } else if(currentMode == STANDBY){
        robot->writeMode(OPERATION);
    } else if(currentMode == EMERGENCYSTOP){
        robot->writeMode(OPERATION);
    } else if(currentMode == EXECUTION){
        robot->writeMode(OPERATION);
    }
//    [self performSelector:@selector(updateStatus:) withObject:self afterDelay:1.0];
}

- (IBAction)sync:(id)sender {
    robot->writeMode(OPERATIONANDSYNCHRONIZATION);
    
}

- (IBAction)startProgram:(id)sender {
    robot->startProgram(true, 1);
}

- (IBAction)stopProgram:(id)sender {
    robot->stopProgram();
}

- (IBAction)uploadProgram:(id)sender {
}

- (IBAction)downloadProgram:(id)sender {
    ARAP_PROGRAM program = robot->receiveProgram(1);
    
}
@end
