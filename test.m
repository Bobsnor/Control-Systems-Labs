%% test script for the Lab Assignment 1/Control Systems Course
% author: V. Spinu v.spinu@tue.nl
%
% Version 2.0
% - 2016 API is used to facilitate multiple connections to a single setup
% Veriosn 1.0
% - first release 
% close all
% clear all
if exist('myobj','var')
    myobj.CloseConnection;
    delete(myobj)
    clear('myoj')
end
myobj = HW_LabAssignment1; % instantiate the object

myobj.ipaddress = '172.22.11.2'; % IP address of the system, for USB 

myobj.ipaddress = '172.16.0.1'; % should be '172.16.0.1' for WiFi

myobj.ipaddress = '131.155.127.198'; % should be '131.155.127.198' for the
%Internet connectio, one of the setups may be available via Internet
%outside the LAB hours.

    
% configure the transfer functions of the control system
% myobj.D = tf(0.001,1);
% myobj.P = tf(1,[0.5,1]);
% myobj.F = tf(0,1);
% myobj.H = tf(1,1); % if the system becomes unstable with these settings 
                   % change de sign of the H transfer fucntion

myobj.D = D;
myobj.P = P;
myobj.F = 0;
myobj.H = H;
                   
% low level data manipulation functions
if 0 % replace 0 with 1 to run this part
    time = 0:0.002:10; %time base for the reference and disturbance signals
    myobj.disturbance = 0.1*sin(2*pi*3*time); % setting up the disturbance signal
    myobj.disturbance(1)=0; % ensuring 0 as the idle disturbance value
    myobj.reference = 0*time+200; %setting up the reference signal
    myobj.reference(1)=0; % ensuring 0 as the idle reference value
    
    myobj.createConnection;     % establishing a connection 
    myobj.uploadSettings;       % upload settings to MyRIO
    myobj.uploadDisturbance;    % upload the disturbance profile
    myobj.uploadReference;      % upload the reference profile
    
    myobj.StartExperiment;
    myobj.get_all_back;         % get all measuremed waveforms
    
    myobj.CloseConnection;
    
    % plot the received data
    figure(1)
    subplot(3,1,1:2)
    plot(time,myobj.reference,time,myobj.measured_out,time,myobj.prefilter_out);
    legend('ref','y','Pout')
    subplot(3,1,3)
    plot(time,myobj.disturbance,time,myobj.controller_out,time,myobj.ff_out,...
        time,myobj.combined_out);
    legend('dist','Dout','Fout','i')
    xlabel('time (s)')
end

% Verify the disturbance rejection at 1 Hz (Test 1)
fprintf(' \n\n running test 1' )
myobj.T1;
time = (0:length(myobj.reference)-1)*0.002; % all test scenarios are 10s 
                                % long and sampled at the interval of 2ms
figure(2)
clf
subplot(3,1,1:2)
plot(time,myobj.reference,time,myobj.measured_out,time,myobj.prefilter_out);
legend('ref','y','Pout')
subplot(3,1,3)
plot(time,myobj.disturbance,time,myobj.controller_out,time,myobj.ff_out,...
    time,myobj.combined_out);
legend('dist','Dout','Fout','i')
xlabel('time (s)')
%% Verify the offset free tracking (Test 2)
fprintf(' \n\n running test 2' )
myobj.T2;
figure(3)
clf
subplot(3,1,1:2)
plot(time,myobj.reference,time,myobj.measured_out,time,myobj.prefilter_out);
legend('ref','y','Pout')
subplot(3,1,3)
plot(time,myobj.disturbance,time,myobj.controller_out,time,myobj.ff_out,...
    time,myobj.combined_out);
legend('dist','Dout','Fout','i')
xlabel('time (s)')
%% Verify that the overshoot is less than 5% (Test 3)
fprintf(' \n\n running test 3' )
myobj.T3;
figure(4)
clf
subplot(3,1,1:2)
plot(time,myobj.reference,time,myobj.measured_out,time,myobj.prefilter_out);
legend('ref','y','Pout')
subplot(3,1,3)
plot(time,myobj.disturbance,time,myobj.controller_out,time,myobj.ff_out,...
    time,myobj.combined_out);
legend('dist','Dout','Fout','i')
xlabel('time (s)');
%% delete the object to free the memory
myobj.CloseConnection;
delete(myobj);
clear('myobj')