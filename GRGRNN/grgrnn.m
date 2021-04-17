%交叉验证求光滑因子
%% 清空环境变量,
clc;
clear all
close all
nntwarn off;
clear global var
num1 = xlsread('total460.csv');
m=414
rowrank = randperm(size(num1, 1));% 随机打乱行号
input_train=num1(rowrank(1:m),1:end-1);%训练数据的输入数据
output_train=num1(rowrank(1:m),end);%训练数据的输出数据
input_test=num1(rowrank(m+1:end),1:end-1);%测试数据的输入数据
output_test=num1(rowrank(m+1:end),end); %测试数据的输出数据

%% 交叉验证
desired_spread=[];%期望光滑因子的取值
mse_max=10e20;%MSE的最大值
desired_input=[];
desired_output=[];
resuloutput_perfp=[];
indices = crossvalind('Kfold',length(input_train),10);
indices = indices';
h=waitbar(0,'正在寻找最优化参数....');
k=1;
for i = 1:10
    perfp=[];
    disp(['以下为第',num2str(i),'次交叉验证结果'])
    test = (indices == i); train = ~test;
    input_cv_train=input_train(train,:);
    output_cv_train=output_train(train,:);
    input_cv_test=input_train(test,:);
    output_cv_test=output_train(test,:);
    input_cv_train=input_cv_train';
    output_cv_train=output_cv_train';
    input_cv_test= input_cv_test';
    output_cv_test= output_cv_test';
    [input_cv_train,minin,maxin,output_cv_train,minout,maxout]=premnmx(input_cv_train,output_cv_train);
    input_cv_test=tramnmx(input_cv_test,minin,maxin);
    for spread=0.1:0.001:0.4;
        net=newgrnn(input_cv_train,output_cv_train,spread);
        waitbar(k/300,h);
        disp(['当前spread值为', num2str(spread)]);
        test_Out=sim(net,input_cv_test);
        test_Out=postmnmx(test_Out,minout,maxout);
        error=output_cv_test-test_Out;
        mserr=mse(error);
        disp(['当前网络的mse为',num2str(mse(error))])
        perfp=[perfp mse(error)];
        if mserr<mse_max
            mse_max=mserr;
            besti_spread=spread;%besti_spread为每次验证所得的光滑因子
        end
        k=k+1;
    end
    desired_spread=[desired_spread besti_spread];
    result_perfp(i,:)=perfp;
end;
close(h)
best_spread=mean(desired_spread);%best_spread为交叉验证得到的最佳光滑因子
disp(['最佳spread值为',num2str(best_spread)])

%% 采用最佳方法建立GRNN网络

[inputn,inputps]=mapminmax(input_train',-1,1);%训练数据的输入数据的归一化
inputn_test=mapminmax('apply',input_test',inputps);
[outputn,outputps]=mapminmax(output_train',-1,1);%训练数据的输出数据的归一化de
putputn_test=mapminmax('apply',output_test',outputps);
%spread=0.02;
net=newgrnn(inputn,outputn,best_spread);
grnn_prediction_result=sim(net,inputn_test);
grnn_output=mapminmax('reverse',grnn_prediction_result,outputps);
grnn_error=output_test-grnn_output';
disp(['GRNN神经网络预测的均方误差为',num2str(mse(grnn_error))])
figure
plot(grnn_output,'k-*')%图1
hold on
plot(output_test','r-o')
hold off
xlabel('测试样本')
ylabel('p3')
legend('广义神经网络预测值','实际值')
figure
plot(output_test,grnn_output,'*')%图2
xlabel('实际值')
ylabel('预测值')
figure
 plot(grnn_error,'k-*')%图3
 ylabel('误差')
