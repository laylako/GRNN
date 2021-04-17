%������֤��⻬����
%% ��ջ�������,
clc;
clear all
close all
nntwarn off;
clear global var
num1 = xlsread('total460.csv');
m=414
rowrank = randperm(size(num1, 1));% ��������к�
input_train=num1(rowrank(1:m),1:end-1);%ѵ�����ݵ���������
output_train=num1(rowrank(1:m),end);%ѵ�����ݵ��������
input_test=num1(rowrank(m+1:end),1:end-1);%�������ݵ���������
output_test=num1(rowrank(m+1:end),end); %�������ݵ��������

%% ������֤
desired_spread=[];%�����⻬���ӵ�ȡֵ
mse_max=10e20;%MSE�����ֵ
desired_input=[];
desired_output=[];
resuloutput_perfp=[];
indices = crossvalind('Kfold',length(input_train),10);
indices = indices';
h=waitbar(0,'����Ѱ�����Ż�����....');
k=1;
for i = 1:10
    perfp=[];
    disp(['����Ϊ��',num2str(i),'�ν�����֤���'])
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
        disp(['��ǰspreadֵΪ', num2str(spread)]);
        test_Out=sim(net,input_cv_test);
        test_Out=postmnmx(test_Out,minout,maxout);
        error=output_cv_test-test_Out;
        mserr=mse(error);
        disp(['��ǰ�����mseΪ',num2str(mse(error))])
        perfp=[perfp mse(error)];
        if mserr<mse_max
            mse_max=mserr;
            besti_spread=spread;%besti_spreadΪÿ����֤���õĹ⻬����
        end
        k=k+1;
    end
    desired_spread=[desired_spread besti_spread];
    result_perfp(i,:)=perfp;
end;
close(h)
best_spread=mean(desired_spread);%best_spreadΪ������֤�õ�����ѹ⻬����
disp(['���spreadֵΪ',num2str(best_spread)])

%% ������ѷ�������GRNN����

[inputn,inputps]=mapminmax(input_train',-1,1);%ѵ�����ݵ��������ݵĹ�һ��
inputn_test=mapminmax('apply',input_test',inputps);
[outputn,outputps]=mapminmax(output_train',-1,1);%ѵ�����ݵ�������ݵĹ�һ��de
putputn_test=mapminmax('apply',output_test',outputps);
%spread=0.02;
net=newgrnn(inputn,outputn,best_spread);
grnn_prediction_result=sim(net,inputn_test);
grnn_output=mapminmax('reverse',grnn_prediction_result,outputps);
grnn_error=output_test-grnn_output';
disp(['GRNN������Ԥ��ľ������Ϊ',num2str(mse(grnn_error))])
figure
plot(grnn_output,'k-*')%ͼ1
hold on
plot(output_test','r-o')
hold off
xlabel('��������')
ylabel('p3')
legend('����������Ԥ��ֵ','ʵ��ֵ')
figure
plot(output_test,grnn_output,'*')%ͼ2
xlabel('ʵ��ֵ')
ylabel('Ԥ��ֵ')
figure
 plot(grnn_error,'k-*')%ͼ3
 ylabel('���')
