function [caseIndexes, caseSimilarities, inputCase] = retrieve(caseLibrary, inputCase, similarityThreshold)

% 1 - gender
% 2 - age
% 3 - hypertension
% 4 - heart_disease
% 5 - ever_married
% 6 - Residence_type
% 7 - avg_glucose_level
% 8 - bmi
% 9 - smoking_status

% Os pesos para cada fator são definidos
factorWeights = [1 5 5 5 2 1 4 4 5];

% Os valores máximos para cada fator na biblioteca de casos são obtidos
maxValues = get_max_values(caseLibrary);
caseIndexes = [];
caseSimilarities = [];

% Para cada caso na biblioteca de casos é calculada a distância
for i=1:size(caseLibrary,1)
    factorDistances = zeros(1,9);
    
    factorDistances(1,1) = linear_distance(caseLibrary{i,'gender'}/maxValues('gender'),...
        inputCase.gender / maxValues('gender'));
    
    factorDistances(1,2) = linear_distance(caseLibrary{i,'age'}/maxValues('age'),...
        inputCase.age / maxValues('age'));
    
    factorDistances(1,3) = linear_distance(caseLibrary{i,'hypertension'}/maxValues('hypertension'),...
        inputCase.hypertension / maxValues('hypertension'));
    
    factorDistances(1,4) = linear_distance(caseLibrary{i,'heart_disease'}/maxValues('heart_disease'),...
        inputCase.heart_disease / maxValues('heart_disease'));
    
    factorDistances(1,5) = linear_distance(caseLibrary{i,'ever_married'}/maxValues('ever_married'),...
        inputCase.ever_married / maxValues('ever_married'));
    
    factorDistances(1,6) = linear_distance(caseLibrary{i,'Residence_type'}/maxValues('Residence_type'),...
        inputCase.Residence_type / maxValues('Residence_type'));
    
    factorDistances(1,7) = linear_distance(caseLibrary{i,'avg_glucose_level'}/maxValues('avg_glucose_level'),...
        inputCase.avg_glucose_level / maxValues('avg_glucose_level'));
    
    factorDistances(1,8) = linear_distance(caseLibrary{i,'bmi'}/maxValues('bmi'),...
        inputCase.bmi / maxValues('bmi'));
    
    factorDistances(1,9) = smoking_status_distance(caseLibrary{i,'smoking_status'}/maxValues('smoking_status'),...
        inputCase.smoking_status / maxValues('smoking_status'));
    
    DG = (factorDistances * factorWeights')/sum(factorWeights);
    finalSimilarity = 1 - DG;
    
    if finalSimilarity >= similarityThreshold
        caseIndexes = [caseIndexes i];
        caseSimilarities = [caseSimilarities finalSimilarity];
    end
end
end

% A função linear_distance calcula a distância linear entre dois valores
function [distance] = linear_distance(val1,val2)
    distance = sum(abs(val1 - val2));
end

% A função smoking_status_distance calcula a distância para o status de fumante
function [distance] = smoking_status_distance(val1,val2)
if val1 == 3 || val2 == 3
    distance = 4;
else
    distance = abs(val1 - val2);
end
end

% A função get_max_values obtém os valores máximos para cada fator na biblioteca de casos
function [maxValues] = get_max_values(caseLibrary)

key_set = {'gender', 'age', 'hypertension', 'heart_disease', 'ever_married', 'Residence_type', 'avg_glucose_level', 'bmi', 'smoking_status'};
value_set = {max(caseLibrary{:,'gender'}), max(caseLibrary{:,'age'}), max(caseLibrary{:,'hypertension'}), max(caseLibrary{:,'heart_disease'}), max(caseLibrary{:,'ever_married'}), max(caseLibrary{:,'Residence_type'}), max(caseLibrary{:,'avg_glucose_level'}), max(caseLibrary{:,'bmi'}), max(caseLibrary{:,'smoking_status'})};
maxValues = containers.Map(key_set, value_set);
end