function [dims,ener] = param_init(max_dim, node_ener, ener_deduc, ener_agg, ener_amp)
%PARAM_INIT Parameters Initiation Function
%   This function gives the initialization of the wireless network sensor
%   (WSN) plot, the energy in parket transfer and other necessary
%   simulation parameters.
%
%   INPUT PARAMETERS
%   max_dim - maximum dimensions of the x and y axis of WSN plot.
%   node_ener - initial energy in each sensor nodes.
%   ener_diduc - energy deducted for packet transfer or receipt.
%   ener_amp - energy amplification. 
%               true => ener_amp = ener_deduc
%               false => ener_amp = 0
%               OTHERWISE: you can input the energy value desired
%               DEFAULT: false
%   ener_amp - energy aggregation. 
%               true => ener_agg = ener_deduc
%               false => ener_agg = 0
%               OTHERWISE: you can input the energy value desired
%               DEFAULT: false
%
%
%   OUTPUT PARAMETERS
%   dims - container of the dimensions of the WSN plot extremes and the
%           base station point. outputs: x_min, y_min, x_max, y_max, 
%           bs_x, bs_y.
%   ener - container of the energy values needed in simulation for the
%           transceiver, amplification, aggregation. Outputs: init, tran,
%           rec, amp, agg.

disp("Parameters Initialization Begins");
disp("...........")
pause(1)

%% Function Default Values

if nargin < 5
    ener_amp = false;
    ener_agg = false;
end

%% Defining the Network Dimensions for WSN

% Maximum Dimensions of WSN
x_max = max_dim;
y_max = max_dim;

% Minimum Dimensions of WSN
x_min = 0;
y_min = 0;


% Accumulation of dimensions
dims = containers.Map({'x_min', 'y_min', 'x_max', 'y_max'}, {x_min, y_min, x_max, y_max});

%% Energy Initialization

% Energy Amplification
if ener_amp == true
    amp = ener_deduc;
elseif ener_amp == false
    amp = 0;
elseif isnumeric(ener_amp)
    amp = ener_amp;
else
    amp = 0;
end

% Energy Aggregation
if ener_agg == true
    agg = ener_deduc;
elseif ener_agg == false
    agg = 0;
elseif isnumeric(ener_agg)
    agg = ener_amp;
else
    agg = 0;
end

energy = ener_deduc;

ener = containers.Map( {'init', 'tran', 'rec', 'amp', 'agg'}, {node_ener, energy, energy, amp, agg} );

disp("Parameters Initialization Ends");
disp("...........")
pause(1)

end

