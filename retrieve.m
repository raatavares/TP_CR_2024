function [retrieved_indexes, similarities, new_case] = retrieve(case_library, new_case, threshold)
    
    % Pesos para os atributos
    weighting_factors = [3 5 2 2 1 3 5 2];

    % Similaridades pré-definidas para os atributos categóricos
    smoking_status_sim = get_smoking_status_similarities();
    residence_type_sim = get_residence_type_similarities();
    gender_sim = get_gender_similarities();
    ever_married_sim = get_ever_married_similarities();
    
    % Obter os valores máximos para normalização
    max_values = get_max_values(case_library);
    
    % Inicializar vetores de índices e similaridades
    retrieved_indexes = [];
    similarities = []; % Pré-alocação
    
    % Iterar sobre cada caso na biblioteca
    for i = 1:size(case_library, 1)
        
        % Calcular distâncias para cada atributo
        distances = zeros(1, 8); % Considerando que há 8 atributos no dataset
        
        % Calcular distância para atributos categóricos
        smoking_distances = calculate_local_distance(smoking_status_sim, case_library{i, 'smoking_status'}, new_case.smoking_status);
        residence_distances = calculate_local_distance(residence_type_sim, case_library{i, 'Residence_type'}, new_case.Residence_type);
        gender_distances = calculate_local_distance(gender_sim, case_library{i, 'gender'}, new_case.gender);
        married_distances = calculate_local_distance(ever_married_sim, case_library{i, 'ever_married'}, new_case.ever_married);
        
        % Armazenar distâncias em distances
        distances(1:numel(smoking_distances)) = smoking_distances;
        distances(2:numel(residence_distances)+1) = residence_distances;
        distances(3:numel(gender_distances)+2) = gender_distances;
        distances(4:numel(married_distances)+3) = married_distances;
        
        % Calcular distância para atributos numéricos
        distances(5) = calculate_euclidean_distance(case_library{i, 'age'} / max_values('age'), ... 
                                    new_case.age / max_values('age'));
        distances(6) = calculate_euclidean_distance(case_library{i, 'avg_glucose_level'} / max_values('avg_glucose_level'), ... 
                                    new_case.avg_glucose_level / max_values('avg_glucose_level'));
        distances(7) = calculate_euclidean_distance(case_library{i, 'bmi'} / max_values('bmi'), ... 
                                    new_case.bmi / max_values('bmi'));
        
        % Calcular distância para o atributo alvo
        distances(8) = calculate_linear_distance(case_library{i, 'stroke'}, new_case.stroke); 
        
        % Normalizar pesos removendo aqueles atributos que não estão presentes no novo caso
        to_remove = isnan(distances);
        weighting_factors(to_remove) = [];
        distances(to_remove) = [];
        
        % Calcular similaridade global
        DG = (distances .* weighting_factors') / sum(weighting_factors);
        final_similarity = 1 - DG;
        
        % Verificar se a similaridade atende ao limiar e adicionar ao resultado
        if final_similarity >= threshold
            retrieved_indexes = [retrieved_indexes; i];
            similarities = [similarities final_similarity]; % Armazenar na posição correta
        end
        
        fprintf('Case %d out of %d has a similarity of %.2f%%...\n', i, size(case_library, 1), final_similarity * 100);
    end
end

function [smoking_distances] = calculate_local_distance(smoking_status_sim, case_smoking_status, new_smoking_status)
    % Encontrar os índices das categorias
    index1 = find(smoking_status_sim.categories == case_smoking_status);
    index2 = find(smoking_status_sim.categories == new_smoking_status);
    
    % Obter as similaridades correspondentes
    similarity_matrix = smoking_status_sim.similarities;
    smoking_distances = 1 - similarity_matrix(index1, index2);
end

function distance = calculate_euclidean_distance(point1, point2)
    % Calcula a distância euclidiana entre dois pontos
    distance = sqrt(sum((point1 - point2).^2));
end

function distance = calculate_linear_distance(value1, value2)
    % Calcula a distância linear entre dois valores
    distance = abs(value1 - value2);
end

function [max_values] = get_max_values(case_library)

    % Obter os valores máximos para normalização dos atributos numéricos
    max_age = max(case_library.age);
    max_avg_glucose_level = max(case_library.avg_glucose_level);
    max_bmi = max(case_library.bmi);
    
    % Criar um mapa para armazenar os valores máximos
    max_values = containers.Map;
    max_values('age') = max_age;
    max_values('avg_glucose_level') = max_avg_glucose_level;
    max_values('bmi') = max_bmi;
end



function [smoking_status_sim] = get_smoking_status_similarities()

    % Definir as categorias de status de fumante
    smoking_status_categories = {'never smoked', 'formerly smoked', 'smokes', 'Unknown'};
    
    % Definir as similaridades entre os status de fumante
    smoking_status_similarities = [
        1.0, 0.4, 0.2, 0.3;  % never smoked
        0.4, 1.0, 0.1, 0.2;  % formerly smoked
        0.2, 0.1, 1.0, 0.3;  % smokes
        0.3, 0.2, 0.3, 1.0   % Unknown
    ];
    
    % Estrutura para armazenar as categorias e similaridades
    smoking_status_sim.categories = categorical(smoking_status_categories);
    smoking_status_sim.similarities = smoking_status_similarities;
end


function [residence_type_sim] = get_residence_type_similarities()

    % Definir as categorias de tipo de residência
    residence_type_categories = {'Rural', 'Urban'};
    
    % Definir as similaridades entre os tipos de residência
    residence_type_similarities = [
        1.0, 0.5;  % Rural
        0.5, 1.0   % Urban
    ];
    
    % Estrutura para armazenar as categorias e similaridades
    residence_type_sim.categories = categorical(residence_type_categories);
    residence_type_sim.similarities = residence_type_similarities;
end

function [gender_sim] = get_gender_similarities()

    % Definir as categorias de gênero
    gender_categories = {'Male', 'Female'};
    
    % Definir as similaridades entre os gêneros
    gender_similarities = [
        1.0, 0.2;  % Male
        0.2, 1.0   % Female
    ];
    
    % Estrutura para armazenar as categorias e similaridades
    gender_sim.categories = categorical(gender_categories);
    gender_sim.similarities = gender_similarities;
end

function [ever_married_sim] = get_ever_married_similarities()

    % Definir as categorias de estado civil
    ever_married_categories = {'no', 'yes'};
    
    % Definir as similaridades entre os estados civis
    ever_married_similarities = [
        1.0, 0.2;  % no
        0.2, 1.0   % yes
    ];
    
    % Estrutura para armazenar as categorias e similaridades
    ever_married_sim.categories = categorical(ever_married_categories);
    ever_married_sim.similarities = ever_married_similarities;
end
