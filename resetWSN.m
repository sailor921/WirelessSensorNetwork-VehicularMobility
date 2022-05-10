function SN = resetWSN(SN)
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


%% Building the sensor nodes of the WSN


for i=1:length(SN.n)
    if strcmp(SN.n(i).role, 'N') || strcmp(SN.n(i).role, 'P')
        
        SN.n(i).role = 'N';
        SN.n(i).dnp = 0;
        SN.n(i).pn_id = 0;
        SN.n(i).col = "r";
        
    end
end


end

