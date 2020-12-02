clc;
clear;
%% System_level image generation
dz = '...'; %input original data path
files = cellstr(ls([dz '\*.mat']));
numberCandidate = size(files,1);
imageeeee=[];
tlast=5;
ttt=1:1:tlast*30+1;
for j=1:numberCandidate
    filenmae_i=files(j);
    data=importdata(char(filenmae_i));

    label_1=[24,11,19,23,12,25,26,5,14,6,27];
    label_2=[4,10,1,2,28,3,13,29,7];
    label_3=9;
    label_4=[18,8,16,17,15,20,21,22];
    p29 = data.p;
    q29 = data.q;
    v29 = data.v;
    w29 = data.w;
    p29_1=p29(ttt,label_1);
    p29_2=p29(ttt,label_2);
    p29_3=p29(ttt,label_3);
    p29_4=p29(ttt,label_4);

    [coeff_1,score_1,latent_1] = pca(p29_1);
    [coeff_2,score_2,latent_2] = pca(p29_2);
    [coeff_3,score_3,latent_3] = pca(p29_3);
    [coeff_4,score_4,latent_4] = pca(p29_4);
    
    pca_size=1;
    scoreregular_1=[score_1(:,1:min(pca_size,size(score_1,2))),zeros(size(score_1,1),pca_size-min(pca_size,size(score_1,2)))];
    scoreregular_2=[score_2(:,1:min(pca_size,size(score_2,2))),zeros(size(score_2,1),pca_size-min(pca_size,size(score_2,2)))];
    scoreregular_3=[score_3(:,1:min(pca_size,size(score_3,2))),zeros(size(score_3,1),pca_size-min(pca_size,size(score_3,2)))];
    scoreregular_4=[score_4(:,1:min(pca_size,size(score_4,2))),zeros(size(score_4,1),pca_size-min(pca_size,size(score_4,2)))];
    fs=30;

    D_1 = wvd(scoreregular_1,fs,'smoothedPseudo');
    D_2 = wvd(scoreregular_2,fs,'smoothedPseudo');
    D_3 = wvd(scoreregular_3,fs,'smoothedPseudo');
    D_4 = wvd(scoreregular_4,fs,'smoothedPseudo');

    imageeeee=[D_1,...
        D_2...
        D_3...
        D_4];
    data_image=imagesc(imageeeee);
    set(gca,'XTick',[],'YTick',[],'XColor','none','YColor','none','looseInset',[0 0 0 0]);
    source_location_1=cell2mat(filenmae_i);
    source_location=str2num(source_location_1(1:2));
    if isempty(source_location)
        source_location=str2num(source_location_1(1));
    end
    label=0;
    if isempty(find(source_location==label_1))
    else
        label=1;
    end
    if isempty(find(source_location==label_2))
    else
        label=2;
    end
    if isempty(find(source_location==label_3))
    else
        label=3;
    end
    if isempty(find(source_location==label_4))
    else
        label=4;
    end

    datanames = {'...\',strcat(num2str(label),'\','image',num2str(j),'.png')};%don't forget to fill the path
    saveas(data_image, cell2mat(datanames), 'png');
end