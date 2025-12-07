% test_basic.m - базовый тест для проекта 
function test_basic
    fprintf('====================================\n');
    fprintf('Запуск базового теста ...\n');
    fprintf('====================================\n\n');
    
    % Сохраняем текущую папку
    originalDir = pwd;
    
    try
        % Определяем корневую папку проекта
        testPath = mfilename('fullpath');
        [testsDir, ~, ~] = fileparts(testPath);
        projectRoot = fileparts(testsDir);  % На уровень выше tests
        
        fprintf('Корневая папка проекта: %s\n', projectRoot);
        fprintf('Текущая папка теста: %s\n', testsDir);
        
        % Переходим в корневую папку проекта
        cd(projectRoot);
        fprintf('Перешли в корень проекта: %s\n', pwd);
        
        % Проверяем наличие startup.m в utils
        utilsPath = fullfile(projectRoot, 'src');
        startupPath = fullfile(utilsPath, 'Motor_parametrs.m');
        
        fprintf('Ищем Motor_parametrs.m по пути: %s\n', startupPath);
        
        if exist(startupPath, 'file')
            fprintf('Motor_parametrs.m, запускаем...\n');
            % Переходим в utils и запускаем startup
            cd(utilsPath);
            Motor_parametrs;
            cd(projectRoot);  % Возвращаемся в корень проекта
        else
            % Показываем содержимое папки utils для отладки
            fprintf('Содержимое папки src:\n');
            if exist(utilsPath, 'dir')
                dir(utilsPath);
            else
                fprintf('Папка src не существует!\n');
            end
            error('Файл Motor_parametrs.m не найден в папке src!');
        end
        
        % Проверяем, что переменные определены
        vars = {'Pn', 'Nn', 'Un', 'In', 'Ra', 'Im'};
        missingVars = {};
        for i = 1:length(vars)
            if ~exist(vars{i}, 'var')
                missingVars{end+1} = vars{i};
            end
        end
        
        if ~isempty(missingVars)
            error('Переменные не определены: %s', strjoin(missingVars, ', '));
        end
        
        fprintf('✓ Все параметры определены\n');
        fprintf('  Pn=%.2f, Nn=%.2f, Un=%.2f, In=%.2f, Ra=%.2f, Im=%.6f\n', ...
                Pn, Nn, Un, In, Ra, Im);
        catch ME
        % Возвращаемся в исходную папку при ошибке
        cd(originalDir);
        fprintf('✗ Ошибка в тесте: %s\n', ME.message);
        fprintf('  Идентификатор: %s\n', ME.identifier);
        rethrow(ME);
    end
    
    % Возвращаемся в исходную папку
    cd(originalDir);
    
    fprintf('\n====================================\n');
    fprintf('Тест завершен\n');
    fprintf('====================================\n');
end