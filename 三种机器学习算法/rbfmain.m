%rbf缃戠粶
clc;
clear all
close all
nntwarn off;
num1 = xlsread('train420.csv');
num2 = xlsread('test21.csv');
input_train=num1(:,1:end-1)';%训练数据的输入数据
output_train=num1(:,end)';%训练数据的输出数据
input_test=num2(:,1:end-1)';%测试数据的输入数据
output_test=num2(:,end)'; %测试数据的输出数据?

%%选连样本输入输出数据归一化?
[inputn,inputps]=mapminmax(input_train);
[outputn,outputps]=mapminmax(output_train);
inputn_test=mapminmax('apply',input_test,inputps);%棰勬祴鏁版嵁褰掍竴鍖?
% %鍒濆鍖栫綉缁滅粨鏋?
net=newrbe(inputn,outputn,50);%% rbf缃戠粶璁粌

%缃戠粶棰勬祴杈撳嚭
anrbf=sim(net,inputn_test);
 
%缃戠粶杈撳嚭鍙嶅綊涓?寲
rbfoutput=mapminmax('reverse',anrbf,outputps);
%棰勬祴璇樊
error=rbfoutput-output_test;
disp(['当前网络测试的mse为',num2str(mse(error))])
%% 结果分析
figure
plot(rbfoutput,'k-*')
hold on
plot(output_test','r-o')
hold off
xlabel('娴嬭瘯鏍锋湰')
ylabel('p3')
legend('棰勬祴杈撳嚭','鏈熸湜杈撳嚭')

 figure
 plot(error,'k-*')
 ylabel('璇樊')

