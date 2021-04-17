%% �ô���Ϊ����BP�������Ԥ���㷨
%% ��ջ�������
clc;
clear all
close all
nntwarn off;
%% ѵ������Ԥ��������ȡ
num1 = xlsread('train420.csv');
num2 = xlsread('test21.csv');
input_train=num1(:,1:end-1)';%ѵ�����ݵ���������
output_train=num1(:,end)';%ѵ�����ݵ��������
input_test=num2(:,1:end-1)';%�������ݵ���������
output_test=num2(:,end)'; %�������ݵ��������

%ѡ����������������ݹ�һ��
[inputn,inputps]=mapminmax(input_train);
[outputn,outputps]=mapminmax(output_train);

%% BP����ѵ��
% %��ʼ������ṹ
net=newff(inputn,outputn,15);
net.trainParam.epochs=100;
net.trainParam.lr=0.1;

net.trainParam.goal=0.00004;

%����ѵ��
net=train(net,inputn,outputn);

%% BP����Ԥ��
%Ԥ�����ݹ�һ��
inputn_test=mapminmax('apply',input_test,inputps);
 
%����Ԥ�����
an=sim(net,inputn_test);
 
%�����������һ��
BPoutput=mapminmax('reverse',an,outputps);
%Ԥ�����
error=BPoutput-output_test;
disp(['��ǰ������Ե�mseΪ',num2str(mse(error))])
%% �������
figure
title('BP����Ԥ��ֵ','fontsize',12)
plot(BPoutput,'k-*');
hold on
plot(output_test','r-o');
hold off
xlabel('��������');
ylabel('p3');
legend('Ԥ�����','�������');

 figure
 plot(error,'k-*');
 ylabel('���');

title('BP����Ԥ�����','fontsize',12)
%ylabel('�������','fontsize',12)
%xlabel('����','fontsize',12)
%figure(2)
%plot(error,'-*')
%title('BP����Ԥ�����','fontsize',12)
ylabel('���','fontsize',12);
%xlabel('����','fontsize',12)


