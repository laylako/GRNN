 %�ӳ����ж��Ŵ������Ƿ���Ҫ���н������죬�������ƴ洢Ϊ isJCBY.m 
function pcc=isJCBY(BYhuoJCgailv)%BYhuoJCgailv����򽻲����
    test(1:100)=0;
    l=round(100*BYhuoJCgailv);
    test(1:l)=1;
    n=round(rand*99)+1;
    pcc=test(n);
end