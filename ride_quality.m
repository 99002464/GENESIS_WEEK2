%% Import data from spreadsheet
% Script for importing data from the following spreadsheet:
%
%    Worksheet: D:\Matlab\Genesis-Matlab\database\log.csv
%
%    @author : Amit Das
%    @PS no. : 99002591

%% Import the data
[acc] = xlsread('D:\MatlabProjects\Genesis-Matlab\database\log.csv','G2:I4457');
[gvt] = xlsread('D:\MatlabProjects\Genesis-Matlab\database\log.csv','D2:F4457');
[tim] = xlsread('D:\MatlabProjects\Genesis-Matlab\database\log.csv','AD2:AD4457');
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
clearvars raw acc gvt tim;

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
t_temp = ride_data.TIM;
iteration = 4455;

%% Time Normalization
for i = 1:iteration
    t(i,:) = t_temp(i+1,1) - t_temp(i,1);
end

t_real(1,1) = 0;
for i = 1:iteration
    t_real(i+1,:) = t_real(i,:) + t(i,:);
end
%Time elapsed in seconds
t_real = t_real.*0.001;

%Clear no longer required variables
clearvars t_temp;
clearvars t;

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
plot(acc_change, 'm');
xlabel('Time in secs');
ylabel('Accleration in m/s^2');
title('RATE OF CHANGE OF 3 DIMENTIONAL ACCELERATION');

%% Clear no longer required variables
clearvars acc_temp ax ay az;
clearvars axt ayt azt;

%% Gravity sensor data analysis

for i = 1:iteration
    gxt(i,:) = gx(i+1,1)-gx(i,1);
end

for i = 1:iteration
    gyt(i,:) = gy(i+1,1)-gy(i,1);
end

for i = 1:iteration
    gzt(i,:) = gz(i+1,1)-gz(i,1);
end

gvt_change = sum(gxt.^2 + gyt.^2 + gzt.^2, 2);

%Plot overall gravity changes throughout journey
subplot(3,1,2);
plot(gvt_change);
xlabel('Time');
ylabel('Gravity in m/s^2');
title('RATE OF CHANGE OF PERCIEVED GRAVITY');

%% Sensor Fusion

%Use of custom function : sensor_fusion(arg1,arg2S)
final_data = sensor_fusion(acc_change, gvt_change);
subplot(3,1,3);
plot(final_data);
xlabel('Time');
ylabel('Jerks');
title('ABRUPT MOTION ON THE ROAD');

%% Clear no longer required variables
clearvars gx gy gx;
clearvars gxt gyt gzt;

%% Accessing ride quality
jerk = 0;
smooth = 0;
threshold = 0.1;
for i = 1: iteration
    if final_data(i,:) > threshold
        jerk = jerk + 1;
    else
        smooth = smooth + 1;
    end
end

total_counter = jerk+smooth;
percent_good_ride = (smooth/total_counter)*100;
percent_bad_ride = (jerk/total_counter)*100;
percent_bad_ride = round(percent_bad_ride);
DISPLAY = sprintf('%d percent of the total ride was bad', percent_bad_ride);
disp(DISPLAY);

%% Putting together all data
for i = i:size(final_data)
    null_matrix(i,:) = 0000;
end
alldata = horzcat(data(2:end,1),data(2:end,2),data(2:end,3),data(2:end,4),data(2:end,5),data(2:end,6),data(2:end,7),null_matrix, acc_change,gvt_change,final_data);

%% Write all the data to a csv file named "ALL_DATA_LOGS"
csvwrite('ALL_DATA_LOGS.csv', alldata);

