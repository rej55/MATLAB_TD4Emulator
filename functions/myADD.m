function [Out, CFlag] = myADD(In1, In2)
    dIn1 = bi2de(In1);
    dIn2 = bi2de(In2);
    dOut = dIn1 + dIn2;
    if(dOut >= 2^length(In1))
        CFlag = 1;
        tmpOut = de2bi(dOut);
        Out = tmpOut(1:length(In1));
    else
        CFlag = 0;
        Out = de2bi(dOut, 4);
    end
end