%% Import data from spreadsheet
% Script for importing data from the following spreadsheet:
%
%    Workbook: D:\Matlab\Genesis-Matlab\database\log.csv
%
% To extend the code for use with different selected data or a different
% spreadsheet, generate a function instead of a script.

%% Import the data
[acc] = xlsread('D:\Matlab\Genesis-Matlab\database\log.csv','G2:I100');
[gvt] = xlsread('D:\Matlab\Genesis-Matlab\database\log.csv','D2:F100');
[tim] = xlsread('D:\Matlab\Genesis-Matlab\database\log.csv','AD2:AD100');
raw = [acc,gvt,tim];

%% Create output variable
data = raw;

%% Create table
ride_data = table;

%% Allocate imported array to column variable names
ride_data.ACCNx = data(:,1);
ride_data.ACCNy = data(:,2);
ride_data.ACCNz = data(:,3);
ride_data.GVTx = data(:,4);
ride_data.GVTy = data(:,5);
ride_data.GVTz = data(:,6);
ride_data.TIM = data(:,7);

%% Clear temporary variables
clearvars data raw acc gvt tim;

%% Assign independent variables for all the sensors
%Linear Acceleration on all three axes
ax = ride_data.ACCNx;
ay = ride_data.ACCNy;
az = ride_data.ACCNz;
%Gravity changes on all three axes
gx = ride_data.GVTx;
gy = ride_data.GVTy;
gz = ride_data.GVTz;
%Time 
t = ride_data.TIM;
iteration = 98;
%% Linear acceleration data analysis
%Change in acceleration every 0.1s on each axis
for i = 1:iteration
    axt(i,:) = ax(i+1,1)-ax(i,1);
end

for i = 1:iteration
    ayt(i,:) = ay(i+1,1)-ay(i,1);
end

for i = 1:iteration
    azt(i,:) = az(i+1,1)-az(i,1);
end

%Combining the acceleration change over all axis
acc_temp = sum(axt.^2 + ayt.^2 + azt.^2, 2);
acc_change = sqrt(acc_temp);

%Plot overall acceleration changes throughout journey
subplot(3,1,1);
plot(acc_change);
xlabel('Time in secs');
ylabel('Accleration in m/s^2');
title('RATE OF CHANGE OF 3 DIMENTIONAL ACCELERATION');

clearvars acc_temp ax ay az;
clearvars axt ayt azt;