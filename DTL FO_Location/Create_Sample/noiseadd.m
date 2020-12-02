clc;
clear;
for i=1:29
    dz=strcat('...\addnoise\',num2str(i),'\');
    files=cellstr(ls([dz '\*.mat']));
    numberCandidate=size(files,1);
    snr=50;
    for j=1:numberCandidate
        filename_i=files(j);
        data = importdata(char(strcat(dz,filename_i)));
        datan.p=awgn(data.p, snr, 'measured');
        datan.q=awgn(data.q, snr, 'measured');
        datan.v=awgn(data.v, snr, 'measured');
        datan.w=awgn(data.w, snr, 'measured');
        datanames={'...\addnoise\datanoise\',strcat(num2str(i)),'\',char(filename_i)};
        save(cell2mat(datanames),'datanoise');
    end
end