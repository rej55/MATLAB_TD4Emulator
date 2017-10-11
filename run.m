%% Initialize
clear
addpath('./functions');

%% Memory Allocation
ProgramMemory = zeros(16, 8);
SetProgramMemory;
Register = zeros(2, 4);
CarryFlag = 0;
InputPort = zeros(1, 4);
OutputPort = zeros(1, 4);

%% Emulation
i = 1;
while (i <= length(ProgramMemory))
    ImData = ProgramMemory(i, 1:4);
    Operation = ProgramMemory(i, 5:8);
    if(all(Operation==[1 1 1 1])) % JMP
        i = bi2de(ImData); 
    elseif(all(Operation==[0 1 1 1])) % JNC
        if(CarryFlag == 1)
            i = bi2de(ImData);
        end
    elseif(all(Operation==[1 0 0 1])) % OUT B
        OutputPort = Register(2, :);
    elseif(all(Operation==[1 1 0 1])) % OUT Im
        OutputPort = ImData;
    elseif(all(Operation(1:2)==[0 0])) % ADD
        k = bi2de(Operation(3:4)) + 1;
        [Register(k, :), CarryFlag] = myADD(Register(k, :), ImData);
    elseif(all(Operation(1:2)==[1 1])) % MOV Im
        k = bi2de(Operation(3:4)) + 1;
        Register(k, :) = ImData;
    elseif(all(Operation(1:2)==[1 0])) % MOV A, MOV B
        k = bi2de(Operation(3:4)) + 1;
        if(k == 1)
            Register(1, :) = Register(2, :);
        else
            Register(2, :) = Register(1, :);
        end
    elseif(all(Operation(1:2)==[0 1])) % IN
        k = bi2de(Operation(3:4)) + 1;
        Register(k, :) = InputPort;
    else
        disp('Error!');
        break;
    end
    disp(['i = ' num2str(i, '%02d') ': RegisterA = ' num2str(Register(1, :)) ', RegisterB = ' num2str(Register(2, :)) ', CarryFlag = ' num2str(CarryFlag)]);
    i = i + 1;
end