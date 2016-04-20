function [ tau ] = Tau( trame )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% nb =160,p=10
tau = zeros(1,11);
for k = 0:1:10
    ind = k+1;
    tau(ind)=(1/160)*(trame(1:(160-k)))'*trame((1+k):160);
end

