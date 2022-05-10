function [SN, round_params, sim_params] = simulation_rounds(rounds, SN, dims, ener, k, ms_ids, n_clusters, mob_params, sn_model, past_data_considered)
%SIMULATION_ROUNDS Simulation Function for the Wireless Sensor Network
%   This function executes the complete simulation of n rounds in a
%   wireless netowrk and also collating data needed for analytics and
%   visualization of the network.
%
%   INPUT PARAMETERS
%   rounds - the total number of rounds in the simualtion.
%   SN - all sensors nodes (including routing routes)
%   p - the percentage of cluster heads desired
%   k - the number of bits transfered per packet
%   dims - container of the dimensions of the WSN plot extremes and the
%           base station point. outputs: x_min, x_min, y_min, x_max, y_max, 
%           bs_x, bs_y.
%   ener - container of the energy values needed in simulation for the
%           transceiver, amplification, aggregation. Outputs: init, tran,
%           rec, amp, agg.
%   rn_ids - ids of all sensor nodes used for routing
%   multiple_sim - boolean checking if executing multiple simulations.
%                   Default: false.
%   sim_number - the current simulation number. [Not necessary if
%                   'multiple_sim' is false]
%
%   OUTPUT PARAMETERS
%   %   SN - all sensors nodes (including routing routes)
%   round_params - container of the parameters used to measure the
%                   performance of the simulation in a round. The params
%                   are: 'dead nodes', 'operating nodes', 'total energy', 
%                   'packets', 'stability period', 'lifetime', 
%                   'stability period round', 'lifetime round'.

%% Initializations

round_params = containers.Map( {'dead nodes', 'operating nodes', 'total energy', 'packets', 'stability period', 'lifetime', 'stability period round', 'lifetime round', 'contact time', 'interconnect time'}, {0, length(SN.n), 0, 0, 0, 0, 0, 0, 0, 0} );
sim_params = containers.Map( {'dead nodes', 'operating nodes', 'total energy', 'packets', 'contact time', 'interconnect time'}, {zeros(1,rounds), zeros(1,rounds), zeros(1,rounds), zeros(1,rounds), zeros(1,rounds), zeros(1,rounds)} );

stability_period_check = true;
lifetime_check = true;

if n_clusters < length(ms_ids)
   error('Number of clusters should be more than number of mobile sinks'); 
end


%% Simulation Loop

% Group the WSN into clusters based on priority nodes
SN = cluster_grouping(SN, n_clusters, dims);


tic %Initialize timing

% Interconnected timer initializer
int_conn_start = toc;
int_conn_start_check = false;

for round=1:rounds
    
    % Display the current round
    fprintf('Round = %d \n', round);
    
    % Reset Sensor Node Roles (to Normal and Sink)
    [SN] = resetWSN(SN);
    
     % Appoint priority nodes
    [SN, pn_ids] = priority_nodes_selection(SN, ms_ids, sn_model, past_data_considered);
    
    % Perform packet transfer
    [SN, round_params, int_conn_start, int_conn_start_check] = energy_dissipation(SN, round, ms_ids, pn_ids, ener, k, round_params, int_conn_start, int_conn_start_check);
    
    % Update the simulation parameters
    [SN, round_params, stability_period_check, lifetime_check] = round_params_update(SN, round_params, dims, ms_ids, round, rounds, stability_period_check, lifetime_check, mob_params);
    [sim_params] = sim_params_update(round, round_params, sim_params);
end

end

