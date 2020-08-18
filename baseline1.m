clear;clc

load data_environment
B = 5*10^9; %bandwidth 5 GHz
o = 0.000001; %noise -30dBm
p=1;
numslots=1000;
qCU1       = zeros(numslots,1);  % set up length of queue for user 1
qCU2       = zeros(numslots,1);   % set up length of queue for user 2
qCU3       = zeros(numslots,1);   % set up length of queue for user 3


qCU1(1)=at1(1);
qCU2(1)=at2(1);
qCU3(1)=at3(1);

for i=1:numslots-1
drnb1new(:,i)= round(B * log2(1 + (1/3*p / o)*128 * ((state1(i,1) / (1 + (43^3)))^2))*10^-3/1000);
drnb2new(:,i)= round(B * log2(1 + (1/3*p / o)*128 * ((state1(i,2) / (1 + (35^3)))^2))*10^-3/1000);
drnb3new(:,i)= round(B * log2(1 + (1/3*p / o)*128 * ((state1(i,3) / (1 + (20^3)))^2))*10^-3/1000);

qCU1(i+1)= qCU1(i) +at1(i+1)- min(qCU1(i),drnb1new(:,i));
qCU2(i+1)= qCU2(i) +at2(i+1)- min(qCU2(i),drnb2new(:,i));
qCU3(i+1)= qCU3(i) +at3(i+1)- min(qCU3(i),drnb3new(:,i));

end
averageQueueLength = mean(mean([qCU1,qCU2,qCU3]));
averagearrivalrate = mean(mean([at1,at2,at3]));
averagedelay= averageQueueLength/averagearrivalrate
