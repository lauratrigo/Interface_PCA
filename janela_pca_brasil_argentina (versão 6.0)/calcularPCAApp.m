function [LonG, LatG, Z, lat_pts, lon_pts] = calcularPCAApp(matrix_list, names_master, estacoes_ativas, nEOF, lat, lon)
% calcularPCAApp - calcula PCA e retorna EOF simetrizado pronto para plot

    if isempty(matrix_list)
        error('A matriz de dados fornecida está vazia!');
    end

    % --- ALINHAMENTO DINÂMICO CRÍTICO ---
    % Mapeia as coordenadas (lat/lon) originais para bater com a ordem exata das colunas lidas na matriz
    [~, idx_map] = ismember(estacoes_ativas, names_master);
    
    % Filtra e ordena lat/lon para corresponder perfeitamente às colunas da matrix_list
    valid_idx = idx_map(idx_map > 0);
    lat = lat(valid_idx);
    lon = lon(valid_idx);
    
    % Se o mapeamento reduziu a quantidade, ajustamos a matriz de dados nas colunas correspondentes
    if size(matrix_list, 2) > length(lat)
        matrix_list = matrix_list(:, idx_map > 0);
    end

    % Substituir valores ausentes por 0 (ou ALS se preferir)
    matrix_list(isnan(matrix_list)) = 0; 

    % -------------------------
    % PCA
    % -------------------------
%     [coeff, ~, ~, ~, ~] = pca(matrix_list, 'Algorithm','als', 'Centered', true);
    [coeff, score, latent, tsquared, explained] = pca(matrix_list);
    
    num_componentes = size(coeff, 2);
    if nargin < 4 || isempty(nEOF) || isnan(nEOF) || nEOF < 1 || nEOF > num_componentes
        nEOF = 1; % Força o padrão da primeira componente se houver estouro
    end
    
    eof_val = coeff(:, nEOF);
    
    fprintf('EOF min = %f\n', min(eof_val));
    fprintf('EOF max = %f\n', max(eof_val));
    fprintf('EOF mean = %f\n', mean(eof_val));

    figure;
    scatter(lon,lat,80,eof_val,'filled');
    colorbar;
    title('EOF antes da interpolacao');
    
    disp(size(coeff))
    disp(length(lat))
    disp(length(lon))
    disp(size(matrix_list))

    % Guarda os pontos reais utilizados
    lat_pts = lat;
    lon_pts = lon;

    % -------------------------
    % Simetrização Geográfica
    % -------------------------
    lat_all = [lat; lat; abs(lat); abs(lat); lat; abs(lat)+2*min(lat); abs(lat)+2*min(lat); abs(lat); abs(lat)+2*min(lat)];
    lon_all = [lon; abs(lon)+2*max(lon); lon; abs(lon)+2*max(lon); abs(lon)+2*min(lon); lon; abs(lon)+2*max(lon); abs(lon)+2*min(lon); abs(lon)+2*min(lon)];
%     eof_all = [eof_val; -eof_val; eof_val; -eof_val; -eof_val; eof_val; -eof_val; -eof_val; eof_val];
    eof_all = [eof_val;
               eof_val;
               eof_val;
               eof_val;
               eof_val;
               eof_val;
               eof_val;
               eof_val;
               eof_val];

    % -------------------------
    % Interpolação (Grid)
    % -------------------------
%     r_lon = min(lon_all):0.5:max(lon_all);
%     r_lat = min(lat_all):0.5:max(lat_all);
%     [LonG, LatG] = meshgrid(r_lon, r_lat);
    lon_vec = linspace(min(lon_all)-1, max(lon_all)+1, 400);
    lat_vec = linspace(min(lat_all)-1, max(lat_all)+1, 400);

    [LonG, LatG] = meshgrid(lon_vec, lat_vec);
    
%     Z = griddata(lon_all, lat_all, eof_all, LonG, LatG, 'v4');
    Z = griddata(lon_all, lat_all, eof_all, LonG, LatG, 'natural');
end