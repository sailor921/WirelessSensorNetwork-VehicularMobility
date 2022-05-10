function [SN, ms_ids] = create_vehicular_sinks(SN, dims)
%CREATE_VEHICULAR_SINKS Summary of this function goes here
%   Detailed explanation goes here

%% Building the mobile sinks

if length(SN.n) <= 4
    error('The total number of nodes must be greater than the number of mobile sinks')
end

ms_ids = zeros(1, 4); % Initializing array of mobile sink IDs

for i=1:4
    
    nodes_ids = [];
    dist_to_node = [];
    
    if mod(i, 2) == 0 && i <= 2 
        x = dims('x_min') + 0.5* (dims('x_max')-dims('x_min'));
        
        for j=1:length(SN.n)
            if strcmp(SN.n(j).role, 'N') && SN.n(j).y <= dims('y_min') + 0.5*(dims('y_max')-dims('y_min'))
                nodes_ids(end+1) = SN.n(j).id;
                dist_to_node(end+1) = sqrt( (x - SN.n(j).x)^2 );
            end 
        end 
        
    elseif mod(i, 2) == 0 && i > 2
        x = dims('x_min') + 0.5* (dims('x_max')-dims('x_min'));
        
        for j=1:length(SN.n)
            if strcmp(SN.n(j).role, 'N') && SN.n(j).y >= dims('y_min') + 0.5*(dims('y_max')-dims('y_min'))
                nodes_ids(end+1) = SN.n(j).id;
                dist_to_node(end+1) = sqrt( (x - SN.n(j).x)^2 );
            end 
        end 
    
    elseif mod(i, 2) == 1 && i <= 2
        y = dims('y_min') + 0.5*(dims('y_max')-dims('y_min'));
        
        for j=1:length(SN.n)
            if strcmp(SN.n(j).role, 'N') && SN.n(j).y <= dims('y_min') + 0.5*(dims('y_max')-dims('y_min'))
                nodes_ids(end+1) = SN.n(j).id;
                dist_to_node(end+1) = sqrt( (y - SN.n(j).y)^2 );
            end 
        end 
        
    elseif mod(i, 2) == 1 && i > 2
        y = dims('y_min') + 0.5*(dims('y_max')-dims('y_min'));
        
        for j=1:length(SN.n)
            if strcmp(SN.n(j).role, 'N') && SN.n(j).y >= dims('y_min') + 0.5*(dims('y_max')-dims('y_min'))
                nodes_ids(end+1) = SN.n(j).id;
                dist_to_node(end+1) = sqrt( (y - SN.n(j).y)^2 );
            end 
        end 
        
    end
    
    [~,min_id]=min(dist_to_node(:)); % finds the minimum distance of node to MS
    I = nodes_ids(min_id); % Corresponding ID

    SN.n(I).E = inf;     % nodes energy levels (initially set to be equal to "ener('init')"
    SN.n(I).role = 'S';   % node acts as normal if the value is 'N', if elected as a priority node it  gets the value 'P' (initially all nodes are normal). Nodes can also be designed as sink => 'S'
    SN.n(I).cluster = NaN;	% the cluster which a node belongs to
    
    SN.n(I).col = "k"; % node color when plotting
    SN.n(I).size = 30; % marker size when plotting
    SN.n(i).alpha = 1; % the opacity when plotting
    
    ms_ids(1, i) = I;

end

end

