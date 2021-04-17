%% 该代码为基于BP神经网络的预测算法
%% 清空环境变量
clc;
clear all
close all
nntwarn off;
%% 训练数据预测数据提取
num1 = xlsread('train420.csv');
num2 = xlsread('test21.csv');
input_train=num1(:,1:end-1)';%训练数据的输入数据
output_train=num1(:,end)';%训练数据的输出数据
input_test=num2(:,1:end-1)';%测试数据的输入数据
output_test=num2(:,end)'; %测试数据的输出数据

%选连样本输入输出数据归一化
[inputn,inputps]=mapminmax(input_train);
[outputn,outputps]=mapminmax(output_train);

%% BP网络训练
% %初始化网络结构
net=newff(inputn,outputn,15);
net.trainParam.epochs=100;
net.trainParam.lr=0.1;

net.trainParam.goal=0.00004;

%网络训练
net=train(net,inputn,outputn);

%% BP网络预测
%预测数据归一化
inputn_test=mapminmax('apply',input_test,inputps);
 
%网络预测输出
an=sim(net,inputn_test);
 
%网络输出反归一化
BPoutput=mapminmax('reverse',an,outputps);
%预测误差
error=BPoutput-output_test;
disp(['当前网络测试的mse为',num2str(mse(error))])
%% 结果分析
figure
title('BP网络预测值','fontsize',12)
plot(BPoutput,'k-*');
hold on
plot(output_test','r-o');
hold off
xlabel('测试样本');
ylabel('p3');
legend('预测输出','期望输出');

 figure
 plot(error,'k-*');
 ylabel('误差');

title('BP网络预测输出','fontsize',12)
%ylabel('函数输出','fontsize',12)
%xlabel('样本','fontsize',12)
%figure(2)
%plot(error,'-*')
%title('BP网络预测误差','fontsize',12)
ylabel('误差','fontsize',12);
%xlabel('样本','fontsize',12)


