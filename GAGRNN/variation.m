 %�ӳ�������Ⱥ����������������ƴ洢Ϊ variation.m 
function bianyihouzidai=variation(daibianyizidai,bianyigailv)
    weichang=size(daibianyizidai,2);
    bianyihouzidai=daibianyizidai;
    pmm=isJCBY(bianyigailv);
    if pmm==1      
        chb=round(rand*(weichang-1))+1;
        bianyihouzidai(chb)=abs(daibianyizidai(chb)-1);
    end 
end