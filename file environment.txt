clc
clear
numbs     = 3;        
p     = [0.25, 0.65, 0.1;
          0.2, 0.75 ,0.05;
          0.3 ,0.6 ,0.1];
numslots    = 1e3;                      % timeslots=1000ms
                      
state1      = zeros(numslots,numbs);
arrivalrate1 = 10 ;%lambda
arrivalrate2 = 30;
arrivalrate3 = 60;

state1(1,:) = randsrc(1,1,[0.1 1 0.000001;0.2 0.7 0.1]); % initial channel state r1 r2 r3



for i=1:numslots
    for n = 1:numbs
        if state1(1,:) == 1;
        state1(i+1,n) = randsrc(1,1,[0.1 1 0.000001;0.25 0.65 0.1]);
        elseif state1(1,:) == 0.1
        state1(i+1,n) = randsrc(1,1,[0.1 1 0.000001;0.2 0.75 0.05]);
        else
        state1(i+1,n) = randsrc(1,1,[0.1 1 0.000001;0.3 0.6 0.1]);    
        end 
     
 
    end
   at1(i) = poissrnd(arrivalrate1);    % num of packet arrivals
   at2(i) = poissrnd(arrivalrate2);    % num of packet arrivals
   at3(i) = poissrnd(arrivalrate3);    % num of packet arrivals
    while (at1(i) < 0)
       at1(i) = poissrnd(arrivalrate1);
    end
    while (at2(i) < 0)
       at2(i) = poissrnd(arrivalrate2);
    end
    while (at3(i) < 0)
       at3(i) = poissrnd(arrivalrate3);
    end
end


save data_environment state1 at1 at2 at3
