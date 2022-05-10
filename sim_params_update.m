function [sim_params] = sim_params_update(round, round_params, sim_params)
%SIM_PARAMS_UPDATE Update the Simulation Parameters at the end of a round
%   This function is used to update all the parameters gathered after a
%   complete round in a wireless sensor network (WSN).
%
%   INPUT PARAMETERS
%   round - the current round in the simulation.
%   round_params - container of the parameters used to measure the
%                   performance of the simulation in a round. The params
%                   are: 'dead nodes', 'operating nodes', 'total energy', 
%                   'packets', 'stability period', 'lifetime', 
%                   'stability period round', 'lifetime round'.
%   sim_params - container of the parameters of the data gathered after a
%                   complete imulation round. The parameters are vectors.
%                   They include: "dead nodes", "operating nodes", 
%                   "total energy", "packets", "cluster heads".
%
%   OUTPUT PARAMETERS
%   sim_params - container of the parameters of the data gathered after a
%                   complete imulation round. The parameters are vectors.
%                   They include: "dead nodes", "operating nodes", 
%                   "total energy", "packets", "cluster heads".

for i=["dead nodes", "operating nodes", "total energy", "packets", "contact time", "interconnect time"]
    x = sim_params(i);
    x(round) = round_params(i);
    sim_params(i) = x;
end

end

