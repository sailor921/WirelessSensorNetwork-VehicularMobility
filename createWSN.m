function [SN] = createWSN(nodes, dims, energy, rounds, seed)
%CREATEWSN Creation of the Wireless Sensor Network
%   This function gives the initialization of the sensor nodes, the routing
%   nodes and the base station of the wireless sensor network (WSN). It
%   also initiates the energy values and some important conditions for the
%   WSN simulation.
%
%   INPUT PARAMETERS
%   nodes - the total number of sensor and routing nodes
%   sink_nodes - the number of mobile sinks
%   dims - the dimensions of the WSN
%   energy - initial energy of the nodes (excluding the sinks - whose
%               energy are infinite).
%   seed - the random generation seed. Default: true. But you can pass a
%               new seed by assigning a numeric valid to the seed
%               parameter. If you don't want seeding, assign 'false'.
%
%   OUTPUT PARAMETERS
%   SN - all sensors nodes (including routing routes)

%% Function Default Values

if nargin < 7
    seed = true;
end

% Simulation Seed Initiation
if seed == true
    i_seed = 0;
elseif isnumeric(seed)
    i_seed = seed;
end


%% Building the sensor nodes of the WSN

SN = struct();

for i=1:nodes
        
    if seed ~= false
        rng(i_seed);
        i_seed = i_seed + 1;
    end

    SN.n(i).id = i;	% sensor's ID number
    SN.n(i).x = dims('x_min') + rand(1,1)*(dims('x_max')-dims('x_min'));	% X-axis coordinates of sensor node
    SN.n(i).y = dims('y_min') + rand(1,1)*(dims('y_max')-dims('y_min'));	% Y-axis coordinates of sensor node
    SN.n(i).E = energy;     % nodes energy levels (initially set to be equal to "ener('init')"
    SN.n(i).role = 'N';   % node acts as normal if the value is 'N', if elected as a priority node it  gets the value 'P' (initially all nodes are normal). Nodes can also be designed as sink => 'S'
    SN.n(i).sn_visits = 0; % number of times visited by the sink nodes
    SN.n(i).cluster = 0;	% the cluster which a node belongs to
    SN.n(i).cond = 'A';	% States the current condition of the node. when the node is operational (i.e. alive) its value = 'A' and when dead, value = 'D'
    SN.n(i).rop = 0;	% number of rounds node was operational
    
    SN.n(i).col = "r"; % node color when plotting
    SN.n(i).size = 20; % marker size when plotting
    SN.n(i).alpha = (4/25)*(2.5^4).^(SN.n(i).E); % the opacity when plotting
    
    SN.n(i).Xs = []; % All positional values through the simulation
    SN.n(i).Ys = []; % All positional values through the simulation
    SN.n(i).ALPHAs = zeros(1, rounds); % All corresponding energy values through the simulation
    
end

end

