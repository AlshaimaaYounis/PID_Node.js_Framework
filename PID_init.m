
disp('===================================================================');
disp('This framework generates JavaScript code to run on Nodejs platform');
disp('The framework generates the PID controller as a JavaScript code');
disp('===================================================================');

Kp = input('Enter the value of the Prportional Gain (Kp): ');
Ki = input('Enter the value of the Integral Gain (Ki): ');
Kd = input('Enter the value of the Derivative Gain (Kd): ');
Isat = input('Enter the value of the integrator saturation (Isat): ');
Ts = input('Enter the value of the sampling time (Ts): ');
ref = input('Enter the refernce (Set-point): ');
u_min = input('Enter the lower saturation of the actuator (u_min): ');
u_max = input('Enter the upper saturation of the actuator (u_max): ');

Y_N = input('Do you run your system on Intel Galileo Development Board?(y/n) ','s');
if Y_N == 'y'
    dpYN = input ('will you use digital pins? (y/n) ','s');
    if dpYN == 'y'
    disp('Choose the digital pins that you used');
    dp_num = input('How many digital pins will you use? (1-14)');
    if dp_num > 0 && dp_num <= 13
        pin = 1;
       while pin <= dp_num
           fprintf('Enter the pin number %d : (0-13) ', pin);
           d_pin(pin) = input('');
           pin = pin +1;
       end
    else
        disp('!!Undefined pin on the board!!');
    end
    elseif dpYN == 'n'
        disp('You did not select any digital pins!! ');
        d_pin = 6;
    else
        disp('!!Undefined input!!');
        d_pin = 6;
    end
    apYN = input ('will you use analog pins? (y/n) ','s');
    if apYN == 'y'
    disp('Choose the analog pins that you used');
    ap_num = input('How many analog pins will you use? (1-6)');
    if ap_num > 0 && ap_num <= 5
        pin = 1;
       while pin <= ap_num
           fprintf('Enter the pin number %d : (0-5) ', pin);
           a_pin(pin) = input('');
           pin = pin +1;
       end
    else
        disp('!!Undefined pin on the board!!');
    end
    elseif apYN == 'n'
        disp('You did not select any analog pins!! ');
        a_pin = 0;
    else
        disp('!!Undefined input!!');
        a_pin = 0;
    end
    kFilter = input('Do you want to use Kalamn Filter?(y/n) ','s');
    if kFilter == 'y'
        varProcess = input('Enter the value of the process variance (Q): ');
        varVolt = input('Enter the value of the variance of sensor measuerments (R): ');
    elseif kFilter == 'n'
        disp('You did not use Kalman Filter!! ');
        varProcess = 1e-7;
        varVolt    = 1.12e-5;
    else
        disp('!!Undefined input!!');
        varProcess = 1e-7;
        varVolt    = 1.12e-5;
        kFilter = 'n';
    end

elseif Y_N == 'n'
    disp('You did not select any digital or analog pins!! ');
    Y_N = 'n';
    KFilter = 'n';
    d_pin = 6;
    a_pin = 0;
    varProcess = 1e-7;
    varVolt    = 1.12e-5;
else
    disp('!!Undefined input!!');
    Y_N = 'n';
    KFilter = 'n';
    d_pin = 6;
    a_pin = 0;
    varProcess = 1e-7;
    varVolt    = 1.12e-5;
end

if Y_N == 'y' && KFilter == 'y'
    % Generating JavaScript file
    fileID = fopen('main.js','w');
    % Write comments at the top of js file
    fprintf(fileID,'%s \n','// Real-time PID controller on Galileo Board with Kalman Filter');
    fprintf(fileID,'%s \n','//=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=//');
    fprintf(fileID,'%s \n','// Initializing of PID ');

    % PID parameters
    fprintf(fileID,'%s %d %s\n','var Kp =',Kp, ';');
    fprintf(fileID,'%s %d %s\n','var Ki =',Ki, ';');
    fprintf(fileID,'%s %d %s\n','var Kd =',Kd, ';');
    fprintf(fileID,'%s %d %s\n','var Ts =',Ts, ';');
    fprintf(fileID,'%s %d %s\n','var Isat =',Isat, ';');
    fprintf(fileID,'%s %d %s\n','var u_min =',u_min, ';');
    fprintf(fileID,'%s %d %s\n','var u_max =',u_max, ';');
    fprintf(fileID,'%s %d %s\n','var ref =',ref, ';');

    for i = 1:length(d_pin)
        fprintf(fileID,'%s%d %s %d %s\n','var pwmPin',i,'=',d_pin(i), ';');
    end
    for i = 1:length(a_pin)
        fprintf(fileID,'%s%d %s %d %s\n','var SensorPin',i,'=',a_pin(i), ';');
    end

    fprintf(fileID,'%s %d %s\n','var varProcess =',varProcess, ';');
    fprintf(fileID,'%s %d %s\n','var varVolt =',varVolt, ';');
    fclose(fileID);

    % append the mpc_init file with the main file
    fr = fopen( 'pid_galileo_filter.js', 'rt' );
    fw = fopen( 'main.js', 'at' );
    while feof( fr ) == 0
        tline = fgetl( fr );
        fwrite( fw, sprintf('%s\n',tline ) );
    end
    fclose(fr);
    fclose(fw);
elseif Y_N == 'n' && KFilter == 'n'
    % Generating JavaScript file
    fileID = fopen('main.js','w');
    % Write comments at the top of js file
    fprintf(fileID,'%s \n','// Real-time PID controller');
    fprintf(fileID,'%s \n','//=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=//');
    fprintf(fileID,'%s \n','// Initializing of PID ');

    % PID parameters
    fprintf(fileID,'%s %d %s\n','var Kp =',Kp, ';');
    fprintf(fileID,'%s %d %s\n','var Ki =',Ki, ';');
    fprintf(fileID,'%s %d %s\n','var Kd =',Kd, ';');
    fprintf(fileID,'%s %d %s\n','var Ts =',Ts, ';');
    fprintf(fileID,'%s %d %s\n','var Isat =',Isat, ';');
    fprintf(fileID,'%s %d %s\n','var u_min =',u_min, ';');
    fprintf(fileID,'%s %d %s\n','var u_max =',u_max, ';');
    fprintf(fileID,'%s %d %s\n','var ref =',ref, ';');

    fclose(fileID);

    % append the mpc_init file with the main file
    fr = fopen( 'pid.js', 'rt' );
    fw = fopen( 'main.js', 'at' );
    while feof( fr ) == 0
        tline = fgetl( fr );
        fwrite( fw, sprintf('%s\n',tline ) );
    end
    fclose(fr);
    fclose(fw);
elseif Y_N == 'y'  
    % Generating JavaScript file
    fileID = fopen('main.js','w');
    % Write comments at the top of js file
    fprintf(fileID,'%s \n','// Real-time PID controller on Galileo');
    fprintf(fileID,'%s \n','//=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=//');
    fprintf(fileID,'%s \n','// Initializing of PID ');

    % PID parameters
    fprintf(fileID,'%s %d %s\n','var Kp =',Kp, ';');
    fprintf(fileID,'%s %d %s\n','var Ki =',Ki, ';');
    fprintf(fileID,'%s %d %s\n','var Kd =',Kd, ';');
    fprintf(fileID,'%s %d %s\n','var Ts =',Ts, ';');
    fprintf(fileID,'%s %d %s\n','var Isat =',Isat, ';');
    fprintf(fileID,'%s %d %s\n','var u_min =',u_min, ';');
    fprintf(fileID,'%s %d %s\n','var u_max =',u_max, ';');
    fprintf(fileID,'%s %d %s\n','var ref =',ref, ';');

    for i = 1:length(d_pin)
        fprintf(fileID,'%s%d %s %d %s\n','var pwmPin',i,'=',d_pin(i), ';');
    end
    for i = 1:length(a_pin)
        fprintf(fileID,'%s%d %s %d %s\n','var SensorPin',i,'=',a_pin(i), ';');
    end

    fclose(fileID);

    % append the mpc_init file with the main file
    fr = fopen( 'pid_galileo.js', 'rt' );
    fw = fopen( 'main.js', 'at' );
    while feof( fr ) == 0
        tline = fgetl( fr );
        fwrite( fw, sprintf('%s\n',tline ) );
    end
    fclose(fr);
    fclose(fw);
else
    % Generating JavaScript file
    fileID = fopen('main.js','w');
    % Write comments at the top of js file
    fprintf(fileID,'%s \n','// Real-time PID controller on Galileo with Kalman Filter');
    fprintf(fileID,'%s \n','//=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=//');
    fprintf(fileID,'%s \n','// Initializing of PID ');

    % PID parameters
    fprintf(fileID,'%s %d %s\n','var Kp =',Kp, ';');
    fprintf(fileID,'%s %d %s\n','var Ki =',Ki, ';');
    fprintf(fileID,'%s %d %s\n','var Kd =',Kd, ';');
    fprintf(fileID,'%s %d %s\n','var Ts =',Ts, ';');
    fprintf(fileID,'%s %d %s\n','var Isat =',Isat, ';');
    fprintf(fileID,'%s %d %s\n','var u_min =',u_min, ';');
    fprintf(fileID,'%s %d %s\n','var u_max =',u_max, ';');
    fprintf(fileID,'%s %d %s\n','var ref =',ref, ';');

    for i = 1:length(d_pin)
        fprintf(fileID,'%s%d %s %d %s\n','var pwmPin',i,'=',d_pin(i), ';');
    end
    for i = 1:length(a_pin)
        fprintf(fileID,'%s%d %s %d %s\n','var SensorPin',i,'=',a_pin(i), ';');
    end

    fprintf(fileID,'%s %d %s\n','var varProcess =',varProcess, ';');
    fprintf(fileID,'%s %d %s\n','var varVolt =',varVolt, ';');
    fclose(fileID);

    % append the mpc_init file with the main file
    fr = fopen( 'pid_galileo_filter.js', 'rt' );
    fw = fopen( 'main.js', 'at' );
    while feof( fr ) == 0
        tline = fgetl( fr );
        fwrite( fw, sprintf('%s\n',tline ) );
    end
    fclose(fr);
    fclose(fw);
end