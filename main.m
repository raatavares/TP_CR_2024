function [] = main()

    similarity_threshold = 0.9;
    
    % Ler os dados do arquivo CSV
    case_library = readtable('Train.csv');
    
    % Definir os nomes das variáveis manualmente
    variableNames = {'id', 'gender', 'age', 'hypertension', 'heart_disease', 'ever_married', 'Residence_type', 'avg_glucose_level', 'bmi', 'smoking_status', 'stroke'};
    
    % Renomear as colunas
    case_library.Properties.VariableNames = variableNames;
    
    fprintf('\nStarting retrieve phase...\n\n');
    
    % New case data
    new_case.id = 12345; % Altere o ID conforme necessário
    new_case.gender = 'Female';
    new_case.age = 50;
    new_case.hypertension = 1; % 1 indica sim, 0 indica não
    new_case.heart_disease = 0; % 1 indica sim, 0 indica não
    new_case.ever_married = 'yes';
    new_case.Residence_type = 'Urban';
    new_case.avg_glucose_level = 100;
    new_case.bmi = 25;
    new_case.smoking_status = 'formerly smoked';
    new_case.stroke = 0; % 1 indica sim, 0 indica não
    
    [retrieved_indexes, similarities, new_case] = retrieve(case_library, new_case, similarity_threshold);
    
    retrieved_cases = case_library(retrieved_indexes, :);
    
    retrieved_cases.Similarity = similarities';

    fprintf('\nRetrieve phase completed...\n\n');
end