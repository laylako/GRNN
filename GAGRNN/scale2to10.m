 %�ӳ��򣺽���������ת��Ϊʮ���������������ƴ洢Ϊ scale2to10.m 
function x=scale2to10(daizhuanpopulation)
    weichang=size(daizhuanpopulation,2);
    x=daizhuanpopulation(weichang);
    for i=1:weichang-1      
        x=x+daizhuanpopulation(weichang-i)*power(2,i);
    end 
end