
//pid controller configuration
var PID_value = [Kp,Ki,Kd,Ts,Isat];
var SRead1 = 0 ; // current state of the output

// PID controller
   var U=0;
   var err = 0;
   var err_prev = 0;
   var I_u = 0;
   var ts, kp, ki, kd, Is;
   var temp=0;

pid_control(ref,PID_value,SRead1);

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
}