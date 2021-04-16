%���������Ŵ��㷨��� GRNN �⻬���ӵ�����ֵ 
clc;
clear all
close all
nntwarn off;
clear global  var
global weichang 
global domainmin 
global domainmax 
global num1
global num2
desired_spread=[];%�����⻬���ӵ�ȡֵ

num0 = xlsread('total460.csv');
num00=num0;
%total=10*floor(length(num0)/10);
indices = crossvalind('Kfold',460,10);
indices = indices';
for i = 1:5
test = (indices == i); train = ~test;
num1 = num00(train,:);
num2 = num00(test,:);
zhiyu=[0.0001 1];
jingdu=0.0001;
domainmin=zhiyu(:,1);
domainmax=zhiyu(:,2);
weichang=ceil(log2((domainmax-domainmin)'./jingdu));
populationguimo=20;
zuidadaishu=20;
jiaochagailv=0.80;
bianyigailv=0.10;

population=round(rand(populationguimo,weichang));%������Ⱥpopulation20*14
[shiyingdu,cumulativeProb]=fitness(population);%shiyingdu1*20 cumulativeProb20*1
[dangdaiZDSYD,dangdaiZDSYDgtbh]=max(shiyingdu);%����������öȣ�����������ö��к�
[dangdaiZXSYD,dangdaiZXSYDgtbh]=min(shiyingdu);%������С���öȣ�������С���ö��к�
daishu=1;
  while daishu<zuidadaishu+1     
	  for j=1:2:populationguimo         
		selectParent=selection(population,cumulativeProb);%ѡ��selectParent=1*2
        crossProgeny=cross(population,selectParent,jiaochagailv);%����
        crossProgenyxin(j,:)=crossProgeny(1,:);
        crossProgenyxin(j+1,:)=crossProgeny(2,:);
        bianyizidaixin(j,:)=variation(crossProgenyxin(j,:),bianyigailv);%����
        bianyizidaixin(j+1,:)=variation(crossProgenyxin(j+1,:),bianyigailv);
      end 
    population=bianyizidaixin;%������Ⱥ
    [shiyingdu,cumulativeProb]=fitness(population);%�ٵ����öȺ���
    [newdangdaiZDSYD,newdangdaiZDSYDgtbh]=max(shiyingdu);%����������öȣ�����������ö��к�
    [newdangdaiZXSYD,newdangdaiZXSYDgtbh]=min(shiyingdu);%������С���öȣ�������С���ö��к�
      if dangdaiZDSYD<newdangdaiZDSYD
        dangdaiZDSYD=newdangdaiZDSYD;
        bestgeti(1,:)=population(newdangdaiZDSYDgtbh,:);
        population(dangdaiZXSYDgtbh,:)=bestgeti(1,:);
      end
      dangdaiZXSYDgtbh=newdangdaiZXSYDgtbh;
      dangdaiPJSYD=mean(shiyingdu);%����ƽ�����ö�
      ymax(daishu)=dangdaiZDSYD;%ÿ��������ö�1*12
      ymean(daishu)=dangdaiPJSYD;%ÿ��ƽ�����ö�1*12
    
      x=scale2to10(population(dangdaiZDSYDgtbh,:));%����Ⱥ��������öȵĸ���תΪʮ����
      xx=domainmin+x*(domainmax-domainmin)/(power(2,weichang)-1);%������ÿ���Ĺ⻬����
      xmax(daishu)=xx;%��ÿ���Ĺ⻬����1*12
      daishu=daishu+1;
  end 
daishu=daishu-1;
ZDSYD=max(ymax);
besti_spread=xx;%��Ѹ��壬spread?
desired_spread=[desired_spread besti_spread];
disp(['��',num2str(i),'�ν�����֤���spreadֵΪ',num2str(besti_spread)])
disp(['��',num2str(i),'�ν�����֤��СMSEΪ',num2str(1/(2000*ZDSYD))])
end
best_spread=mean(desired_spread);%best_spreadΪ������֤�õ�����ѹ⻬����
disp(['-----------------------------------------'])
disp(['���spreadֵΪ',num2str(best_spread)])
%zuidashiyingdu=objective(xx);%������ö�
%figure(1);
%quxian1=plot(1:daishu,ymax);
%set(quxian1,'linestyle','-','linewidth',1.8,'marker','*','markersize',6);
%hold on;
%quxian2=plot(1:daishu,ymean);
%set(quxian2,'color','r','linestyle','-','linewidth',1.8,'marker','h','markersize',6);
%xlabel('��������');
%ylabel('���/ƽ����Ӧ��');
%xlim([1 zuidadaishu]);
%legend('�����Ӧ��','ƽ����Ӧ��');%ͼ��
box off;
hold off;

 
