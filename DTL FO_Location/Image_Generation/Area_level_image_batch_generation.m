clc;
clear;
%% Area_level image generation
dz = '...\';    %input original data path
files = cellstr(ls([dz '\*.mat']));
numberCandidate = size(files,1);
imageeeee=[];
for N=1:4
    tlast=5;
    ttt=1:1:tlast*30+1;
    parfor j=1:numberCandidate
        filenmae_i=files(j);
        data=importdata(char(strcat(dz,filenmae_i)));
        
        source_location_1=cell2mat(filenmae_i);
        source_location=str2num(source_location_1(1:2));
        if isempty(source_location)
            source_location=str2num(source_location_1(1));
        end
        
        a1=[24,11,19,23,12,25,26,5,14,6,27];
        a2=[4,10,1,2,28,3,13,29,7];
        a3=[9];
        a4=[18,8,16,17,15,20,21,22];
        aquan={a1,a2,a3,a4};
        if ismember(source_location,aquan{1,N})==1
            
            switch N
                case 1
                    %1区
                    p29 = data.pg(ttt,[24,11,19,23,12,25,26,5,14,6,27]);
                    %                     q29 = data.q(ttt,[24,11,19,23,12,25,26,5,14,6,27]);
                    %                     v29 = data.v(ttt,[24,11,19,23,12,25,26,5,14,6,27]);
                    %                     w29 = data.w(ttt,[24,11,19,23,12,25,26,5,14,6,27]);
                case 2
                    %2区
                    p29 = data.pg(ttt,[4,10,1,2,28,3,13,29,7]);
                    %                     q29 = data.q(ttt,[4,10,1,2,28,3,13,29,7]);
                    %                     v29 = data.v(ttt,[4,10,1,2,28,3,13,29,7]);
                    %                     w29 = data.w(ttt,[4,10,1,2,28,3,13,29,7]);
                case 3
                    %3区
                    p29 = data.pg(ttt,[9]);%-data.p(1,[9]);
                    %                     q29 = data.q(ttt,[9]);
                    %                     v29 = data.v(ttt,[9]);
                    %                     w29 = data.w(ttt,[9]);
                case 4
                    %%4区
                    p29 = data.pg(ttt,[18,8,16,17,15,20,21,22]);
                    %                     q29 = data.q(ttt,[18,8,16,17,15,20,21,22]);
                    %                     v29 = data.v(ttt,[18,8,16,17,15,20,21,22]);
                    %                     w29 = data.w(ttt,[18,8,16,17,15,20,21,22]);
            end
            
            fs=30;
            D=[];
            for i=1:size(p29,2)
                D_i = wvd(p29(:,i),fs,'smoothedPseudo');
                D = [D,D_i];
            end
            
            imageeeee=D;
            data_image=imagesc(imageeeee);
            set(gca,'XTick',[],'YTick',[],'XColor','none','YColor','none','looseInset',[0 0 0 0]);
            
            
            
            datanames = {'...\',strcat(num2str(N),'\',num2str(source_location),'\',char(filenmae_i),'image',num2str(j),'.png')}; %don't forget to fill the path
            saveas(data_image, cell2mat(datanames), 'png');
        end
    end
end