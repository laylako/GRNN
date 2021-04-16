 %�ӳ�������Ⱥѡ��������������ƴ洢Ϊ selection.m 
function selectParent=selection(population,cumulativeProb)
    for i=1:2      
        r=rand;
         suijishugailv=cumulativeProb-r;
         j=1;
         while suijishugailv(j)<0          
            j=j+1;
         end 
         selectParent(i)=j;
    end 
end