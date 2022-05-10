function [SN,  pn_ids] = priority_nodes_selection(SN, ms_ids, model, past_data_considered)
%PRIORITY_NODES_SELECTION Summary of this function goes here
%   Detailed explanation goes here

model_x = model("model_x");
model_y = model("model_y");

pn_ids = zeros( 1, length(unique([SN.n.cluster])) );
clusters = unique([SN.n.cluster]);

for cluster = clusters(~isnan(clusters))
    
    node_ids = []; % Node ID
    min_dists = []; % A nodes shortest distance to a predicted path
    
    % Predict the next node positions
    new_pos_x = [];
    new_pos_y = [];
    
    count = 0;
    for ms_id = ms_ids
        count = count + 1;
        
        X = SN.n(ms_id).Xs;
        Y = SN.n(ms_id).Ys;
        if (~isempty(X)) && (~isempty(Y))
            if length(X) > past_data_considered && length(Y) > past_data_considered
                X = X(end-past_data_considered:end);
                Y = Y(end-past_data_considered:end);
            end
            new_pos_x(end+1) = predict(model_x, X);
            new_pos_y(end+1) = predict(model_y, Y);
        end
    end
        
    for i=1:length(SN.n)
        if strcmp(SN.n(i).role, 'N') && strcmp(SN.n(i).cond, 'A') && (SN.n(i).cluster == cluster) && (~isnan(cluster)) && ( (~isempty(new_pos_x)) && (~isempty(new_pos_y)) )
            node_ids(end+1) = SN.n(i).id;
            
            % Compute the distance the node to each mobile sink
            dist_to_ms_mat = sqrt( (new_pos_x - SN.n(i).x).^2 + (new_pos_y - SN.n(i).y).^2 );
            
            % Selecting the shortest distance
            min_dists(end+1) = min(dist_to_ms_mat(:));
        end 
    end
    
    [min_dist, J] = min(min_dists(:)); % finds the maximum visits of node by MS
    
    if min_dist > 0
        % To detect is J returns sn empty array
        j_shape = size(J);

        if j_shape(1) > 0
            pn_id = node_ids(J);
            SN.n(pn_id).role = 'P';
            SN.n(pn_id).col = "b"; % node color when plotting
            pn_ids(cluster) = pn_id;

            for i=1:length(SN.n)
                if strcmp(SN.n(i).role, 'N') && (SN.n(i).cluster == cluster)
                    SN.n(i).dnp = sqrt( (SN.n(i).x - SN.n(pn_id).x)^2 + (SN.n(i).y - SN.n(pn_id).y)^2 );
                    SN.n(i).pn_id = pn_id;
                end
            end

            SN.n(pn_id).dnp = 0;
            SN.n(pn_id).pn_id = pn_id;
        end
    end
    
end


end

