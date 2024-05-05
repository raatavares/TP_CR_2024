function [] = cbr()

    similarityThreshold = 1;
    
    formatSpec = '%f%f%f%f%f%f%f%f%f%f%f';
    caseLibrary = readtable('Train.csv', 'Delimiter', ',', 'Format', formatSpec);

    % Guardando os casos com NaN
    nanCases = caseLibrary(isnan(caseLibrary{:, 11}), :);
    
    disp('Casos com NaN:');
    disp(nanCases);

    % Removendo os casos com NaN
    caseLibrary = caseLibrary(~isnan(caseLibrary{:, 11}), :);

    % iteratar sobre os casosNaN, prenchere valores stroke com o valore mais provavel

    for i = 1:size(nanCases, 1)
       
        [caseIndexes, caseSimilarities, nanCases(i, :)] = retrieve(caseLibrary, nanCases(i, :), similarityThreshold);

        % Caso o set de indexes esteja vazio

        if isempty(caseIndexes)
            while isempty(caseIndexes)
                similarityThreshold = similarityThreshold - 0.01;
                [caseIndexes, caseSimilarities, nanCases(i, :)] = retrieve(caseLibrary, nanCases(i, :), similarityThreshold);
            end
        end

        similarCases = caseLibrary(caseIndexes, :);
        similarCases.similarity = caseSimilarities';
        % Preenchendo os valores NaN atravez da media dos valores mais proximos

        nanCases{i, 11} = mode(similarCases.stroke);

        caseLibrary = [caseLibrary; nanCases(i, :)];

    end
    
    % sorteando por id
    caseLibrary = sortrows(caseLibrary, 1);

    disp('Biblioteca atualizada:');
    disp(caseLibrary);

    % Guarda tabela em .csv outravez

    writetable(caseLibrary, 'TrainPrep.csv', 'Delimiter', ';');

end