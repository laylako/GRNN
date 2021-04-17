%rbf网络
clc;
clear all
close all
nntwarn off;
num1 = xlsread('train420.csv');
num2 = xlsread('test21.csv');
input_train=num1(:,1:end-1)';%ѵ�����ݵ���������
output_train=num1(:,end)';%ѵ�����ݵ��������
input_test=num2(:,1:end-1)';%�������ݵ���������
output_test=num2(:,end)'; %�������ݵ��������?

%%ѡ����������������ݹ�һ��?
[inputn,inputps]=mapminmax(input_train);
[outputn,outputps]=mapminmax(output_train);
inputn_test=mapminmax('apply',input_test,inputps);%预测数据归一�?
% %初始化网络结�?
net=newrbe(inputn,outputn,50);%% rbf网络训练

%网络预测输出
anrbf=sim(net,inputn_test);
 
%网络输出反归�?��
rbfoutput=mapminmax('reverse',anrbf,outputps);
%预测误差
error=rbfoutput-output_test;
disp(['��ǰ������Ե�mseΪ',num2str(mse(error))])
%% �������
figure
plot(rbfoutput,'k-*')
hold on
plot(output_test','r-o')
hold off
xlabel('测试样本')
ylabel('p3')
legend('预测输出','期望输出')

 figure
 plot(error,'k-*')
 ylabel('误差')

