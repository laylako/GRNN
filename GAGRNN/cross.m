 %�ӳ�������Ⱥ����������������ƴ洢Ϊ cross.m 
function crossProgeny=cross(population,selectParent,pc)%pc�������
    weichang=size(population,2);
    pcc=isJCBY(pc);%�Ƿ񽻲����
    if pcc==1      
        chb=round(rand*(weichang-2))+1;
        crossProgeny(1,:)=[population(selectParent(1),1:chb) population(selectParent(2),chb+1:weichang)]; %����Ϊ��һ�д����벿��      
        crossProgeny(2,:)=[population(selectParent(2),1:chb) population(selectParent(1),chb+1:weichang)]; %����Ϊ��һ�д����벿�� 
    else      	
        crossProgeny(1,:)=population(selectParent(1),:);
        crossProgeny(2,:)=population(selectParent(2),:);
    end
end