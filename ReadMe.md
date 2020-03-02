[![View PID_Node.js_Framework on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/73931-pid_node-js_framework)

# PID Node.js
This framework generates a Proportional-Integral-Derivative (PID) controller using JavaScript to run the code on Node.js Platform. 
This project can be run on any development board that support Node.js and programed with JavaScript such as Intel Galileo/Edison boards.

## Prerequisites
You need to install these software programs to insure that the project will run correctly:
* MATLAB R2011a or latest. 
* [Node.js Platform](https://nodejs.org/en/download/current/) 'latest version'. 
* If you will run the project on Intel Galileo/Edison development board, download [Intel XDK](https://drive.google.com/open?id=1MemFAQFdlOa_4mGAE-A2eo5DJW6lD6-d) with image software of Galileo board and the [Bonjour Software](https://bonjour.en.softonic.com/) for Windows users.

## Installing and Deployment
* Download the project folder.
* Open the folder with MATLAB.
* Run the script that generates the JacaScript code of the PID by writing this command and follow the instructions:
```
PID_init
```
* Enter the PID Gains (Kp, Ki and Kd).
* Enter the value of sampling time (Ts), saturation limit of the integrator (Isat) and the upper/lower boundries of the actuator.
* Set the set-point that you want to test the system on.
* Define the analog/digital pins of you will run the code on the development board.
* Determine if you need to use *Kalman Filter* with your process to reduce the noises from the sensor and set the required parameters. 
* After finishing the generated code will be found in **main.js** file.
* If you will test the code on the Galileo board using Intel XDK, copy the **main.js** file to the **PID_RealTime** foler and open the project with the intel XDK.
* Manage your pins and modified your code if you use more than one analog/digital pin. 

## Author
 **Al-Shaimaa A. Younis** - *CSE Department, Faculty of Engineering, Minia University, Egypt*
