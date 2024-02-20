function [] = PlotXCHoneycombLattice(Lx, Ly)
N = 2 * Lx * Ly;
x_set = zeros(1,N);
y_set = zeros(1,N);
lattice_linewidth = 3;
for site_idx = 0:N-1
    [x_set(site_idx+1), y_set(site_idx+1)] = HoneycombXCCylinderSiteInd2XYCoor(site_idx, Ly);
    %    plot(x,y,'o','Color', 'k', 'MarkerFaceColor','k');hold on;
end

for site_idx = 0:N-1
    
    y_idx = mod(site_idx, Ly);
    x_idx = floor(site_idx / Ly);
    y = y_idx / 2;
    a_sublattice = 1 - mod(x_idx + y_idx, 2);
    x = x_idx * sqrt(3) / 2 - (1 - a_sublattice) / (2 * sqrt(3));
    if(a_sublattice==1)
       line([x,x+1/sqrt(3)],[y,y],'color','k','linewidth',lattice_linewidth);  hold on;
       line([x,x-1/2/sqrt(3)],[y,y+1/2],'color','k','linewidth',lattice_linewidth);hold on;
    else
        line([x,x+1/2/sqrt(3)],[y,y+1/2],'color','k','linewidth',lattice_linewidth);hold on;
    end
end
scatter(x_set,y_set,50,[0 139 0]/256,'o','filled');
axis off;
% axis tight;
axis equal;
end