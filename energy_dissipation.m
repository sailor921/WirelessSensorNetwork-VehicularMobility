function [SN, round_params, int_conn_start, int_conn_start_check] = energy_dissipation(SN, round, ms_ids, pn_ids, energy, k, round_params, int_conn_start, int_conn_start_check)
%SN, round, dims, energy, k, round_params, method
%ENERGY_DISSIPATION Energy dissipation function for the WSN
%   This function evaluates the energy dissipated in the sensor nodes
%   during the transmission netween the nodes to the base station of the
%   network
%
%   INPUT PARAMETERS
%   SN - all sensors nodes (including routing routes)
%   CLheads - number of cluster heads elected.
%   round - the current round in the simulation.
%   dims - container of the dimensions of the WSN plot extremes and the
%           base station point. outputs: x_min, x_min, y_min, x_max, y_max, 
%           bs_x, bs_y.
%   ener - container of the energy values needed in simulation for the
%           transceiver, amplification, aggregation. Outputs: init, tran,
%           rec, amp, agg.
%   rn_ids - ids of all sensor nodes used for routing
%   k - the number of bits transfered per packet
%   round_params - container of the parameters used to measure the
%                   performance of the simulation in a round. The params
%                   are: 'dead nodes', 'operating nodes', 'total energy', 
%                   'packets', 'stability period', 'lifetime', 
%                   'stability period round', 'lifetime round'.
%   method - the approach used in the transfer of data from normal nodes to
%               the base station. The available parameters are: 'force CH'
%               and 'shortest'. Default: 'force CH'. 'force CH' compels the
%               nodes to pass through a channel head. 'shortest' searches
%               for the minimum energy dissipation route.
%
%   OUTPUT PARAMETERS
%   SN - all sensors nodes (including routing routes)
%   round_params - container of the parameters used to measure the
%                   performance of the simulation in a round. The params
%                   are: 'dead nodes', 'operating nodes', 'total energy', 
%                   'packets', 'stability period', 'lifetime', 
%                   'stability period round', 'lifetime round'.

if int_conn_start_check
    int_conn_stop = toc;
    int_conn_time = int_conn_stop - int_conn_start;

    round_params('interconnect time') = round_params('interconnect time') + int_conn_time;
end

start_time = toc;

for i = 1:length(SN.n)

    % Packet Transfer for Nodes in Given Cluster
    if strcmp(SN.n(i).role, 'N') && strcmp(SN.n(i).cond,'A')

        if SN.n(i).E > 0 && SN.n(i).pn_id ~= 0 % Verification that node is alive and it has a priority node
            
            ETx = energy('tran')*k + energy('amp') * k * SN.n(i).dnp^2;
            SN.n(i).E = SN.n(i).E - ETx;
            SN.n(i).alpha = (4/25)*(2.5^4).^(SN.n(i).E);
            round_params('total energy') = round_params('total energy') + ETx;

            % Dissipation for priority node during reception
            if SN.n(SN.n(i).pn_id).E > 0 && strcmp(SN.n(SN.n(i).pn_id).cond, 'A') && strcmp(SN.n(SN.n(i).pn_id).role, 'P')
                ERx = (energy('rec') + energy('agg'))*k;
                round_params('total energy') = round_params('total energy') + ERx;
                SN.n(SN.n(i).pn_id).E = SN.n(SN.n(i).pn_id).E - ERx;
                SN.n(SN.n(i).pn_id).alpha = (4/25)*(2.5^4).^(SN.n(SN.n(i).pn_id).E);

                if SN.n(SN.n(i).pn_id).E<=0  % if priority node energy depletes with reception
                    SN.n(SN.n(i).pn_id).cond = 'D';
                    SN.n(SN.n(i).pn_id).rop=round;
                    SN.n(SN.n(i).pn_id).E=0;
                    SN.n(SN.n(i).pn_id).alpha = 0;
                    round_params('dead nodes') = round_params('dead nodes') + 1;
                    round_params('operating nodes') = round_params('operating nodes') - 1;
                end
            end
            
        elseif SN.n(i).E > 0 && SN.n(i).pn_id == 0 % Verification that node is alive but it has no priority node
            
            dist_to_sinks = zeros(1, length(ms_ids));
            for j = 1:length(ms_ids)
                dist_to_sinks(j) = sqrt( (SN.n(ms_ids(j)).x - SN.n(i).x)^2 + (SN.n(ms_ids(j)).y - SN.n(i).y)^2 );
            end
            
            dns = min(dist_to_sinks(:)); % Distance to closest mobile sink
            
            ETx = energy('tran')*k + energy('amp') * k * dns^2;
            SN.n(i).E = SN.n(i).E - ETx;
            SN.n(i).alpha = (4/25)*(2.5^4).^(SN.n(i).E);
            round_params('total energy') = round_params('total energy') + ETx;
            
            % Energy Dissipation in Mobile Sink
            ERx=(energy('rec') + energy('agg'))*k;
            round_params('total energy') = round_params('total energy') + ERx;

        end

        % Check for node depletion
        if SN.n(i).E<=0 % if nodes energy depletes with transmission
            round_params('dead nodes') = round_params('dead nodes') + 1;
            round_params('operating nodes') = round_params('operating nodes') - 1;
            SN.n(i).cond = 'D';
            SN.n(i).pn_id=0;
            SN.n(i).rop=round;
            SN.n(i).E=0;
            SN.n(i).alpha=0;
        end

    end
end

% Packet Transmission to the Mobile Sink
for pn_id = pn_ids
    if (pn_id~= 0)
        if strcmp(SN.n(pn_id).role, 'P') &&  strcmp(SN.n(pn_id).cond, 'A')

            if SN.n(pn_id).E > 0

                dist_to_sinks = zeros(1, length(ms_ids));
                for j = 1:length(ms_ids)
                    dist_to_sinks(j) = sqrt( (SN.n(ms_ids(j)).x - SN.n(pn_id).x)^2 + (SN.n(ms_ids(j)).y - SN.n(pn_id).y)^2 );
                end

                dpns = min(dist_to_sinks(:)); % Distance to closest mobile sink

                % Packet transfer to Mobile Sink
                ETx = energy('tran')*k + energy('amp') * k * dpns^2;
                SN.n(pn_id).E = SN.n(pn_id).E - ETx;
                SN.n(pn_id).alpha = (4/25)*(2.5^4).^(SN.n(pn_id).E);
                round_params('total energy') = round_params('total energy') + ETx;
                round_params('packets') = round_params('packets') + 1;

                % Check for priority node depletion
                if SN.n(pn_id).E<=0 % if nodes energy depletes with transmission
                    round_params('dead nodes') = round_params('dead nodes') + 1;
                    round_params('operating nodes') = round_params('operating nodes') - 1;
                    SN.n(pn_id).cond = 'D';
                    SN.n(pn_id).pn_id=0;
                    SN.n(pn_id).rop=round;
                    SN.n(pn_id).E=0;
                    SN.n(pn_id).alpha = 0;
                end

                % Energy Dissipation in Mobile Sink
                ERx=(energy('rec') + energy('agg'))*k;
                round_params('total energy') = round_params('total energy') + ERx;

            end
        end
    end
end

stop_time = toc;
contact_time = stop_time - start_time;

round_params('contact time') = round_params('contact time') + contact_time;

int_conn_start = toc;
int_conn_start_check = true;

end

