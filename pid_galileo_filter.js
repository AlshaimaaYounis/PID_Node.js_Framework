
var mraa = require('mraa'); //require mraa
console.log('MRAA Version: ' + mraa.getVersion()); //write the mraa version to the Intel XDK console

// kalman variables
var Pc = 0.0;
var G  = 0.0;
var P  = 1.0;
var Xp = 0.0;
var Zp = 0.0;
var Xe = 0.0;

//Initialize PWM
var pwmL = new mraa.Pwm(pwmPin1);
//Enable PWM
pwmL.enable(true);
var TL=18000;
pwmL.period_us(TL);//set the period in microseconds.	
pwmL.write(0);

//analog sensor 
var Sensor1 = new mraa.Aio(SensorPin1); //setup access analog input Analog pin #0 (A0)

//pid controller configuration
var control_A=0; //value of PWM
var SRead1 = 0;
var PID_value = [Kp,Ki,Kd,Ts,Isat];
var sensorRead1 ;

// PID controller
   var U=0;
   var err = 0;
   var err_prev = 0;
   var I_u = 0;
   var ts, kp, ki, kd, Is;
   var temp=0;

readSensor();

function pid_control (ref,param,SRead1)
{
// pid controller initialization
    kp =param[0] ;
    ki = param[1];
    kd = param[2];
    ts = param[3];
    Is = param[4];
    
var err = ref-SRead1;
            
    if ( ki === 0.0 ){
     I_u = 0.0;  // Set the I part to zero if Ki == 0 
    }
   else
       {
         temp  = ki*err*ts;
       I_u = I_u +temp;
       }   
   /* Saturation of the I part */    
   if ( Is > 0.0 )
   {
     if ( I_u >  Is )   I_u =  Is;
     if ( I_u < -Is )   I_u = -Is;
   }
   /* Add vertical PID parts: PID = P + I + D */
   U = kp*err + I_u + kd*(err-err_prev)/ts ;

   err_prev = err;
   /* Check control limits */
   if( U > u_max ) U = u_max;
   if( U < u_min ) U = u_min;
    
    console.log(U);
    applyVolt(U);
}

function readSensor(){
 setInterval(function(){
    sensorRead1 = Sensor1.read(); //read the value of the analog pin
    
    var a= -0.0005116;
    var b= 0.6501;
    var c= -174.7;
    SRead1 = (a*sensorRead1*sensorRead1) + (b*sensorRead1) + c;
		
    // kalman process
    Pc = P + varProcess;
    G = Pc/(Pc+varVolt); // kalman gain
    P = (1-G)*Pc;
    Xp = Xe;
    Zp = Xp;
    Xe = G*(SRead1-Zp)+Xp;   // the kalman estimate of the sensor voltage
    console.log(sensorRead1);
    console.log(SRead1); //write the value of the sensor to the console
    console.log(Xe); //write the value of the KF to the console
    
    pid_control(ref,PID_value,Xe);
},1000);
}

function applyVolt(VL){
 control_A = VL;
    pwmL.write(control_A); //Write duty cycle value.	
}