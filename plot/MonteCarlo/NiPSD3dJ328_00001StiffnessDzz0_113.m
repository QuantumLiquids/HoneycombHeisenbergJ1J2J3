L_set = [32];

beta_set = [0.2439    0.2326   0.2222    0.2128    0.2041    0.1961    0.1887    0.1818    0.1754    0.1695    0.1639    0.1587    0.1538  0.1493    0.1449    0.1408    0.1370    0.1333    0.1299    0.1266    0.1235    0.1205    0.1176    0.1149   0.1124    0.1099    0.1075    0.1053    0.1031    0.1010    0.0990    0.0971    0.0952    0.0935    0.0917   0.0901    0.0885    0.0870    0.0855    0.0840    0.0826    0.0813    0.0800    0.0787    0.0775    0.0763  0.0752    0.0741    0.0730    0.0719   0.0709    0.0699    0.0690    0.0680    0.0671    0.0662    0.0654  0.0645    0.0637    0.0629    0.0621    0.0613    0.0606    0.0599    0.0592    0.0585    0.0578    0.0571  0.0565    0.0559    0.0552    0.0546    0.0541    0.0535    0.0529    0.0524    0.0518    0.0513];
J1zz = 5.3;
J2zz = 0.2;
J3zz = -28.00002;
Dzz = -0.5;
num_chain = 5;

prefix = '../data/';
save_data_prefix = './plot_data/';
eVtoK_const = 11.606;

stiffness_set = zeros(numel(L_set), numel(beta_set));
specific_heat_set = zeros(numel(L_set), numel(beta_set));
chix_set = zeros(numel(L_set), numel(beta_set));
chiy_set = zeros(numel(L_set), numel(beta_set));
chiz_set = zeros(numel(L_set), numel(beta_set));
for system_ind = 1:numel(L_set)
    L = L_set(system_ind);
    N = 2 * L^2;
    
    chi_x_set = zeros(1, numel(beta_set));
    chi_y_set = zeros(1, numel(beta_set));
    chi_z_set = zeros(1, numel(beta_set));
    c_set = zeros(1, numel(beta_set));
    energy_set = zeros(1, numel(beta_set));
    
    for beta_ind = 1:numel(beta_set)
        beta = beta_set(beta_ind);
        
        fprintf('beta=%.6f\n', beta);
        
        postfix = ['hei-rank',num2str(0), 'Honeycomb3', 'J1zz', num2str(J1zz,'%.6f'),...
            'J2zz', num2str(J2zz,'%.6f'),  'J3zz', num2str(J3zz,'%.6f'),...
            'Dzz', num2str(Dzz,'%.6f'),'beta',num2str(beta,'%.6f'),'L', num2str(L)];
%         test_load = load([prefix, 'summary', postfix]);
        data_type_size = 6;%numel(test_load);
        averaged_data=zeros(data_type_size, num_chain);

        
        direct_data_file = [save_data_prefix,'/hei','Honeycomb3', 'J1zz', num2str(J1zz,'%.6f'),...
            'J2zz', num2str(J2zz,'%.6f'),  'J3zz', num2str(J3zz,'%.6f'),...
            'Dzz', num2str(Dzz,'%.6f'),'beta',num2str(beta,'%.6f'),'L', num2str(L),'.mat'];
        if exist(direct_data_file,'file') && 0
            load(direct_data_file);
        else
            
            for i = 0:num_chain-1
                postfix = ['hei-rank',num2str(i), 'Honeycomb3', 'J1zz', num2str(J1zz,'%.6f'),...
                    'J2zz', num2str(J2zz,'%.6f'),  'J3zz', num2str(J3zz,'%.6f'),...
                    'Dzz', num2str(Dzz,'%.6f'),'beta',num2str(beta,'%.6f'),'L', num2str(L)];
                data = load([prefix, 'summary', postfix]);
                averaged_data(:,i + 1) = data(1:6);
            end
            
            chix = averaged_data(3,:);
            fprintf("chi_x = %.12f\n", mean(chix));
            fprintf("delta chi_x = %.12f\n", sqrt(var(chix)/num_chain));
            
            chiy = averaged_data(4,:);
            fprintf("chi_y = %.12f\n", mean(chiy));
            fprintf("delta chi_y = %.12f\n", sqrt(var(chiy)/num_chain));
            
            
            chiz = averaged_data(5,:);
            fprintf("chi_z = %.12f\n", mean(chiz));
            fprintf("delta chi_z = %.12f\n", sqrt(var(chiz)/num_chain));
%             
%             chi=chix+chiy+chiz;
%             fprintf("chi(x+y+z) = %.12f\n", mean(chi));
% 
%             
%             energy = averaged_data(1,:);
%             fprintf("e = %.12f\n", mean(energy));
%             fprintf("delta e = %.12f\n", sqrt(var(energy)/num_chain));
%             
            c =  averaged_data(2,:);
%             fprintf("c = %.12f\n", mean(c));
%             fprintf("delta c = %.12f\n", sqrt(var(c)/num_chain));
%             
            stiffness = averaged_data(6,:);
            stiffness = stiffness(stiffness>0);
            fprintf("stiffness = %.12f\n", mean(stiffness));
            fprintf("delta rho = %.12f\n", sqrt(var(stiffness)/num_chain));
            
%             save(direct_data_file, 'chix','chiy','chiz','energy','c','stiffness');
        end
        
        stiffness_set(system_ind, beta_ind) = mean(stiffness);
        specific_heat_set(system_ind, beta_ind) = mean(c);
        chix_set(system_ind, beta_ind) = mean(chix);
        chiy_set(system_ind, beta_ind) = mean(chiy);
        chiz_set(system_ind, beta_ind) = mean(chiz);
    end 
end
% save('StiffnessD3dJ328Dzz0_113.mat','stiffness_set');
% load('StiffnessD3dJ328Dzz0_113.mat','stiffness_set');
T_set = eVtoK_const./beta_set;


% h = plot(T_set, stiffness_set, '-o');hold on;
% h0 = plot(T_set, 8./beta_set/pi,'-.'); hold on;
% h1 = plot(T_set, 4./beta_set/pi,'-.'); hold on;
% h2 = plot(T_set, 2./beta_set/pi,'-.'); hold on;
% l=legend([h0,h1,h2],{'$\rho_s = 8T/\pi$','$\rho_s = 4T/\pi$','$\rho_s = 2T/\pi$'});
% set(l,'Box','off');set(l,'Interpreter','latex');
% set(l,'Fontsize',32);
% set(l,'Location','SouthWest');



plot(T_set, specific_heat_set, '-o');hold on;



% plot(T_set, chix_set, '-o');hold on;
% plot(T_set, chiy_set, '-o');hold on;
% plot(T_set, chiz_set, '-o');hold on;


Tc_set = [158.5,157.5,157];%K


set(gca,'fontsize',24);
set(gca,'linewidth',1.5);
set(get(gca,'Children'),'linewidth',2); % Set line width 1.5 pounds
xlabel('$T(K)$','Interpreter','latex');
ylabel('specific heat','Interpreter','latex');
set(get(gca,'XLabel'),'FontSize',24);
set(get(gca,'YLabel'),'FontSize',24);
%  set(gca, 'Ylim',[0,inf]);
% 
% 
% axes('Position',[0.6,0.7,0.25,0.2]);
% fit_x = 1./(log(L_set).^2);
% plot(fit_x,Tc_set,'o'); hold on;
% 
% p = fit(fit_x',Tc_set','poly1');
% T_BKT = p.p2;
% fprintf('T_BKT=%.5f\n',T_BKT);
% plot_x = 0:max(fit_x)/100:max(fit_x);
% plot(plot_x, p.p1*plot_x + p.p2,'-.');
% 
% 
% 
% set(gca,'fontsize',24);
% set(gca,'linewidth',1.5);
% set(get(gca,'Children'),'linewidth',2); % Set line width 1.5 pounds
% % ylabel('$T_{\mathrm{BKT}}/K$','Interpreter','latex');
% ylabel('$T^*(K)$','Interpreter','latex');
% xlabel('$(\ln L)^2$','Interpreter','latex');
% set(get(gca,'XLabel'),'FontSize',24);
% set(get(gca,'YLabel'),'FontSize',24);
% 
% set(gca, 'Xlim',[0,inf]);
% 