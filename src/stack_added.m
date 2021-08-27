global Zipf_parameter
Zipf_parameter = 10;
global moving_ave_plot;
moving_ave_plot = zeros(1,10);
global moving_ave_potential_plot;
moving_ave_potential_plot = zeros(1,20);
global moving_ave_potential_plot2; %for new potential game
moving_ave_potential_plot2 = zeros(1,20);
global zipf_num1;
zipf_num1 = zeros(1,10);
global zipf_num2;
zipf_num2= zeros(1,10);
global user_number;
user_number = 20; 
global best_response_plot2;
global traffic;

TBH_No_jam_based_on_sbs = zeros(1,1,5);
TBH_No_jam_based_on_zipf = zeros(1,10);
TBH_based_on_zipf = zeros(1,Zipf_parameter,4);
TBH_based_on_sbs = zeros(1,1,5);
temp1 = zeros(1,1,5);
temp2 = zeros(1,1,5);
temp3 = zeros(1,1,5);
temp4 = zeros(1,1,5);

Delay_based_on_zipf = zeros(1,10,4);
Delay_based_on_sbs = zeros(1,1,5);
DelayOutput1 = zeros(1,1,5);
DelayOutput2 = zeros(1,1,5);
DelayOutput3 = zeros(1,1,5);
DelayOutput4= zeros(1,1,5);
DelayOutNoJammer = zeros(1,20,5);

sbs = [5,7,10,13,16];
jammer = [1,2,4,6];
%jam = 1;
%sn = 3 ;
for jam = 1:4
    Delay_based_on_sbs = zeros(1,20,5);
     for sn = 1:5
        initial_network(jammer(jam),sbs(sn));
        initial_gain_Backhual(jammer(jam),sbs(sn));
        random_array();
        DelayOutNoJammer(1,:,sn) = potential_game(jammer(jam),sbs(sn));
        [TBH_No_jam_based_on_zipf,TBH_No_jam_based_on_sbs(1,:,sn),TBH_based_on_zipf(1,:,jam),TBH_based_on_sbs(1,:,sn)] = stackelberg_game(jammer(jam),sbs(sn));
        [Delay_based_on_zipf(1,:,jam),Delay_based_on_sbs(1,:,sn)] = new_potential_game(jammer(jam),sbs(sn));
        if jam == 1
            %disp(sn);
            %disp(Delay_based_on_sbs(1,20,sn));
            %disp(TBH_based_on_sbs(1,1,sn));
            DelayOutput1(1,1,sn)=Delay_based_on_sbs(1,20,sn);
            temp1(1,1,sn)=TBH_based_on_sbs(1,1,sn);
            disp('this is jam 1');
        elseif jam == 2
            %disp(sn);
            %disp(Delay_based_on_sbs(1,20,sn));
            %disp(TBH_based_on_sbs(1,1,sn));
            DelayOutput2(1,1,sn)=Delay_based_on_sbs(1,20,sn);
            temp2(1,1,sn)=TBH_based_on_sbs(1,1,sn);
            disp('this is jam 2');
        elseif  jam == 3
            %disp(sn);
            %disp(Delay_based_on_sbs(1,20,sn));
            %disp(TBH_based_on_sbs(1,1,sn));
            DelayOutput3(1,1,sn)=Delay_based_on_sbs(1,20,sn);
            temp3(1,1,sn)=TBH_based_on_sbs(1,1,sn);
            disp('this is jam 4');
        elseif jam == 4
            %disp(sn);
            %disp(Delay_based_on_sbs(1,20,sn));
            %disp(TBH_based_on_sbs(1,1,sn));
            DelayOutput4(1,1,sn)=Delay_based_on_sbs(1,20,sn);
            temp4(1,1,sn)=TBH_based_on_sbs(1,1,sn);
            disp('this is jam 6');
        end 
      end
 end

plot_new_potential(best_response_plot2);
Average_Delay(moving_ave_potential_plot); 
congestion(traffic(1,1,:));
Average_Delay_Based_On_Zipf(Delay_based_on_zipf,zipf_num1);
Average_Delay_Based_On_SBS(DelayOutput1,DelayOutput2,DelayOutput3,DelayOutput4,DelayOutNoJammer(1,20,:));
TBH_Zipf(TBH_No_jam_based_on_zipf,TBH_based_on_zipf);
TBH_SBS(TBH_No_jam_based_on_sbs(1,1,:),temp1,temp2,temp3,temp4);

Aeq = zeros(10,50);
counter = 0;
for i = 1:10
    for j =5*counter +1 :5 *counter +5
        Aeq(i,j) =1;
    end
    counter = counter +1;   
end

%FUNCTIONS
function initial_network(jammers,sbsnumber)
syms temp;
global transmision_power ;
transmision_power = 1; %pn = transmision power of SBS SBS_Number 30 dbm
global alpha ;
alpha = 2.7; %path loss exponent
global noise_power;
noise_power = 1.0e-10; % noise power of each UE
global bandwidth;
bandwidth = 1.0e+7; %available bandwidth
global delta ;
delta = 0.0025; %SINR threshold
global L ;
L = 1.0e+9;
global content_popularity;
content_popularity =zeros(100,10);
global SBS_Number;
SBS_Number = sbsnumber; %number of SBSs
global user_number;
%user_number = 20; %number of UEs
global jammer_number;
jammer_number = jammers;

global distance ;
distance = unifrnd(10,707,[SBS_Number user_number]);%distance between SBS SBS_Number and UE user_number, uniformly distributed
global jammer_dis;
jammer_dis = unifrnd(10,707,[SBS_Number jammer_number]); %distance between SBS and Jammer
%zipf's law denominator
Denominator =(1:10);
for i = 1:10
   Denominator(:,i)= symsum(1/(temp.^(i * 0.1)), temp , 1, 100);
end
%find content popularity
for i = 1:100
    for j = 1:10
        content_popularity(i,j) = (1 / i ^ (j*0.1))/(Denominator(1,j));
    end
end
C = 20; %cache capacity
global K;
K = 5;  % K =F/C group number
global PK;
PK = [1:10; 1:10; 1:10  ; 1:10 ;1:10];%popularity of content group k %zeros(5,10)
for k = 1:5
    for j = 1:10
        i = ( k- 1) *C +1: k * C;
        PK(k,j)=sum(content_popularity(i, j));
    end
end
end
 
function initial_gain_Backhual(jammers,sbsnumber)
syms temp; 
global transmision_power ;
transmision_power = 1; %pn = transmision power of SBS SBS_Number
global alpha ;
alpha = 2.7; %path loss exponent
global noise_power;
noise_power = 1.0e-10; % noise power of each UE
global bandwidth;
bandwidth = 1.0e+7; %available bandwidth
global delta ;%SINR threshold
delta = 0.0025;
%size of library
global F ;
F = zeros(1,100); 
global content_popularity;
content_popularity =zeros(100,10);
global SBS_Number;
SBS_Number = sbsnumber;
global user_number;
%user_number = 20; %number of UEs

global jammer_number;
jammer_number = jammers;
%jammer_number = 1;
global distance ;
global jammer_dis;
global r ; %wireless cap between sbs and user
global r_jam ; %wireless cap between sbs and jammer
global neighbouring;
global neighbouring_jam;
channel_gain = exprnd(4000, [SBS_Number user_number]);%channel gain between SBS SBS_Number & UE user_number, rayleigh distribution
r = [user_number,SBS_Number];%the wireless capacity between user user_number and SBS SBS_Number
x = transmision_power * channel_gain.* distance.^-alpha;
q = sum(x);
%jammer
channel_gain_jam = exprnd(4000, [SBS_Number jammer_number]);
r_jam = [jammer_number,SBS_Number];%the wireless capacity between jammer and SBS
x_jam = transmision_power * channel_gain_jam.* jammer_dis.^-alpha;
q_jam = sum(x_jam);
%find the wireless capacity between jammer and SBS
for i = 1:jammer_number
    for j = 1:SBS_Number
        r_jam(i,j) = bandwidth * log2(1 + ((transmision_power * channel_gain_jam(j, i) * jammer_dis(j, i)^-alpha)/(q_jam(1, i)+ noise_power - (transmision_power * channel_gain_jam(j, i) * jammer_dis(j, i)^-alpha)) ));
    end
end
%find the wireless capacity between user user_number and SBS SBS_Number
for i = 1:user_number
    for j = 1:SBS_Number
        r(i,j) = bandwidth * log2(1 + ((transmision_power * channel_gain(j, i) * distance(j, i)^-alpha)/(q(1, i)+ noise_power - (transmision_power * channel_gain(j, i) * distance(j, i)^-alpha)) ));
    end
end
%calculate SINR for jammer
SINR_jam = zeros(jammer_number,SBS_Number);
for i = 1:jammer_number    
    for j = 1:SBS_Number
        SINR_jam(i,j) =  ((transmision_power * channel_gain_jam(j, i) * jammer_dis(j, i)^-alpha)/(q_jam(1, i) + noise_power - (transmision_power * channel_gain_jam(j, i) * jammer_dis(j, i)^-alpha)));
    end
end
%calculate SINR
SINR = zeros(user_number,SBS_Number);
for i = 1:user_number    
    for j = 1:SBS_Number
        SINR(i,j) =  ((transmision_power * channel_gain(j, i) * distance(j, i)^-alpha)/(q(1, i) + noise_power - (transmision_power * channel_gain(j, i) * distance(j, i)^-alpha)));
    end
end
%neighbouring jammer
neighbouring_jam= zeros(jammer_number, SBS_Number);
for i = 1 :jammer_number
    for j = 1:SBS_Number
        if SINR_jam(i, j)>delta
            neighbouring_jam(i, j) =1;
        else
            neighbouring_jam(i, j) =0;
        end
    end
end
%neighbouring
neighbouring= zeros(user_number, SBS_Number);
for i = 1 :user_number
    for j = 1:SBS_Number
        if SINR(i, j)>delta
            neighbouring(i, j) =1;
        else
            neighbouring(i, j) =0;
        end
    end
end
global r_min;
r_min = bandwidth * log(1 + delta);%poorest wireless capacity
global B;
B = 0.4*r_min + r_min*rand(1, SBS_Number); %backhual capacity of SBS SBS_Number
end

%random number genarator
function ran = random_array()
    ran = [randi([1,5]),randi([1,5])];
end

%function added ~> this is the game between SBSs and Jammers :D
function [tbhNoJam_zipf,tbhNoJam_sbs,TBH_based_Zipf,TBH_out] = stackelberg_game(jammers,sbsnumber)
global traffic;
global Zipf_parameter;
global PK;
global Delay;
global SBS_Number;
SBS_Number = sbsnumber;
global user_number;
global jammer_number;
jammer_number = jammers;
global K;
global neighbouring;
global neighbouring_jam;
%file size
global L;
%backhaul capacity
global B;
bandW = min(B);
%for delta funcion
global delta_cal_value;
I = zeros(SBS_Number , K);
I(:,1) = ones(1,SBS_Number);

global cached_content;
cached_content = zeros(1,5,SBS_Number); %this is " a' "
for i = 1:SBS_Number
   for j = 1:K
       if I(i,j) == 1
           cached_content(1,j,i)= j;
       end
   end
end
cached_content_old = zeros(1,K,SBS_Number); % this is "a"
cached_content_old = cached_content;
jammer_strategy = zeros(1,jammer_number); % this is S0
%initial jammer strategy
for i = 1:jammer_number
        %row = randi([1,SBS_Number]);
        column = randi([2,5]);
        %if I(row,column) == 0
            jammer_strategy(1,i) = column;           
        %end           
end
%cost calculation for jammer - set jammer strategy according to the cost 
tmp_1 = 0;
tmp_2 = 0;
jammer_cost = 0;
jammer_cost_matrix = zeros(1,jammer_number);
CostTemp = zeros(1,jammer_number);
MinTmpJammer = -1e+15;
jammerTemp = zeros(1,jammer_number);
for jam_num = 1:jammer_number
    MinTmpJammer = 1e+15;
    for k = 1:K 
        delta_cal_value = delta_cal(jammer_strategy(1,jam_num),k); %value of delta(S0,j ,K)
        tmp_1 = delta_cal_value;
        for sbs = 1:SBS_Number
            if neighbouring_jam(jam_num,sbs) == 1
                delta_cal_value = delta_cal(cached_content(1,k,sbs),k); %value of delta(an ,K)
                tmp_2 =  1 - delta_cal_value;
            end
        end
        jammer_cost = jammer_cost + (-(tmp_1 * tmp_2 * (L/bandW)));
        if -(tmp_1 * tmp_2 * (L/bandW)) < MinTmpJammer
            MinTmpJammer = -(tmp_1 * tmp_2 * (L/bandW));
            jammerTemp(1,jam_num) = k;
        end
    end
    jammer_strategy(1,jam_num) = jammerTemp(1,jam_num);
    jammer_cost_matrix(1,jam_num) = jammer_cost;
end
%Tbh calculation
temp1 = zeros(1,Zipf_parameter);
Tbh_1 = 0;
Tbh_2 = 0;
global TBH;
TBH = zeros(1,Zipf_parameter);
global TBH_No_jammer;
TBH_No_jammer = zeros(1,Zipf_parameter);
contentTemp = zeros(1,SBS_Number);
for z=1:Zipf_parameter
    Tbh_1 = 0;
    Tbh_2 = 0;
    for sbs_num = 1:SBS_Number
        MinTemp = 1e+15;
        for k = 1:K
            for user_num = 1:user_number
                delta_cal_value = delta_cal(cached_content(1,k,sbs_num),k); %value of delta(an ,K)
                tmp_2 =  1 - delta_cal_value;
                Tbh_1 = Tbh_1 +PK(k,z) *tmp_2 * (L/bandW);
            end
            for j = 1:jammer_number
            if neighbouring_jam(j,sbs_num) == 1
                delta_cal_value = delta_cal(jammer_strategy(1,j),k); %value of delta(S0,j ,K)
                Tbh_2 = Tbh_2 + delta_cal_value *tmp_2 * (L/bandW);            
            end
            end
            if mean(PK(k,:)) *tmp_2 * (L/bandW) + delta_cal_value *tmp_2 * (L/bandW) < MinTemp && (mean(PK(k,:)) *tmp_2 * (L/bandW) + delta_cal_value *tmp_2 * (L/bandW)) ~= 0
                MinTemp = mean(PK(k,:)) *tmp_2 * (L/bandW) + delta_cal_value *tmp_2 * (L/bandW);
                contentTemp(1,sbs_num) = k;
            end
        end
        TBH(1,z) = TBH(1,z) + Tbh_1 + Tbh_2;
        TBH_No_jammer(1,z) = TBH_No_jammer(1,z) + Tbh_1;
    end
end
disp('TBH based on Zipf');
disp(TBH);
%
tbhNoJam_zipf = TBH_No_jammer;
tbhNoJam_sbs = TBH_No_jammer(1,10);
%cost calculation for SBS
SBS_cost = zeros(1,1,SBS_Number);
SBS_cost_Cn = zeros(1,1,SBS_Number);
sigma_delay = 0;
for sbs_n = 1:SBS_Number
    for k = 1:K
        for user_n = 1:user_number
            if neighbouring(user_n,sbs_n) == 1
                if cached_content(1,k,sbs_n) == 0 
                	sigma_delay = sigma_delay + Delay(user_n,k);
                end
            end   
        end 
    end
    SBS_cost(1,1,sbs_n) = mean(TBH(1,:)) + sigma_delay ;
end
%keep SBS Cost
SBS_cost_Cn = SBS_cost;
t_max = 20; %iteration
traffic = zeros(1,Zipf_parameter,t_max);
t=1;
pre_cached_content = zeros(1,K,SBS_Number); % this is "a"
%main loop
while t < t_max
    tmp_1 = 0;
    tmp_2 = 0;
    temp1 = 0;
    Tbh_1 = 0;
    Tbh_2 = 0;
    TBH = zeros(1,Zipf_parameter);
    tbh_for_each = zeros(1,Zipf_parameter,SBS_Number);
    sigma_delay = 0;
    pre_cached_content = cached_content;
    for i = 1:SBS_Number
        %update SBS_Strategy according to the SBS cost
    	MinTemp = 1e+15;
        for k = 1:K
            delta_cal_value = delta_cal(cached_content(1,k,i),k); %value of delta(an ,K)
            tmp_2 =  1 - delta_cal_value;
            temp1 = mean(PK(k,:)) *tmp_2 * (L/bandW);
            for j = 1:jammer_number
            	if neighbouring_jam(j,i) == 1
                    delta_cal_value = delta_cal(jammer_strategy(1,j),k); %value of delta(S0,j ,K)
            	end
            end
            if (temp1 + delta_cal_value *tmp_2 * (L/bandW)) < MinTemp && (temp1 + delta_cal_value *tmp_2 * (L/bandW)) ~= 0
            	MinTemp = (temp1 + delta_cal_value *tmp_2 * (L/bandW));
                contentTemp(1,i) = k;
            end
        end
        cached_content(1,:,i) = 0;
        cached_content(1,contentTemp(1,i),i)=contentTemp(1,i);    
        %SBS_Strategy END
        %TBH Calculation
        TBH = zeros(1,Zipf_parameter);
        TBH_No_jammer = zeros(1,Zipf_parameter);
        for z=1:Zipf_parameter
            Tbh_1 = 0;
            Tbh_2 = 0;
                for k = 1:K
                    for user_num = 1:user_number
                        delta_cal_value = delta_cal(cached_content(1,k,i),k); %value of delta(an ,K)
                        tmp_2 =  1 - delta_cal_value;
                        Tbh_1 = Tbh_1 +PK(k,z) *tmp_2 * (L/bandW);
                    end
                    for jam = 1:jammer_number
                    if neighbouring_jam(jam,i) == 1
                        delta_cal_value = delta_cal(jammer_strategy(1,jam),k); %value of delta(S0,j ,K)
                        Tbh_2 = Tbh_2 + delta_cal_value *tmp_2 * (L/bandW);            
                    end
                    end
                end
                TBH(1,z) = TBH(1,z) + Tbh_1 + Tbh_2;
                TBH_No_jammer(1,z) = TBH_No_jammer(1,z) + Tbh_1;
        end
        %TBH Calculation END
        %SBS COST 
        for k = 1:K
        	for user_n = 1:user_number
                if neighbouring(user_n,i) == 1
                	if cached_content(1,k,i) == 0
                        sigma_delay = sigma_delay + Delay(user_n,k);
                    end
                end
            end
        end
        SBS_cost(1,1,i) = mean(TBH(1,:)) + sigma_delay ; 
        %SBS COST END
        %update cached content (SBS strategy)
        if SBS_cost(1,1,i) > SBS_cost_Cn(1,1,i)
            cached_content(1,:,i) = cached_content_old(1,:,i);
            %disp('cache content did not change !');
               
        else
            cached_content_old(1,:,i) = cached_content(1,:,i);
            %disp('cache content changed !');
        end
        %update cached content (SBS strategy) END
        %update jammer strategy
        tmp_1 = 0;
        tmp_2 = 0;
        for jam_num = 1:jammer_number
            MinTmpJammer = 1e+15;
            for k = 1:K 
                delta_cal_value = delta_cal(jammer_strategy(1,jam_num),k); %value of delta(S0,j ,K)
                tmp_1 = delta_cal_value;
                    if neighbouring_jam(jam_num,i) == 1
                        delta_cal_value = delta_cal(cached_content(1,k,i),k); %value of delta(an ,K)
                        tmp_2 =  1 - delta_cal_value;
                    end
                if -(tmp_1 * tmp_2 * (L/bandW)) < MinTmpJammer
                    MinTmpJammer = -(tmp_1 * tmp_2 * (L/bandW));
                    jammerTemp(1,jam_num) = k;
                end
            end
            jammer_strategy(1,jam_num) = jammerTemp(1,jam_num);
        end
        SBS_cost_Cn(1,1,i) = SBS_cost(1,1,i); %update the cost        
    end
    if pre_cached_content == cached_content  
        break
    end
    traffic(1,:,t) = TBH(1,:);
    t = t+1;
end
TBH_based_Zipf = traffic(1,:,1);
TBH_out =  traffic(1,1,1);
end

%POTENTIAL GAME
function NoJammerDelay = potential_game(jammers,sbsnumber)
global Zipf_parameter;
global r_min;
global transmision_power ;
global alpha ; 
global bandwidth;
global delta ;
global L ;
global SBS_Number;
SBS_Number = sbsnumber;
global user_number;
global distance ;
global r;
global neighbouring;
global B;
global K;
global PK;
global moving_ave_potential_plot;
global zipf_num1;
global Delay;
%caching matrix
global I;
I = zeros(SBS_Number , K);
I0 = zeros(SBS_Number, K);
I(:,1) = ones(1,SBS_Number);
sbs_cost = zeros(1,K);
global best_response_plot;
best_response_plot = zeros(1,50);
global Ave_Delay ;
Ave_Delay = zeros(1,10);
initial_gain_Backhual(jammers,sbsnumber);
%rate = zeros(20000,user_number, SBS_Number);
%dis = distance;
global SINR;
rate = zeros(20000,user_number, SBS_Number);
dis = distance;
SINR_value = zeros(20000,user_number,SBS_Number);
%average_moving_plot = zeros(1,50);
 
parfor itr = 1:500000
         ra= zeros(user_number,SBS_Number);
         channel_gain = exprnd(4000, [SBS_Number user_number]);%channel gain between SBS SBS_Number & UE user_number, rayleigh distribution, SBS_Number = 10, user_number = 20
         x = transmision_power * channel_gain.* dis.^-alpha;
         q = zeros(user_number,1);%user_number =20
         q =sum(x);
        ra =rate_fun(channel_gain,q,dis,SBS_Number);
        SINR_value(itr,:,:) = SINR_fun(channel_gain,q,dis,SBS_Number);     
        rate(itr,:,:)= ra;
end
        r =  sum(rate)/50000;
        SINR = sum(SINR_value)/500000;
for Zipf = 1 :10
    counter = 0;
cost1 = zeros(1,user_number);
cost2 = zeros(1,user_number);
cost3 = zeros(1,user_number);
cost4 = zeros(1,user_number);
cost5 = zeros(1,user_number);
cost6 = zeros(1,user_number);
cost7 = zeros(1,user_number);
cost8 = zeros(1,user_number);
cost9 = zeros(1,user_number);
cost10 = zeros(1,user_number);
plot_counter = 0;

while true
    sbs_number =unidrnd(SBS_Number);
    for i = 1:K
        if I(sbs_number, i) ==1
            content_cached = i;
            break;
        end
    end
for content_number=1:K
            UE_Delay = zeros(user_number ,Zipf_parameter); 
        Delay = zeros(user_number,K);
        tmp = zeros(1,SBS_Number);
        max_data_rate =zeros(user_number,SBS_Number,K);
        %temp = 0;
        I(sbs_number,:) = zeros();
        I(sbs_number, content_number) = 1; %content is available
       for m = 1:user_number% M =20
            for n = 1:SBS_Number % N =10
                for k = 1:5 % K =5
                    max_data_rate(m, n, k)= r(1,m, n)* I(n,k) + 0.7 * r_min * (1- I(n,k));
                end
            end
       end
        for m = 1:user_number
            for k = 1:K
                for n = 1:SBS_Number
                    if neighbouring(m, n)==1
                        tmp(1, n) = max_data_rate(m, n, k);
                    else
                        tmp(1, n) = 0;
                    end
                end
                Delay(m, k) = L / max(tmp); %downloading delay
            end
        end
       
        for i = 1:user_number
            for j = 1 :Zipf_parameter
                for k = 1:K
                    UE_Delay (i , j) = UE_Delay(i, j) + (PK(k ,j) * Delay(i, k));%expected delay
                end
            end
        end
         
        temp = sum(UE_Delay); %UE_Delay = expected delay
        sbs_cost(1, content_number) = temp(1,Zipf) ;  
end
    [~, index] = min(sbs_cost); %we found the index of min cost
    %we want to minimize the delay
    if sbs_number==1
        cost1(1,counter+1) = min(sbs_cost);
    elseif sbs_number==2
        cost2(1,counter+1) = min(sbs_cost);
    elseif sbs_number==3
        cost3(1,counter+1) = min(sbs_cost);
    elseif sbs_number==4
        cost4(1,counter+1) = min(sbs_cost);
    elseif sbs_number==5
        cost5(1,counter+1) = min(sbs_cost);
    elseif sbs_number==6
        cost6(1,counter+1) = min(sbs_cost);
    elseif sbs_number==7
        cost7(1,counter+1) = min(sbs_cost);
    elseif sbs_number==8
        cost8(1,counter+1) = min(sbs_cost);
    elseif sbs_number==9
        cost9(1,counter+1) = min(sbs_cost);
    elseif sbs_number==10
        cost10(1,counter+1) = min(sbs_cost);
    end
    
    I(sbs_number,:) = zeros(); 
    if sbs_cost(1,index) < sbs_cost(1,content_cached) %if we found min cost I matrix should be reassigned
        I(sbs_number, index) = 1;
    else
        I(sbs_number, content_cached) =1;
    end
    
    sbs_cost = zeros(1,K);
    counter = counter + 1;
    UE_Delay = zeros(user_number ,Zipf_parameter ); 
        %Delay = zeros(user_number,K);
        tmp = zeros(1,SBS_Number);
        max_data_rate =zeros(user_number,SBS_Number,K);
        
       for m = 1:user_number% M =20
            for n = 1:SBS_Number % N =10
                for k = 1:5 % K =5
                    max_data_rate(m, n, k)= r(1,m, n)* I(n,k) + 0.7 * r_min * (1- I(n,k));
                end
            end
       end
  
        neighbouring= zeros(user_number, SBS_Number);
        for i = 1 :user_number
            for j = 1:SBS_Number
                if SINR(1,i, j)>delta
                    neighbouring(i, j) =1;
                else
                    neighbouring(i, j) =0;
                end
            end
        end
        Delay = zeros(user_number,K);
        tmp = zeros(1,SBS_Number);
        for m = 1:user_number
            for k = 1:K
                for n = 1:SBS_Number
                    if neighbouring(m, n)==1
                        tmp(1, n) = max_data_rate(m, n, k);
                    else
                        tmp(1, n) = 0;
                    end
                end
                Delay(m, k) = L / max(tmp);
            end
        end      
        for i = 1:user_number
            for j = 1 :Zipf_parameter
                for k = 1:K
                    UE_Delay (i , j) = UE_Delay(i, j) + (PK(k ,j) * Delay(i, k));
            
                end
            end
        end
        %temp = 0;
        temp = sum(UE_Delay)/user_number; %average_delay
         if Zipf==1 &&  counter <=50
           best_response_plot(1,counter) =  temp(1, Zipf)* user_number;
            
         end
    if isequal(I,I0)%I stands for content
        plot_counter = plot_counter + 1;
 
    end
    
%     new_avg = zeros(100,Zipf);
%     for i = 1:100
        if plot_counter >= 400 && isequal(I,I0)
            Ave_Delay(1,Zipf) = Ave_Delay(1,Zipf) / counter;
%             new_avg(i,:) = Ave_Delay(1,Zipf);
            break;
        end
 
    %end
    I0 = I;
end
end
 
 
%%%%%%
for s = 1:1
initial_gain_Backhual(jammers,sbsnumber);
        max_data_rate =zeros(user_number,SBS_Number,K);
        UE_Delay = zeros(user_number ,Zipf_parameter );
       for m = 1:user_number% user_number =20
            for n = 1:SBS_Number % SBS_Number =10
                for k = 1:5 % K =5
                    max_data_rate(m, n, k)= r(m, n)* I(n,k) + min(r(m, n), B(1, n)) * (1- I(n,k));
                end
            end
       end       
        neighbouring= zeros(user_number, SBS_Number);
        for i = 1 :user_number
            for j = 1:SBS_Number
                if SINR(1,i, j)>delta
                    neighbouring(i, j) =1;
                else
                    neighbouring(i, j) =0;
                end
            end
        end
        Delay = zeros(user_number,K);
        tmp = zeros(1,SBS_Number);
        for m = 1:user_number
            for k = 1:K
                for n = 1:SBS_Number
                    if neighbouring(m, n)==1
                        tmp(1, n) = max_data_rate(m, n, k);
                    else
                        tmp(1, n) = 0;
                    end
                end
                Delay(m, k) = L / max(tmp);
            end
        end
       
        for i = 1:user_number
            for j = 1 :Zipf_parameter
                for k = 1:K
                    UE_Delay (i , j) = UE_Delay(i, j) + (PK(k ,j) * Delay(i, k));
            
                end
            end
        end
        temp = sum(UE_Delay);
        moving_ave_potential_plot(1,s) = temp(1,1) /10;
        zipf_num1(1,:) = temp;
end
    for i = 2:20
    moving_ave_potential_plot(1,i) = (moving_ave_potential_plot(1,i) + moving_ave_potential_plot (1,i-1));
    end
    for i = 2:20
        moving_ave_potential_plot(1,i) = (moving_ave_potential_plot(1,i) /i);
    end

NoJammerDelay = moving_ave_potential_plot;
end

%new potential game with new matrix
function [delay_based_zipf,delay_out] = new_potential_game(jammers,sbsnumber)
global Zipf_parameter
global transmision_power ;
global alpha ;
global bandwidth;
global delta ;
global L ;
global SBS_Number;
SBS_Number = sbsnumber;
global user_number;
global distance ;
global r;
global neighbouring;
global B;
global K;
global PK;
global moving_ave_potential_plot2;
global zipf_num2;
global Delay;
global I;
global cached_content;
for sbs = 1:SBS_Number
    for k = 1:K
        %disp(cached_content(1,k,sbs));
        if cached_content(1,k,sbs) ~= 0
            I(sbs,k) = 1;
        else
            I(sbs,k) = 0;
        end    
    end
end
I0 = zeros(SBS_Number, K);
sbs_cost = zeros(1,K);
global best_response_plot2;
best_response_plot2 = zeros(1,50);
global Ave_Delay ;
Ave_Delay = zeros(1,10);
initial_gain_Backhual(jammers,sbsnumber);
rate = zeros(20000,user_number, SBS_Number);
dis = distance;
SINR_value = zeros(20000,user_number,SBS_Number);
%average_moving_plot = zeros(1,50);
 
parfor itr = 1:500000
         ra= zeros(user_number,SBS_Number);
         channel_gain = exprnd(4000, [SBS_Number user_number]);%channel gain between SBS SBS_Number & UE user_number, rayleigh distribution, SBS_Number = 10, user_number = 20
         x = transmision_power * channel_gain.* dis.^-alpha;
         q = zeros(user_number,1);%user_number =20
         q =sum(x);
        ra =rate_fun(channel_gain,q,dis,SBS_Number);
        SINR_value(itr,:,:) = SINR_fun(channel_gain,q,dis,SBS_Number);     
        rate(itr,:,:)= ra;
end
        r =  sum(rate)/50000;
        SINR = sum(SINR_value)/500000;
        r_min = bandwidth * log(1 + delta);%poorest wireless capacity
 
        B = 0.4*r_min + r_min*rand(1, SBS_Number); %backhual capacity of SBS SBS_Number, SBS_Number =10
        for i = 1 :user_number
            for j = 1:SBS_Number
                if SINR(1,i, j)>delta
                    neighbouring(i, j) =1;
                else
                    neighbouring(i, j) =0;
                end
            end
        end
for Zipf = 1 :10
    counter = 0;
cost1 = zeros(1,user_number);
cost2 = zeros(1,user_number);
cost3 = zeros(1,user_number);
cost4 = zeros(1,user_number);
cost5 = zeros(1,user_number);
cost6 = zeros(1,user_number);
cost7 = zeros(1,user_number);
cost8 = zeros(1,user_number);
cost9 = zeros(1,user_number);
cost10 = zeros(1,user_number);
plot_counter = 0;
%content_cached = 1;
while true
    sbs_number =unidrnd(SBS_Number);
    for i = 1:K
        if I(sbs_number, i) ==1
            content_cached = i;
            break;
        end
    end
for content_number=1:K
            UE_Delay = zeros(user_number ,Zipf_parameter ); 
        Delay = zeros(user_number,K);
        tmp = zeros(1,SBS_Number);
        max_data_rate =zeros(user_number,SBS_Number,K);
        %temp = 0;
        I(sbs_number,:) = zeros();
        I(sbs_number, content_number) = 1; %content is available
       for m = 1:user_number% M =20
            for n = 1:SBS_Number % N =10
                for k = 1:5 % K =5
                    max_data_rate(m, n, k)= r(1,m, n)* I(n,k) + 0.7 * r_min * (1- I(n,k));
                end
            end
       end
        for m = 1:user_number
            for k = 1:K
                for n = 1:SBS_Number
                    if neighbouring(m, n)==1
                        tmp(1, n) = max_data_rate(m, n, k);
                    else
                        tmp(1, n) = 0;
                    end
                end
                Delay(m, k) = L / max(tmp); %downloading delay
            end
        end
       
        for i = 1:user_number
            for j = 1 :Zipf_parameter
                for k = 1:K
                    UE_Delay (i , j) = UE_Delay(i, j) + (PK(k ,j) * Delay(i, k));%expected delay
                end
            end
        end
         
        temp = sum(UE_Delay); %UE_Delay = expected delay
        sbs_cost(1, content_number) = temp(1,Zipf) ;  
end
    [~, index] = min(sbs_cost); %we found the index of min cost
    %we want to minimize the delay
    if sbs_number==1
        cost1(1,counter+1) = min(sbs_cost);
    elseif sbs_number==2
        cost2(1,counter+1) = min(sbs_cost);
    elseif sbs_number==3
        cost3(1,counter+1) = min(sbs_cost);
    elseif sbs_number==4
        cost4(1,counter+1) = min(sbs_cost);
    elseif sbs_number==5
        cost5(1,counter+1) = min(sbs_cost);
    elseif sbs_number==6
        cost6(1,counter+1) = min(sbs_cost);
    elseif sbs_number==7
        cost7(1,counter+1) = min(sbs_cost);
    elseif sbs_number==8
        cost8(1,counter+1) = min(sbs_cost);
    elseif sbs_number==9
        cost9(1,counter+1) = min(sbs_cost);
    elseif sbs_number==10
        cost10(1,counter+1) = min(sbs_cost);
    end
    
    I(sbs_number,:) = zeros(); 
    if sbs_cost(1,index) < sbs_cost(1,content_cached) %if we found min cost I matrix should be reassigned
        I(sbs_number, index) = 1;
    else
        I(sbs_number, content_cached) =1;
    end
    
    sbs_cost = zeros(1,K);
    counter = counter + 1;
    UE_Delay = zeros(user_number ,Zipf_parameter ); 
        %Delay = zeros(user_number,K);
        tmp = zeros(1,SBS_Number);
        max_data_rate =zeros(user_number,SBS_Number,K);
        
       for m = 1:user_number% M =20
            for n = 1:SBS_Number % N =10
                for k = 1:5 % K =5
                    max_data_rate(m, n, k)= r(1,m, n)* I(n,k) + 0.7 * r_min * (1- I(n,k));
                end
            end
       end
  
        neighbouring= zeros(user_number, SBS_Number);
        for i = 1 :user_number
            for j = 1:SBS_Number
                if SINR(1,i, j)>delta
                    neighbouring(i, j) =1;
                else
                    neighbouring(i, j) =0;
                end
            end
        end
        Delay = zeros(user_number,K);
        tmp = zeros(1,SBS_Number);
        for m = 1:user_number
            for k = 1:K
                for n = 1:SBS_Number
                    if neighbouring(m, n)==1
                        tmp(1, n) = max_data_rate(m, n, k);
                    else
                        tmp(1, n) = 0;
                    end
                end
                Delay(m, k) = L / max(tmp);
            end
        end      
        for i = 1:user_number
            for j = 1 :Zipf_parameter
                for k = 1:K
                    UE_Delay (i , j) = UE_Delay(i, j) + (PK(k ,j) * Delay(i, k));
            
                end
            end
        end
        %temp = 0;
        temp = sum(UE_Delay)/user_number; %average_delay
         if Zipf==1 &&  counter <=50
           best_response_plot2(1,counter) =  temp(1, Zipf)* user_number;
            
         end
    if isequal(I,I0)%I stands for content
        plot_counter = plot_counter + 1;
 
    end
        if plot_counter >= 400 && isequal(I,I0)
            Ave_Delay(1,Zipf) = Ave_Delay(1,Zipf) / counter;
            break;
        end
 
    %end
    I0 = I;
end
end
 
 
%%%%%%
for s = 1:1
initial_gain_Backhual(jammers,sbsnumber);
%         UE_Delay = zeros(user_number ,10 ); 
%         Delay = zeros(user_number,K);
%         tmp = zeros(1,SBS_Number);
        max_data_rate =zeros(user_number,SBS_Number,K);
        UE_Delay = zeros(user_number ,Zipf_parameter );
       for m = 1:user_number% user_number =20
            for n = 1:SBS_Number % SBS_Number =10
                for k = 1:5 % K =5
                    max_data_rate(m, n, k)= r(m, n)* I(n,k) + min(r(m, n), B(1, n)) * (1- I(n,k));
                end
            end
       end
       
        neighbouring= zeros(user_number, SBS_Number);
        for i = 1 :user_number
            for j = 1:SBS_Number
                if SINR(1,i, j)>delta
                    neighbouring(i, j) =1;
                else
                    neighbouring(i, j) =0;
                end
            end
        end
        Delay = zeros(user_number,K);
        tmp = zeros(1,SBS_Number);
        for m = 1:user_number
            for k = 1:K
                for n = 1:SBS_Number
                    if neighbouring(m, n)==1
                        tmp(1, n) = max_data_rate(m, n, k);
                    else
                        tmp(1, n) = 0;
                    end
                end
                Delay(m, k) = L / max(tmp);
            end
        end
       
        for i = 1:user_number
            for j = 1 :Zipf_parameter
                for k = 1:K
                    UE_Delay (i , j) = UE_Delay(i, j) + (PK(k ,j) * Delay(i, k));
            
                end
            end
        end
        temp = sum(UE_Delay);
        moving_ave_potential_plot2(1,s) = temp(1,1) /10;
        zipf_num2(1,:) = temp(1,:)/user_number; 
end
    for i = 2:20
    moving_ave_potential_plot2(1,i) = (moving_ave_potential_plot2(1,i) + moving_ave_potential_plot2(1,i-1));
    end
    for i = 2:20
        moving_ave_potential_plot2(1,i) = (moving_ave_potential_plot2(1,i) /i);
    end
    
delay_based_zipf = zipf_num2;
delay_out  = moving_ave_potential_plot2;
end

% WIRELESS CAPACITY BETWEEN USER user_number AND SBS SBS_Number %
 function rate = rate_fun(channel_gain, q,distance,sbsnumber)
global transmision_power ;
transmision_power = 1; %pn = transmision power of SBS SBS_Number
global alpha ;
alpha = 4; %path loss exponent
global noise_power;
noise_power = 1.0e-10; % noise power of each UE
global bandwidth;
bandwidth = 1.0e+7; %available bandwidth
global SBS_Number;
SBS_Number = sbsnumber;
global user_number;
user_number = 20; %number of UEs
rate =zeros(user_number,SBS_Number);
    for i = 1:user_number
            for j = 1:SBS_Number
                rate(i,j) = bandwidth * log2(1 + ((transmision_power * channel_gain(j, i) * distance(j, i)^-alpha)/(q(1, i)+ noise_power - (transmision_power * channel_gain(j, i) * distance(j, i)^-alpha)) ));
            end
    end
 end
% CALCULATE SINR -> SBSs which have SINR above the threshold can serve the UE streaming request
function SINR = SINR_fun(channel_gain, q, distance,sbsnumber)
global transmision_power ;
transmision_power = 1; %pn = transmision power of SBS SBS_Number
global alpha ;
alpha = 2.7; %path loss exponent
global noise_power;
noise_power = 1.0e-10; % noise power of each UE
global SBS_Number;
SBS_Number = sbsnumber;
global user_number;
user_number = 20; %number of UEs
SINR = zeros(user_number, SBS_Number);
    for i = 1:user_number
            for j = 1:SBS_Number
                SINR(i,j) =  ((transmision_power * channel_gain(j, i) * distance(j, i)^-alpha)/(q(1, i) + noise_power - (transmision_power * channel_gain(j, i) * distance(j, i)^-alpha)));
            end
    end
end
