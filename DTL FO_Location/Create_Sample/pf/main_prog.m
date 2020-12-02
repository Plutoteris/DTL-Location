clear variables; clc;
global Source_V Amplitude_V Frequency_V vref0   ...
       Source_P1 Amplitude_P1 Frequency_P1 pm01 ...
       intstep VP_nos VQ_nos tcorr P0 Q0 PQ_std PQ pqi xnode

%%% Careful! All Bus indices are shifted by 1. Therfore, "Bus 4" %%%
%%% (source Bus) is actually Bus #3 when calling its variables.  %%%

LBf = 0.1;                               %Frequency Lower Bound
RSLTf = 0.2;                             %Frequency Resolution
UBf = 2.6;                               %Frequency Upper Bound
LBm = 0;                                 %Amplitude Lower Bound
RSLTm = 0.05;                            %Amplitude Resolution
UBm = 0.45;                              %Amplitude Upper Bound
%% Initial Data
for xnode = 1:29
    for pqi = 0.95:0.05:1.05
        WECC_179
        npq = size(PQ.con,1);           % Number of load buses
        P0  = PQ.con(:,4);              % Initial value of loads' active power
        Q0  = PQ.con(:,5);              % Initial value of loads' reactive power
        
        %% Solve Power Flow
        
        initpsat;
        datafile = 'WECC_179';
        runpsat(datafile,'data');
        Settings.freq   = 60;
        Settings.maxvar = 5000;    % Increase # of Variables
        runpsat('pf');             % Run the Almighty Power Flow %
        
        %% Choose Excitation and Mechanical Oscillation Source Buses
        %  Sources are generator indices
        % Exciter Reference
        Source_V    = 1;
        Amplitude_V = 0.015;
        Frequency_V = 0.86;
        vref0       = Exc.vref0(Source_V);
        
        % Mechanical Power 2 (Generator Bus 65)
        Source_P1    = xnode;
        Amplitude_P1 = 0.5;
        Frequency_P1 = 0.7;
        pm01         = Syn.pm0(Source_P1);
        
        %% Pm Batch Simulation
        for Pf = LBf:RSLTf:UBf           %%Pm_Batch_Simulation(Frequency_P1,Amplitude_P1,npq);
            Frequency_P1 = 0;
            Frequency_P1 = Pf + Frequency_P1;
            for Pmi = LBm:RSLTm:UBm
                Amplitude_P1 = 0.05;
                %% Initialize Time Domain Simulation
                intstep = 1/30;
                tcorr   = 1;
                PQ_std  = 0.01;
                tbegin  = 0;
                tfinal  = 30;
                Amplitude_P1 = Pmi + Amplitude_P1;
                runpsat('perturb_Pf','pert');     % Perturbation file
                Settings.freq   = 60;               % Change System Freq from default to 60
                clpsat.readfile = 1;                % Read data file before running power flow
                VP_nos  = zeros(npq,1);             % Vector of noise for load P
                VQ_nos  = zeros(npq,1);             % Vector of noise for load Q
                
                % SETTINGS FOR TIME DOMAIN SIMULATION
                Settings.coi   = 0;                % Do *NOT* use center of inertia for synchronous machines
                Settings.t0    = tbegin;           % Initial simulation time
                Settings.tf    = tfinal;           % Final simulation time
                Settings.pq2z  = 0;                % Do not convert PQ loads to constant impedance (Z) loads after power flow
                Settings.fixt  = 1;                % Enable fixed time-step solver
                Settings.tstep = intstep;          % Fixed time step value
                nL             = Line.n + Ltc.n + Phs.n + Hvdc.n + Lines.n; % Num circuit elements
                Varname.idx    = 1:DAE.n + DAE.m + 2*Bus.n + 6*nL + 2;      % Plot Variable Indexes (ask for current to be included)
                
                % Run Time Domain Simulation
                runpsat('td');
                % Save The Result
                data.p=Varout.vars(:,[424;428;432;436;440;444;448;452;456;460;464;468;472;476;480;484;488;492;496;500;504;508;512;516;520;524;528;532;536]);
                data.p=data.p./data.p(1,:);
                data.q=Varout.vars(:,[425;429;433;437;441;445;449;453;457;461;465;469;473;477;481;485;489;493;497;501;505;509;513;517;521;525;529;533;537]);
                data.q=data.q./data.q(1,:);
                data.v=Varout.vars(:,[246;248;251;253;255;257;260;272;277;278;282;285;287;289;307;312;319;321;345;354;358;360;380;382;386;390;391;401;404]);
                [~,b]=find(Varout.vars(1,1:59)==1);
                data.w = Varout.vars(:,b);
                datanames = {'...\FO_sample\',strcat(num2str(xnode),'\',num2str(xnode),'PQ_',num2str(pqi),'Pf_',num2str(Pf),'_','Pmi_',num2str(Pmi),'.mat')};
                save(cell2mat(datanames),'data');
            end
        end
        closepsat;
    end
end