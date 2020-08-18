clear;clc
load data_environment
B = 5*10^9; %bandwidth 5 GHz
o = 0.000001; %noise -30dBm
p=1/128;
numslots=1000;
qCU1       = zeros(numslots,1);  % set up length of queue for user 1
qCU2       = zeros(numslots,1);   % set up length of queue for user 2
qCU3       = zeros(numslots,1);   % set up length of queue for user 3

qCU1(1)=10*1;
qCU2(1)=30*1;
qCU3(1)=60*1;
vPostCU1  =rand(500000,1);
vPostCU2  =rand(500000,1);
vPostCU3  =rand(500000,1);
alpha   = 0.6; 
v=0:0.1:1;
c = permn(v,3);
result=c(sum(c,2)==1,:);
r1=result(:,1)';
r2=result(:,2)';
r3=result(:,3)';
drnb1(:,1)= round(B * log2(1 + (r1*p / o)*128 * ((state1(1,1) / (1 + (35^3)))^2))*10^-3/1000);
drnb2(:,1)= round(B * log2(1 + (r2*p / o)*128 * ((state1(1,2) / (1 + (25^3)))^2))*10^-3/1000);
drnb3(:,1)= round(B * log2(1 + (r3*p / o)*128 * ((state1(1,3) / (1 + (23^3)))^2))*10^-3/1000);
qPostCU1(:,1)   = qCU1(1)-min(qCU1(1),drnb1(:,1)); 
wTmp1(:,1)  = vPostCU1(qPostCU1(:,1)) - vPostCU1(qCU1(1));
qPostCU2(:,1)       = qCU2(1)-min(qCU2(1),drnb2(:,1)); 
wTmp2(:,1)  = vPostCU2(qPostCU2(:,1)) - vPostCU2(qCU2(1));
qPostCU3(:,1)       = qCU3(1)-min(qCU3(1),drnb3(:,1));  
wTmp3(:,1)  = vPostCU3(qPostCU3(:,1)) - vPostCU3(qCU3(1));
A(:,1)=wTmp1(:,1)+wTmp2(:,1)+wTmp3(:,1);
[minvalue(1), minidx(1)] = min(A(:,1));
r1currentopt=r1(minidx(1));
r2currentopt=r2(minidx(1));
r3currentopt=r3(minidx(1));
drnb1currentopt=round(B * log2(1 + (r1currentopt*p / o)*128 * ((state1(1,1) / (1 + (35^3)))^2))*10^-3/1000);
drnb2currentopt=round(B * log2(1 + (r2currentopt*p / o)*128 * ((state1(1,2) / (1 + (25^3)))^2))*10^-3/1000);
drnb3currentopt=round(B * log2(1 + (r3currentopt*p / o)*128 * ((state1(1,3) / (1 + (23^3)))^2))*10^-3/1000);

 qPostCU1Current(:,1)  = qCU1(1)-drnb1currentopt;
 qPostCU2Current(:,1)  = qCU2(1)-drnb2currentopt;
 qPostCU3Current(:,1)  = qCU3(1)-drnb3currentopt;
 % network state update
 qCU1(2,:) = qPostCU1Current(:,1)+at1(2); 
 qCU2(2,:) = qPostCU2Current(:,1)+at2(2); 
 qCU3(2,:) = qPostCU3Current(:,1)+at3(2); 

drnb1(:,2)=round(B * log2(1 + (r1*p / o)*128 * ((state1(2,1) / (1 + (35^3)))^2))*10^-3/1000);
drnb2(:,2)= round(B * log2(1 + (r2*p / o)*128 * ((state1(2,2) / (1 + (25^3)))^2))*10^-3/1000);
drnb3(:,2)= round(B * log2(1 + (r3*p / o)*128 * ((state1(2,3) / (1 + (23^3)))^2))*10^-3/1000);
qPostCU1(:,2)  = qCU1(2)-min(qCU1(2),drnb1(:,2));   
wTmp1(:,2)  = vPostCU1(qPostCU1(:,2)) - vPostCU1(qCU1(2));
qPostCU2(:,2)  =qCU2(2)-min(qCU2(2),drnb2(:,2)); 
wTmp2(:,2)  = vPostCU2(qPostCU2(:,2)) - vPostCU2(qCU2(2));
qPostCU3(:,2)       = qCU3(2)-min(qCU3(2),drnb3(:,2)); 
wTmp3(:,2)  = vPostCU3(qPostCU3(:,2)) - vPostCU3(qCU3(2));
A(:,2)=wTmp1(:,2)+wTmp2(:,2)+wTmp3(:,2);
[minvalue(2), minidx(2)] = min(A(:,2));
r1nextopt(1)=r1(minidx(2));
r2nextopt(1)=r2(minidx(2));
r3nextopt(1)=r3(minidx(2));
drnb1nextopt(:,1)=round(B * log2(1 + (r1nextopt(1)*p / o)*128 * ((state1(2,1) / (1 + (35^3)))^2))*10^-3/1000);
drnb2nextopt(:,1)=round(B * log2(1 + (r2nextopt(1)*p / o)*128 * ((state1(2,2) / (1 + (25^3)))^2))*10^-3/1000);
drnb3nextopt(:,1)=round(B * log2(1 + (r3nextopt(1)*p / o)*128 * ((state1(2,3) / (1 + (23^3)))^2))*10^-3/1000);
% post-decision state determination at next time slot
qPostCU1next(:,1)= qCU1(2)-drnb1nextopt(:,1);
qPostCU2next(:,1)= qCU2(2)-drnb2nextopt(:,1);
qPostCU3next(:,1)= qCU3(2)-drnb3nextopt(:,1);
vPostCU1(qPostCU1Current(:,1)) = (1-alpha)*vPostCU1(qPostCU1Current(:,1)) +...
 alpha*(qCU1(2)+vPostCU1(qPostCU1next(:,1))-vPostCU1(4)); 
vPostCU2(qPostCU2Current(:,1)) = (1-alpha)*vPostCU2(qPostCU2Current(:,1)) +...
 alpha*(qCU2(2)+vPostCU2(qPostCU2next(:,1))-vPostCU2(4)); 
vPostCU3(qPostCU3Current(:,1)) = (1-alpha)*vPostCU3(qPostCU3Current(:,1)) +...
 alpha*(qCU3(2)+vPostCU3(qPostCU3next(:,1))-vPostCU3(4)); 
for i=1:numslots-2

qPostCU1Current(:,i+1)=qPostCU1next(:,i);
qPostCU2Current(:,i+1)=qPostCU2next(:,i);
qPostCU3Current(:,i+1)=qPostCU3next(:,i);
qCU1(i+2,:)= qPostCU1Current(:,i+1)+at1(i+2);
qCU2(i+2,:)= qPostCU2Current(:,i+1)+at2(i+2);
qCU3(i+2,:)= qPostCU3Current(:,i+1)+at3(i+2);
drnb1(:,i+2)=round(B * log2(1 + (r1*p / o)*128 * ((state1(i,1) / (1 + (35^3)))^2))*10^-3/1000);
drnb2(:,i+2)=round(B * log2(1 + (r2*p / o)*128 * ((state1(i,2) / (1 + (25^3)))^2))*10^-3/1000);
drnb3(:,i+2)=round(B * log2(1 + (r3*p / o)*128 * ((state1(i,3) / (1 + (23^3)))^2))*10^-3/1000);
qPostCU1(:,i+2)  = qCU1(i+2)-min(qCU1(i+2),drnb1(:,i+2));    
wTmp1(:,i+2)  = vPostCU1(qPostCU1(:,i+2)) - vPostCU1(qCU1(i+2));
qPostCU2(:,i+2)       = qCU2(i+2)-min( qCU2(i+2),drnb2(:,i+2));
wTmp2(:,i+2)  = vPostCU2(qPostCU2(:,i+2)) - vPostCU2(qCU2(i+2));
qPostCU3(:,i+2)       = qCU3(i+2)-min(qCU3(i+2),drnb3(:,i+2)); 
wTmp3(:,i+2)  = vPostCU3(qPostCU3(:,i+2)) - vPostCU3(qCU3(i+2));
A(:,i+2)=wTmp1(:,i+2)+wTmp2(:,i+2)+wTmp3(:,i+2);
[minvalue(i+2), minidx(i+2)] = min(A(:,i+2));
r1nextopt(i+1)=r1(minidx(i+2));
r2nextopt(i+1)=r2(minidx(i+2));
r3nextopt(i+1)=r3(minidx(i+2));
drnb1nextopt(:,i+1)=round(B * log2(1 + (r1nextopt(i+1)*p / o)*128 * ((state1(i,1) / (1 + (35^3)))^2))*10^-3/1000);
drnb2nextopt(:,i+1)=round(B * log2(1 + (r2nextopt(i+1)*p / o)*128 * ((state1(i,2) / (1 + (25^3)))^2))*10^-3/1000);
drnb3nextopt(:,i+1)=round(B * log2(1 + (r3nextopt(i+1)*p / o)*128 * ((state1(i,3) / (1 + (23^3)))^2))*10^-3/1000);
qPostCU1next(:,i+1)= qCU1(i+2)-drnb1nextopt(:,i+1);
qPostCU2next(:,i+1)= qCU2(i+2)-drnb2nextopt(:,i+1);
qPostCU3next(:,i+1)= qCU3(i+2)-drnb3nextopt(:,i+1);
vPostCU1(qPostCU1Current(:,i+1)) = (1-alpha)*vPostCU1(qPostCU1Current(:,i+1)) +...
 alpha*(qCU1(i+1)+vPostCU1(qPostCU1next(:,i+1))-vPostCU1(4)); 
vPostCU2(qPostCU2Current(:,i+1)) = (1-alpha)*vPostCU2(qPostCU2Current(:,i+1)) +...
 alpha*(qCU2(i+1)+vPostCU2(qPostCU2next(:,i+1))-vPostCU2(4)); 
vPostCU3(qPostCU3Current(:,i+1)) = (1-alpha)*vPostCU3(qPostCU3Current(:,i+1)) +...
 alpha*(qCU3(i+1)+vPostCU3(qPostCU3next(:,i+1))-vPostCU3(4));

end
averageQueueLength = mean(mean([qCU1,qCU2,qCU3]));
averagearrivalrate = mean(mean([at1,at2,at3]));
averagedelay= averageQueueLength/averagearrivalrate
