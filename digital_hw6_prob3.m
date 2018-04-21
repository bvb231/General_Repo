close all; clear all; clc; 
 tic;
%This is constant with our signal
signal_energy = 1;
s1 = sqrt(signal_energy);
s2 = -sqrt(signal_energy);
size_of_vector = 10e7;

transmitted_vector = randn(1,size_of_vector);
for i = 1:length(transmitted_vector)
   if(transmitted_vector(i) > 0.5)
       transmitted_vector(i) = s1;
   else
       transmitted_vector(i) = s2;
   end
end


%We're exploring how the error rate compares when No goes from 1-10 so
%we'll loop it and make a matrix out of it. Rank is based on the No run.
for i = 1:10
    No(i) = i;
    %Generating our noise vector
    noise(i,:) = sqrt(No(i)/2)*randn(1,10e7);

    %Generating our recieve vector with the recieve conditions
    for k = 1:length(transmitted_vector)
       if(noise(i,k) + transmitted_vector(k) > 0)
           recieved_vector(i,k) = s1;
       else
           recieved_vector(i,k) = s2;
       end
    end


    %Seeing how many errors we get
    num_errors(i) = 0;
    for k = 1:length(transmitted_vector)
       if( transmitted_vector(k) ~= recieved_vector(i,k) ) 
           num_errors(i) = num_errors(i)+1;
       end
    end
end
%%
%replacing zero with a tiny number so we dont get -inf when taking the log
close all;
for i = 1:10
    num_errors_prob(i) = num_errors(i) ./ size_of_vector;
    if (num_errors(i) < 10e-10)
        num_errors_prob(i) = 10e-10;
    end
end 

SNR = 2* sqrt(signal_energy./No);
log_error = 10*log(num_errors_prob);
Q_Function_Value = (qfunc(2*sqrt( (signal_energy)./No)) );

log_Q_Function_Value = 10*log(Q_Function_Value);
%%

figure(1);

%semilogy(ax1, SNR,num_errors_prob);
plot(SNR,num_errors_prob,SNR,Q_Function_Value);
title('Non Log');
legend('Sim','Q func');
ylabel('Prob of Err');
xlabel('Eb/No Values, SNR per bit [dB] ');

figure(2);
semilogy( SNR,log_error,SNR,log_Q_Function_Value);
title('Log');
legend('Sim','Q func');
ylabel('Prob of Err');
xlabel('Eb/No Values, SNR per bit [dB] ');


%After comparing the two signals, it can be seen in the graph's provided
%that the Q-Function shows that the probability of error is lower as SNR
%increases. The channel simulation shows a more realistic probability of
%the error rate seen in the transmission channel
toc