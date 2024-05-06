function [] = feedforwardTeste()

    % Obtem dados do TrainFiltered.csv
    file = 'Test.csv';
    data = readmatrix(file, "Delimiter", ";", "DecimalSeparator", ".");
    
    input = data(:, 2:end-1)';
    target = data(:,end)';
    
    tempoExecucao = tic;
    
    % Inicializa a rede
    load(Rede1.mat); % meter o nome da rede a testar 
    
    % Testa a rede
    output = sim(net, input);
    error = perform(net, target, output);
    
    r = sum(output == target);
    precisaoTotal = 100*r/size(target,2);
    
    disp('Precisão total:');
    disp(precisaoTotal);
    
    disp('Erro:');
    disp(error);
    
    tempo = toc(tempoExecucao);
    disp('Tempo de execução:');
    disp(tempo);
    
    
    end

