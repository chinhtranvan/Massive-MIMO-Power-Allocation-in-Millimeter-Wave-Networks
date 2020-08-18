
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

v=0:0.1:1;
c = permn(v,3);
result=c(sum(c,2)==1,:);
for i=1:numslots-1

A(:,i)=[qCU1(i) qCU2(i) qCU3(i)];
[maxvalue(i), maxidx(i)] = max(A(:,i));
drnb1(:,i)= round(B * log2(1 + (result(:,1)*p / o)*128 * ((state1(i,1) / (1 + (43^3)))^2))*10^-3/1000);
drnb2(:,i)= round(B * log2(1 + (result(:,2)*p / o)*128 * ((state1(i,2) / (1 + (35^3)))^2))*10^-3/1000);
drnb3(:,i)= round(B * log2(1 + (result(:,3)*p / o)*128 * ((state1(i,3) / (1 + (20^3)))^2))*10^-3/1000);    
if maxidx(i) ==3

  if max(drnb3(:,i))<=qCU3(i)
r1(i)=0;   
r2(i)=0;
r3(i)=1;
  else
    [row,col]= find(drnb3(:,i)>qCU3(i));
     r3(i)=min(result(row,3));
      rnew=0:0.1:1-r3(i); 
       if qCU1(i) <= qCU2(i)
          
           drnbx2=round(B * log2(1 + (rnew*p / o)*128 * ((state1(i,2) / (1 + (35^3)))^2))*10^-3/1000)';
           if max(drnbx2)<=qCU2(i)
                r2(i)=1-r3(i);
                r1(i)=0;
           else
                [row1,col1]= find(drnbx2>qCU2(i));
                r2(i)=min(rnew(1,row1)');
                r1(i)=1-r3(i)-r2(i);
           end
       else
           drnbx1=round(B * log2(1 + (rnew*p / o)*128 * ((state1(i,1) / (1 + (43^3)))^2))*10^-3/1000)';
           if max(drnbx1)<=qCU1(i)
                r1(i)=1-r3(i);
                r2(i)=0;
           else
               [row1,col1]= find(drnbx1>qCU1(i));
                r1(i)=min(rnew(1,row1)');
                r2(i)=1-r3(i)-r1(i);
           end    
       end    
  end 
elseif maxidx(i) ==2
    if max(drnb2(:,i))<=qCU2(i)
r1(i)=0;   
r2(i)=1;
r3(i)=0;
 else
    [row,col]= find(drnb2(:,i)>qCU2(i));
     r2(i)=min(result(row,2));
     rnew=0:0.1:1-r2(i);
      if qCU1(i) <= qCU3(i)       
           drnbx3=round(B * log2(1 + (rnew*p / o)*128 * ((state1(i,3) / (1 + (20^3)))^2))*10^-3/1000)';
           if max(drnbx3)<=qCU3(i)
                r3(i)=1-r2(i);
                r1(i)=0;
           else
                [row1,col1]= find(drnbx3>qCU3(i));
                r3(i)=min(rnew(1,row1)');
                r1(i)=1-r3(i)-r2(i);
           end
       else
           drnbx1=round(B * log2(1 + (rnew*p / o)*128 * ((state1(i,1) / (1 + (43^3)))^2))*10^-3/1000)';
           if max(drnbx1)<=qCU1(i)
                r1(i)=1-r2(i);
                r3(i)=0;
           else
                [row1,col1]= find(drnbx1>qCU1(i));
                r1(i)=min(rnew(1,row1)');
                r3(i)=1-r2(i)-r1(i);
           end    
       end    
  end     
else    
     if max(drnb1(:,i))<=qCU1(i)
r1(i)=1;   
r2(i)=0;
r3(i)=0;
    else
    [row,col]= find(drnb1(:,i)>qCU1(i));
     r1(i)=min(result(row,1));
     rnew=0:0.1:1-r1(i);
      if qCU2(i) <= qCU3(i)       
           drnbx3=round(B * log2(1 + (rnew*p / o)*128 * ((state1(i,3) / (1 + (20^3)))^2))*10^-3/1000)';
           if max(drnbx3)<=qCU3(i)
                r3(i)=1-r1(i);
                r2(i)=0;
           else
                [row1,col1]= find(drnbx3>qCU3(i));
                r3(i)=min(rnew(1,row1)');
                r2(i)=1-r3(i)-r1(i);
           end
       else
           drnbx2=round(B * log2(1 + (rnew*p / o)*128 * ((state1(i,2) / (1 + (35^3)))^2))*10^-3/1000)';
           if max(drnbx2)<=qCU2(i)
                r2(i)=1-r1(i);
                r3(i)=0;
           else
                [row1,col1]= find(drnbx2>qCU2(i));
                r2(i)=min(rnew(1,row1)');
                r3(i)=1-r2(i)-r1(i);
           end    
       end    
  end 
end
drnb11(:,i)= round(B * log2(1 + (r1(i)*p / o)*128 * ((state1(i,1) / (1 + (43^3)))^2))*10^-3/1000);
drnb22(:,i)= round(B * log2(1 + (r2(i)*p / o)*128 * ((state1(i,2) / (1 + (35^3)))^2))*10^-3/1000);
drnb33(:,i)= round(B * log2(1 + (r3(i)*p / o)*128 * ((state1(i,3) / (1 + (20^3)))^2))*10^-3/1000);
qCU1(i+1)= qCU1(i) +at1(i+1)- min(qCU1(i),drnb11(:,i));
qCU2(i+1)= qCU2(i) +at2(i+1)- min(qCU2(i),drnb22(:,i));
qCU3(i+1)= qCU3(i) +at3(i+1)- min(qCU3(i),drnb33(:,i));
end
averageQueueLength = mean(mean([qCU1,qCU2,qCU3]));
averagearrivalrate = mean(mean([at1,at2,at3]));
averagedelay= averageQueueLength/averagearrivalrate
