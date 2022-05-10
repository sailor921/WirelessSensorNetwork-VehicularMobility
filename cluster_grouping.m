function SN = cluster_grouping(SN, n_clusters, dims)
%CLUSTER_GROUPING Grouping Nodes into Clusters
%   This function group nodes in the wireless sensor network (WSN) into the
%   clusters based on their distance from the elected cluster heads
%
%   INPUT PARAMETERS
%   SN - all sensors nodes (including routing routes)
%   CL - all cluster nodes
%   CLheads - number of cluster heads elected.
%
%   OUTPUT PARAMETERS
%   SN - all sensors nodes (including routing routes)

clust_angle = 2*pi/n_clusters;

for i=1:length(SN.n)
    if  (SN.n(i).role == 'N') % if node is normal
        
        x_rel = SN.n(i).x - dims('x_max')/2;
        y_rel = SN.n(i).y - dims('y_max')/2;
        
        if x_rel >= 0 && y_rel >= 0
           ch_id = atan(x_rel/y_rel)/clust_angle;
        elseif x_rel < 0
           ch_id = ( atan(x_rel/y_rel) + pi )/clust_angle;
        elseif x_rel >= 0 && y_rel < 0
           ch_id = ( atan(x_rel/y_rel) + 2*pi )/clust_angle;
        end
        
        SN.n(i).cluster = ceil(ch_id);

    end
end

end

