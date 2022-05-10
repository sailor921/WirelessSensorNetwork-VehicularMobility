function data = data_gathering(n, sn, dims, ener, n_clusters, rounds, mob_params, train_data)
%DATA_GATHERING Summary of this function goes here
%   Detailed explanation goes here
%% Simulation Details
disp("Gathering Data to Wireless Sensor Simulation");
disp("............................................................");
disp("............................................................");
pause(3)
 

%% Data Gathering Loop
training_count = 0;
data_count = 0;

while training_count < train_data
    training_count = training_count + 1;
    fprintf('Training Data Gathering: %d \n', training_count);
    
    % Initialization of the WSN
    SN = createWSN(n, dims, ener('init'), rounds, false);
    [SN, ms_ids] = create_vehicular_sinks(SN);

    % Group the WSN into clusters
    SN = cluster_grouping(SN, n_clusters, dims);

    % Loop Rounds
    for round=1:rounds

        % Display the current round
        if mod(round, 100) == 0
            fprintf('%d \n', round); 
        else
            fprintf('.'); 
        end

        % Update the node locations
        for i = 1:length(SN.n)

            % Storing on the round positions and the positional attributes
            SN.n(i).Xs(round) = SN.n(i).x;
            SN.n(i).Ys(round) = SN.n(i).y;
            SN.n(i).ALPHAs(round) = SN.n(i).alpha;
            SN.n(i).COLs(round) = SN.n(i).col;

            % Update new node positions
            if (strcmp(SN.n(i).role, 'N') || strcmp(SN.n(i).role, 'P')) && strcmp(SN.n(i).cond, 'A')
                dist_moved = mob_params('min_dist') + rand * (mob_params('max_dist') - mob_params('min_dist'));
            elseif strcmp(SN.n(i).role, 'S')
                dist_moved = mob_params('sn_min_dist') + rand * (mob_params('sn_max_dist') - mob_params('sn_min_dist'));
            else
                dist_moved =0;
            end

            direction_moved = -180 + rand * 360;

            if (dist_moved ~= 0)
                mobility_complete = false;
                while (~mobility_complete)
                    x_dest = SN.n(i).x + dist_moved*cosd(direction_moved);
                    y_dest = SN.n(i).y + dist_moved*sind(direction_moved);

                    node_moved_out = false;

                    if x_dest > dims('x_max')
                        node_moved_out = true;
                        new_direction = 180 - direction_moved;
                        x_dest = dims('x_max');
                        y_dest = SN.n(i).y + diff([SN.n(i).x x_dest])*tand(direction_moved);  
                    end
                    if x_dest < dims('x_min')
                        node_moved_out = true;
                        new_direction = 180 - direction_moved;
                        x_dest = dims('x_min');
                        y_dest = SN.n(i).y + diff([SN.n(i).x x_dest])*tand(direction_moved);
                    end
                    if y_dest > dims('y_max')
                        node_moved_out = true;
                        new_direction = -direction_moved;
                        y_dest = dims('y_max');
                        x_dest = SN.n(i).x + diff([SN.n(i).y y_dest])/tand(direction_moved); 
                    end
                    if y_dest < dims('y_min')
                        node_moved_out = true;
                        new_direction = -direction_moved;
                        y_dest = dims('y_min');
                        x_dest = SN.n(i).x + diff([SN.n(i).y y_dest])/tand(direction_moved);
                    end

                    SN.n(i).x = x_dest;
                    SN.n(i).y = y_dest;

                    if node_moved_out
                        direction_moved = new_direction;
                    else
                        mobility_complete = true;
                    end
                end
            end
        end

    end

    %% Data Collected
    for ms_id = ms_ids
        data_count = data_count + 1;
        
        data(data_count).X = SN.n(ms_id).Xs;
        data(data_count).Y = SN.n(ms_id).Ys;
    end
end

disp("Data Gathering Ended");
disp("............................................................");
pause(1)

end

