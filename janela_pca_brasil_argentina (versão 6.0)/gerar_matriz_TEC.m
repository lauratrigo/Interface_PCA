%  function [matriz, siglas_lidas] = gerar_matriz_TEC(pasta, dias_escolhidos, estacoes_ref, ano_alvo)
%     
%     if ~isfolder(pasta), error('A pasta selecionada não existe.'); end
% 
%     ano_str = num2str(ano_alvo);
%     filtro = fullfile(pasta, ['*', ano_str, '*.txt']);
%     files_struct = dir(filtro);
%     
%     if isempty(files_struct), error('Não foram encontrados arquivos para o ano %s.', ano_str); end
%     
%     files = {files_struct.name};
%     horas_por_dia = 1440;
%     
%     % --- MELHORIA 1: PRÉ-ALOCAÇÃO ---
%     % Calculamos o tamanho total antes de começar o loop
%     num_dias = length(dias_escolhidos);
%     num_estacoes_possiveis = length(files);
%     temp_matriz = NaN(num_dias * horas_por_dia, num_estacoes_possiveis); 
%     nomes_lidos = strings(num_estacoes_possiveis, 1);
%     coluna_atual = 0;
%  
%     for i = 1:num_estacoes_possiveis
%         nomeArquivo = files{i};
%         sigla = extractBefore(nomeArquivo, '-');
%         
%         if ismember(sigla, estacoes_ref)
%             arquivoCompleto = fullfile(pasta, nomeArquivo);
%             fid = fopen(arquivoCompleto,'rt');
%             if fid == -1, continue; end
%             
%             % --- MELHORIA 2: LEITURA MAIS RÁPIDA ---
%             raw = textscan(fid,'%s','Delimiter','\n','HeaderLines',1);
%             fclose(fid);
% 
%             txt = strrep(raw{1}, ',', '.');
%             txt = strrep(txt, '-999.0', 'NaN');
%             data = cell2mat(cellfun(@str2num, txt, 'UniformOutput', false));
% 
%             media = data(:,1);
%             vtec_raw = data(:, 5:2:end);
%             vtec_data = vtec_raw(:); 
% 
%             media_expand = repmat(media, size(vtec_raw, 2), 1);
%             diffTEC = vtec_data - media_expand;
% 
%             % Seleção dos dias (Vetorizado para ser mais rápido)
%             idx_tempo = [];
%             for d = dias_escolhidos
%                 idx_tempo = [idx_tempo, (d-1)*horas_por_dia + (1:horas_por_dia)];
%             end
% 
%             % Inserção direta na posição correta (sem realocação de memória)
%             coluna_atual = coluna_atual + 1;
%             temp_matriz(:, coluna_atual) = diffTEC(idx_tempo);
%             nomes_lidos(coluna_atual) = sigla;
%         end
%     end
% 
%     % Remove colunas que sobraram da pré-alocação
%     temp_matriz(:, (coluna_atual+1):end) = [];
%     nomes_lidos((coluna_atual+1):end) = [];
% 
%     if isempty(temp_matriz), error('Nenhum arquivo encontrado para os critérios.'); end
% 
%     % --- ALINHAMENTO FINAL ---
%     [presente, localizacao] = ismember(estacoes_ref, nomes_lidos);
%     matriz = temp_matriz(:, localizacao(presente));
%     siglas_lidas = estacoes_ref(presente); 
%  end
function [matriz, siglas_lidas] = gerar_matriz_TEC(pasta, dias_escolhidos, estacoes_ref, ano_alvo)
    
    if ~isfolder(pasta), error('A pasta selecionada não existe.'); end

    % Garante que o ano seja tratado como string de 4 dígitos
    ano_str = num2str(ano_alvo);
    
    % Se os arquivos usam ano com 2 dígitos (ex: "21" em vez de "2021")
    if length(ano_str) == 4
        ano_curto = ano_str(3:4);
    else
        ano_curto = ano_str;
    end

    % Tenta buscar primeiro com 4 dígitos, se não achar tenta com 2
    filtro = fullfile(pasta, ['*', ano_str, '*.txt']);
    files_struct = dir(filtro);
    if isempty(files_struct)
        filtro = fullfile(pasta, ['*', ano_curto, '*.txt']);
        files_struct = dir(filtro);
    end
    
    if isempty(files_struct)
        error('Não foram encontrados arquivos contendo o ano %s ou %s na pasta.', ano_str, ano_curto); 
    end
    
    files = {files_struct.name};
    horas_por_dia = 1440;
    
    % FORÇA PADRONIZAÇÃO: Converte a referência para string array para evitar falhas no ismember
    estacoes_ref = string(estacoes_ref);
    
    num_dias = length(dias_escolhidos);
    num_estacoes_possiveis = length(files);
    temp_matriz = NaN(num_dias * horas_por_dia, num_estacoes_possiveis); 
    nomes_lidos = strings(num_estacoes_possiveis, 1);
    coluna_atual = 0;
 
    for i = 1:num_estacoes_possiveis
        nomeArquivo = files{i};
        
        % Extrai a sigla de forma segura
        if contains(nomeArquivo, '-')
            sigla = extractBefore(nomeArquivo, '-');
        else
            sigla = nomeArquivo(1:4); % Fallback caso não tenha hífen
        end
        
        % Força a sigla virar string limpa e em maiúsculas
        sigla = upper(string(sigla));
        
        % Compara de forma segura (string com string)
        if any(estacoes_ref == sigla)
            arquivoCompleto = fullfile(pasta, nomeArquivo);
            fid = fopen(arquivoCompleto,'rt');
            if fid == -1, continue; end
            
%             raw = textscan(fid,'%s','Delimiter','\\n','HeaderLines',1);
            raw = textscan(fid,'%s','Delimiter','\n','HeaderLines',1);
            fclose(fid);

            if isempty(raw{1}), continue; end

            txt = strrep(raw{1}, ',', '.');
            txt = strrep(txt, '-999.0', 'NaN');
            data = cell2mat(cellfun(@str2num, txt, 'UniformOutput', false));

            if isempty(data), continue; end

            media = data(:,1);
            vtec_raw = data(:, 5:2:end);
            vtec_data = vtec_raw(:); 

            media_expand = repmat(media, size(vtec_raw, 2), 1);
            diffTEC = vtec_data - media_expand;

            idx_tempo = [];
            for d = dias_escolhidos
                idx_tempo = [idx_tempo, (d-1)*horas_por_dia + (1:horas_por_dia)];
            end

            coluna_atual = 1 + coluna_atual;
            temp_matriz(:, coluna_atual) = diffTEC(idx_tempo);
            nomes_lidos(coluna_atual) = sigla;
        end
    end

    % Se nenhuma estação passou pelo filtro, emite um erro explicativo
    if coluna_atual == 0
        error('Os arquivos foram encontrados, mas NENHUMA sigla bateu com as estações de referência do país selecionado.');
    end

    % Corta a matriz no tamanho exato das estações válidas encontradas
    matriz = temp_matriz(:, 1:coluna_atual);
    siglas_lidas = cellstr(nomes_lidos(1:coluna_atual));
end