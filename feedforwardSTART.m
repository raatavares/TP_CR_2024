function [] = feedfowardSTART()

    % Inicia a contagem do tempo de execução
    executionTime = tic;
    
    % Lê os dados do arquivo Start.csv
    filename = 'Start.csv';
    dataset = readmatrix(filename, 'Delimiter', ';', 'DecimalSeparator', '.');

    % Separa os dados de entrada e alvo
    inputData = dataset(:, 2:end-1)';
    targetData = dataset(:, end)';

    % Define o número de iterações
    iterations = 20;

    % Inicializa as variáveis para armazenar a precisão total e o erro total
    totalAccuracy = [];
    totalError = 0;

    % Loop para treinar e testar a rede neural
    for i = 1 : iterations
        % Cria uma nova rede neural
        neuralNet = feedforwardnet(10);
        
        % Desativa a divisão de dados
        neuralNet.divideFcn = ''; 

        % Define a função de treinamento
        neuralNet.trainFcn = 'trainlm';
        
        % Desativa a janela de exibição durante o treinamento
        neuralNet.trainParam.showWindow = 0;

        % Define as funções de ativação para as camadas
        neuralNet.layers{1}.transferFcn = 'logsig';
        neuralNet.layers{2}.transferFcn = 'purelin';

        % Treina a rede neural com os dados de entrada e alvo
        neuralNet = train(neuralNet, inputData, targetData);

        % Testa a rede neural com os dados de entrada
        outputData = sim(neuralNet, inputData);
        
        % Converte a saída para valores booleanos
        outputData = (outputData >= 0.5);

        % Calcula o erro da iteração
        iterationError = perform(neuralNet, targetData, outputData);

        % Calcula a precisão da iteração
        r = sum(outputData == targetData);
        accuracy = 100*r/size(targetData,2);
        
        % Adiciona a precisão da iteração à precisão total
        totalAccuracy = [totalAccuracy accuracy];

        % Adiciona o erro da iteração ao erro total
        totalError = totalError + iterationError;
    end

    % Calcula a precisão e o erro médios
    totalAccuracy = mean(totalAccuracy);
    totalError = totalError/iterations;

    % Exibe a precisão total, o erro total e o tempo de execução
    disp('Precisão total:');
    disp(totalAccuracy);
    disp('Erro:');
    disp(totalError);
    disp('Tempo de execução:');
    disp(toc(executionTime));
end