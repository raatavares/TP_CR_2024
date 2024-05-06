function [totalAccuracy, testAccuracy, timeElapsed] = feedforwardTRAIN(layerNeurons,epochs,trainFunc,divFunc,evalFunc,trainRatio,valRatio,testRatio)

% Lê os dados do arquivo TrainPrep.csv
dataMatrix = readmatrix('TrainPrep.csv',"Delimiter", ";", "DecimalSeparator", ".");
inputData = dataMatrix(:, 2:end-1)';
targetData = dataMatrix(:,end)'; 

% Inicia a contagem do tempo para calcular o tempo de execução
executionTime = tic;
totalAccuracy = [];
testAccuracy = [];
iterations = 20;

% Cria uma estrutura para armazenar as três redes com maior precisão
bestNetworks = struct('network', {}, 'accuracy', {});

for k=1 : iterations
    % Cria uma nova rede neural
    fprintf('Iteration %d\n', k);
    network = feedforwardnet(layerNeurons);
    network.trainFcn = trainFunc;
    
    % Configura a divisão dos dados se a função de divisão for fornecida
    if ~isempty(divFunc)
        network.divideFcn = divFunc;
        network.divideParam.trainRatio = trainRatio;
        network.divideParam.valRatio = valRatio;
        network.divideParam.testRatio = testRatio;
    else
        network.divideParam = '';
    end
    
    network.trainParam.epochs = epochs;
    network.trainParam.showWindow=0;
    
    for i = 1:length(layerNeurons)+1
        network.layers{i}.transferFcn = evalFunc{i};
    end
    
    % Treina a rede neural com os dados de entrada e alvo
    [network,tr] = train(network, inputData, targetData);
    
    % Testa a rede neural com os dados de entrada
    outputData = sim(network, inputData);
    
    outputData = (outputData >= 0.5);
    
    error = perform(network, targetData, outputData);
    
    accuracy=0;
    
    r = sum(outputData == targetData);
    
    accuracy = 100*r/size(targetData,2);
    
    totalAccuracy = [totalAccuracy accuracy];
    
    % Adiciona a rede e a sua precisão à estrutura
    bestNetworks(end+1) = struct('network', network, 'accuracy', accuracy);
    
    % Conjunto de teste
    testInput = inputData(:, tr.testInd);
    testTarget = targetData(:, tr.testInd);
    
    outputData = sim(network, testInput);
    
    outputData = (outputData >= 0.5);
    
    r = sum(outputData == testTarget);
    
    accuracy = 100*r/size(testTarget,2);
    
    testAccuracy = [testAccuracy accuracy];
    
end

% Usa a função saveBestNetworks para guardar as melhores redes
saveBestNetworks(bestNetworks);

totalAccuracy = mean(totalAccuracy);
testAccuracy = mean(testAccuracy);
disp('Melhor precisão global:' );
disp(max([bestNetworks.accuracy]));
timeElapsed = toc(executionTime);

% Mostra totalAccuracy, testAccuracy e timeElapsed
disp('Precisão global média:');
disp(totalAccuracy);
disp('Precisão de teste média:');
disp(testAccuracy);
disp('Tempo de execução:');
disp(timeElapsed);

end


function saveBestNetworks(bestNetworks)
    % Ordena a estrutura em ordem decrescente de precisão
    bestNetworks = sortStruct(bestNetworks, 'accuracy', 'descend');

    % Guarda as três melhores redes
    for i = 1:min(3, length(bestNetworks))
        network = bestNetworks(i).network;
        save(['Rede' num2str(i)  '.mat'], 'network');
    end
end

% Função auxiliar para ordenar uma estrutura
function s = sortStruct(s, field, direction)
    [~, ind] = sort([s.(field)], direction);
    s = s(ind);
end