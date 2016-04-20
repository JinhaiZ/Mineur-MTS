function [ Bruit_blanc] = BruitBlanc( mu,sigma,num)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

Bruit_blanc = mu + sigma*randn(1,num);
end

