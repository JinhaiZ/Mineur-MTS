function [ auto ] = Autocorrelation( trame )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% nb =160,p=10
auto = zeros(1,11);
for k = 0:1:10
    ind = k+1;
    auto(ind)=(1/160)*(trame(1:(160-k)))'*trame((1+k):160);
end

