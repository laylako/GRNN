% 基于SVM的回归预测分析�?—铜矿品位预�?

%% 清空环境变量
function chapter_sh
tic;
close all;
clear;
clc;
format compact;
%% 数据的提取和预处�?

num1 = xlsread('train420.csv');
num2 = xlsread('test21.csv');
input_train=num1(:,1:end-1);%ѵ�����ݵ���������
output_train=num1(:,end);%ѵ�����ݵ��������
input_test=num2(:,1:end-1);%�������ݵ���������
output_test=num2(:,end); %�������ݵ��������?

% ���ݵ���ȡ��Ԥ����

[inputn,inputps]=mapminmax(input_train',-1,1);%ѵ�����ݵ��������ݵĹ�һ��
inputn_test=mapminmax('apply',input_test',inputps);
[outputn,outputps]=mapminmax(output_train',-1,1);%ѵ�����ݵ�������ݵĹ�һ��
putputn_test=mapminmax('apply',output_test',outputps);
%% ѡ��ع�Ԥ�������ѵ�SVM����c&g
inputn=inputn';
inputn_test=inputn_test';
outputn=outputn';
putputn_test=putputn_test';
% ���Ƚ��д���ѡ��: 
[bestmse,bestc,bestg] = SVMcgForRegress(outputn,inputn,-8,8,-8,8);

% 打印粗略选择结果
%disp('打印粗略选择结果');
%str = sprintf( 'Best Cross Validation MSE = %g Best c = %g Best g = %g',bestmse,bestc,bestg);
%disp(str);

% ���ݴ���ѡ��Ľ��ͼ�ٽ��о�ϸѡ��: 
[bestmse,bestc,bestg] = SVMcgForRegress(outputn,inputn,-4,4,-4,4,3,0.5,0.5,0.05);

% ��ӡ��ϸѡ����
disp('��ӡ��ϸѡ����');
str = sprintf( 'Best Cross Validation MSE = %g Best c = %g Best g = %g',bestmse,bestc,bestg);
disp(str);

%% ���ûع�Ԥ�������ѵĲ�������SVM����ѵ��
cmd = ['-c ', num2str(bestc), ' -g ', num2str(bestg) , ' -s 3 -p 0.01'];
%cmd = ['-c ', '0.707107', ' -g ', '2' , ' -s 3 -p 0.01'];
model = svmtrain(outputn,inputn,cmd);

%% SVM����ع�Ԥ��
[predict,mse,sssy] = svmpredict(putputn_test,inputn_test,model);
predict = mapminmax('reverse',predict',outputps);
predict = predict';

% ��ӡ�ع���
str = sprintf( '������� MSE = %g ���ϵ�� R = %g%%',mse(2,1),mse(3,1)*100);
disp(str);

%% �������
figure;
hold on;
plot(output_test,'r-o');%实际�?
plot(predict,'k-*');%预测�?
legend('Ԥ��ֵ','ʵ��ֵ');
hold off;
title('ԭʼ���ݺͻع�Ԥ�����ݶԱ�','FontSize',12);

grid on;

figure;
svmerror = predict - output_test;

plot(svmerror,'k-*');
%title('误差�?,12);

ylabel('mse','FontSize',12);

snapnow;
toc;
function [mse,bestc,bestg] = SVMcgForRegress(train_label,train,cmin,cmax,gmin,gmax,v,cstep,gstep,msestep)
%SVMcg cross validation by faruto

if nargin < 10
   % msestep = 0.06;
end
if nargin < 8
    cstep = 0.8;
    gstep = 0.8;
end
if nargin < 7
    v = 5;
end
if nargin < 5
    gmax = 8;
    gmin = -8;
end
if nargin < 3
   cmax = 8;
   cmin = -8;
end
% X:c Y:g cg:acc
[X,Y] = meshgrid(cmin:cstep:cmax,gmin:gstep:gmax);
[m,n] = size(X);
cg = zeros(m,n);

eps = 10^(-4);

bestc = 0;
bestg = 0;
mse = Inf;
basenum = 2;
for i = 1:m
    for j = 1:n
        cmd = ['-v ',num2str(v),' -c ',num2str( basenum^X(i,j) ),' -g ',num2str( basenum^Y(i,j) ),' -s 3 -p 0.1'];
       cg(i,j) = svmtrain(train_label, train, cmd);
        
       if cg(i,j) < mse
            mse = cg(i,j);
            bestc = basenum^X(i,j);
            bestg = basenum^Y(i,j);
       end
        
        if abs( cg(i,j)-mse )<=eps && bestc > basenum^X(i,j)
            mse = cg(i,j);
            bestc = basenum^X(i,j);
            bestg = basenum^Y(i,j);
        end
        
    end
end
% to draw the acc with different c & g
[cg,ps] = mapminmax(cg,0,1);