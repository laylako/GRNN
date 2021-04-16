 %�ӳ�����Ӧ�Ⱥ������������ƴ洢Ϊ objective.m����Ԥ�� 2013 ��Ϊ�� 
function y=objective(spread)
   num1 = xlsread('total460.csv');
m=414;
in_train=num1(1:m,1:end-1)';%ѵ�����ݵ���������x1
out_train=num1(1:m,end)';%ѵ�����ݵ��������y1
in_test=num1(m+1:end,1:end-1)';%�������ݵ���������x2
out_test=num1(m+1:end,end)'; %�������ݵ��������y2
[inputn,inputps]=mapminmax(in_train,-1,1);%ѵ�����ݵ��������ݵĹ�һ��
inputn_test=mapminmax('apply',in_test,inputps);
[outputn,outputps]=mapminmax(out_train,-1,1);%ѵ�����ݵ�������ݵĹ�һ��
putputn_test=mapminmax('apply',out_test,outputps);

net=newgrnn(inputn,outputn,spread);
grnn_prediction_result=sim(net,inputn_test);
grnn_output=mapminmax('reverse',grnn_prediction_result,outputps);
grnn_error=out_test-grnn_output;
     % error1=norm(y_xunlian-M_xunlian);%����-ƽ���͵�����ƽ����
    error2=mse(grnn_error);
    y=1/error2;
end