function [] = feedforwardTEST()
    file = 'Test.csv';
    data = readmatrix(file, "Delimiter", ";", "DecimalSeparator", ".");
    input = data(:, 2:end-1)';
    target = data(:,end)';

    tempoExecucao = tic;

    load('Redes/Rede1.mat');
    net1 = network;
    load('Redes/Rede2.mat');
    net2 = network;
    load('Redes/Rede3.mat');
    net3 = network;

    output1 = sim(net1, input);
    error1 = perform(net1, target, output1);
    r1 = sum(output1 == target);
    precisaoTotal1 = 100*r1/size(target,2);

    output2 = sim(net2, input);
    error2 = perform(net2, target, output2);
    r2 = sum(output2 == target);
    precisaoTotal2 = 100*r2/size(target,2);

    output3 = sim(net3, input);
    error3 = perform(net3, target, output3);
    r3 = sum(output3 == target);
    precisaoTotal3 = 100*r3/size(target,2);

    disp('Precisão total Rede 1:');
    disp(precisaoTotal1);
    disp('Erro Rede 1:');
    disp(error1);

    disp('Precisão total Rede 2:');
    disp(precisaoTotal2);
    disp('Erro Rede 2:');
    disp(error2);

    disp('Precisão total Rede 3:');
    disp(precisaoTotal3);
    disp('Erro Rede 3:');
    disp(error3);

    tempo = toc(tempoExecucao);
    disp('Tempo de execução:');
    disp(tempo);
end
