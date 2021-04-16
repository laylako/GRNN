%�ӳ��򣺼�����Ӧ�Ⱥ������������ƴ洢Ϊ fitness
function[shiyingdu,cumulativeProb]=fitness(population)
    global weichang 
    global domainmin 
    global domainmax 
    populationguimo=size(population,1);
    for i=1:populationguimo      
        x=scale2to10(population(i,:));
        xx=domainmin+x*(domainmax-domainmin)/(power(2,weichang)-1);%2^14,������⻬����
        shiyingdu(i)=objective(xx);%��50����Ӧ��1*50
    end 
    fitnessSum=sum(shiyingdu);%��Ӧ�����
    relFitness=shiyingdu/fitnessSum;%�����Ӧ��1*50
    cumulativeProb(1)=relFitness(1);%�ۼƸ���50*1
    for i=2:populationguimo      
        cumulativeProb(i)=cumulativeProb(i-1)+relFitness(i);
    end 
    cumulativeProb=cumulativeProb';%�ۼƸ���50*1
end