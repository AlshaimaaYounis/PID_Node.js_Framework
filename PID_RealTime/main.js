// PID controller with Kalman Filter to Double-Tank Process
// declarations 

var mraa = require('mraa'); //require mraa
console.log('MRAA Version: ' + mraa.getVersion()); //write the mraa version to the Intel XDK console

// Pins initializations
const pwmLPin = 6;
const levelSensor1Pin = 0;

// kalman variables
var varVolt    = 1.12e-5;
var varProcess = 1e-7;
var Pc = 0.0;
var G  = 0.0;
var P  = 1.0;
var Xp = 0.0;
var Zp = 0.0;
var Xe = 0.0;

//Initialize PWM
var pwmL = new mraa.Pwm(pwmLPin);
//level sensor 
var levelSensor1 = new mraa.Aio(levelSensor1Pin); //setup access analog input Analog pin #0 (A0)

//pid controller configuration
var control_A=0; //value of PWM
var set_point1 = 15;
var level1 = 0;
var PI_value = [0.1982,0.0023,0,1,3];

var levelInterval=0;
var sensorRead1 ;

//Enable PWM
pwmL.enable(true);
var TL=18000;
pwmL.period_us(TL);//set the period in microseconds.	
pwmL.write(0.241);
// PID controller
   var U=0;
   var err = 0;
   var err_prev = 0;
   var I_u = 0;
   var Ts, kp, ki, kd, Isat;
   var temp=0;

readLevel();

function pid_control (ref,param,level1)
{
// pid controller initialization
    kp =param[0] ;
    ki = param[1];
    kd = param[2];
    Ts = param[3];
    Isat = param[4];
    
var err = ref-level1;
            
    if ( ki === 0.0 ){
     I_u = 0.0;  // Set the I part to zero if Ki == 0 
    }
   else
       {
         temp  = ki*err*Ts;
       I_u = I_u +temp;
       }   
   /* Saturation of the I part */    
   if ( Isat > 0.0 )
   {
     if ( I_u >  Isat )   I_u =  Isat;
     if ( I_u < -Isat )   I_u = -Isat;
   }
   /* Add vertical PID parts: PID = P + I + D */
   U = kp*err + I_u + kd*(err-err_prev)/Ts ;

   err_prev = err;
   /* Check control limits */
   if( U > 1 ) U = 1;
   if( U < 0 ) U = 0;
    
    console.log(U);
    applyVolt(U);
}

function readLevel(){
levelInterval = setInterval(function(){
    sensorRead1 = levelSensor1.read(); //read the value of the analog pin
    
    var a= -0.0005116;
    var b= 0.6501;
    var c= -174.7;
    level1 = (a*sensorRead1*sensorRead1) + (b*sensorRead1) + c;
		
    // kalman process
    Pc = P + varProcess;
    G = Pc/(Pc+varVolt); // kalman gain
    P = (1-G)*Pc;
    Xp = Xe;
    Zp = Xp;
    Xe = G*(level1-Zp)+Xp;   // the kalman estimate of the sensor voltage
    console.log(sensorRead1);
    console.log(level1); //write the value of the level sensor to the console
    console.log(Xe); //write the value of the level KF to the console
    
    pid_control(set_point1,PI_value,Xe);
    
},1000);
}

function applyVolt(VL){
 control_A = VL;
    pwmL.write(control_A); //Write duty cycle value.	
}