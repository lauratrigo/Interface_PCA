function [LonG, LatG, Z, lat_pts, lon_pts] = calcularPCA_Instante(matrix_list, names_master, estacoes_ativas, lat, lon, linha_exata)
    
    % --- 1. ALINHAMENTO DAS ESTAÇÕES ---
    [~, idx_map] = ismember(estacoes_ativas, names_master);
    valid_idx = idx_map(idx_map > 0);
    lat_pts = lat(valid_idx);
    lon_pts = lon(valid_idx);
    
    if size(matrix_list, 2) > length(lat_pts)
        matrix_list = matrix_list(:, idx_map > 0);
    end
    matrix_list(isnan(matrix_list)) = 0; 

    % --- 2. EXECUTA O PCA NA MATRIZ TODA ---
    % É necessário rodar em tudo para achar o padrão global verdadeiro
    [coeff, score, ~, ~, ~] = pca(matrix_list);

    % --- 3. O PULO DO GATO: RECONSTRUÇÃO DO INSTANTE ---
    % Multiplica o padrão espacial (EOF 1) pela amplitude temporal (Score 1) do minuto exato
    amplitude_no_minuto = score(linha_exata, 1);
    padrao_espacial = coeff(:, 1);
    
    z_pca_instante = amplitude_no_minuto .* padrao_espacial;

    % --- 4. SIMETRIZAÇÃO GEOGRÁFICA ---
    lat_all = [lat_pts; lat_pts; abs(lat_pts); abs(lat_pts); lat_pts; abs(lat_pts)+2*min(lat_pts); abs(lat_pts)+2*min(lat_pts); abs(lat_pts); abs(lat_pts)+2*min(lat_pts)];
    lon_all = [lon_pts; abs(lon_pts)+2*max(lon_pts); lon_pts; abs(lon_pts)+2*max(lon_pts); abs(lon_pts)+2*min(lon_pts); lon_pts; abs(lon_pts)+2*max(lon_pts); abs(lon_pts)+2*min(lon_pts); abs(lon_pts)+2*min(lon_pts)];
    
    % Usa o dado filtrado pelo PCA para a simetria
    z_all = [z_pca_instante; z_pca_instante; z_pca_instante; z_pca_instante; z_pca_instante; z_pca_instante; z_pca_instante; z_pca_instante; z_pca_instante];

    % --- 5. INTERPOLAÇÃO (GRID) ---
    [LonG, LatG] = meshgrid(-90:0.5:-30, -60:0.5:15);
    Z = griddata(lon_all, lat_all, z_all, LonG, LatG, 'v4');
end