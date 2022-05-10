function SN = vehicular_sink_update(SN, id, dims, dist_moved)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

mobility_complete = false;

while (~mobility_complete)
    if strcmp(SN.n(id).direction, 'left') || strcmp(SN.n(id).direction, 'right')
        x_dest = SN.n(id).x + dist_moved*SN.n(id).direction_moved;
    elseif strcmp(SN.n(id).direction, 'up') || strcmp(SN.n(id).direction, 'down')
        y_dest = SN.n(id).y + dist_moved*SN.n(id).direction_moved;
    end

    node_moved_out = false;
    
    if strcmp(SN.n(id).direction, 'left')
        if x_dest > dims('x_max')/2
            node_moved_out = true;
            SN.n(id).direction_moved = reverse_direction(SN.n(id).direction_moved);
            x_dest = dims('x_max')/2; 
        elseif x_dest < dims('x_min')
            node_moved_out = true;
            SN.n(id).direction_moved = reverse_direction(SN.n(id).direction_moved);
            x_dest = dims('x_min');
        end
    elseif strcmp(SN.n(id).direction, 'right')
        if x_dest > dims('x_max')
            node_moved_out = true;
            SN.n(id).direction_moved = reverse_direction(SN.n(id).direction_moved);
            x_dest = dims('x_max')/2; 
        elseif x_dest < dims('x_max');
            node_moved_out = true;
            SN.n(id).direction_moved = reverse_direction(SN.n(id).direction_moved);
            x_dest = dims('x_max')/2;
        end
    elseif strcmp(SN.n(id).direction, 'down')
        if y_dest > dims('y_max')/2
            node_moved_out = true;
            SN.n(id).direction_moved = reverse_direction(SN.n(id).direction_moved);
            y_dest = dims('y_max')/2; 
        elseif y_dest < dims('y_min')
            node_moved_out = true;
            SN.n(id).direction_moved = reverse_direction(SN.n(id).direction_moved);
            y_dest = dims('y_min');
        end
    elseif strcmp(SN.n(id).direction, 'up')
        if y_dest > dims('y_max')
            node_moved_out = true;
            SN.n(id).direction_moved = reverse_direction(SN.n(id).direction_moved);
            y_dest = dims('y_max')/2; 
        elseif y_dest < dims('y_max');
            node_moved_out = true;
            SN.n(id).direction_moved = reverse_direction(SN.n(id).direction_moved);
            y_dest = dims('y_max')/2;
        end
    end
    
    if strcmp(SN.n(id).direction, 'left') || strcmp(SN.n(id).direction, 'right')
        SN.n(id).x = x_dest;
    elseif strcmp(SN.n(id).direction, 'up') || strcmp(SN.n(id).direction, 'down')
        SN.n(id).y = y_dest;
    end

    if ~node_moved_out
        mobility_complete = true;
    end
end
        
end

