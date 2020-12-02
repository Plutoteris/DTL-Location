%% Area level image generation
load('');  %input the path of data
a1=[24,11,19,23,12,25,26,5,14,6,27];
a2=[4,10,1,2,28,3,13,29,7];
a3=[9];
a4=[18,8,16,17,15,20,21,22];
aquan={a1,a2,a3,a4};
ttt=1:1:5*30+1;

data.p=data.p./data.p(1,:);

N=4; %change N to generate Area N localization image

switch N
    case 1
        % AREA 1
        p29 = data.p(ttt,[24,11,19,23,12,25,26,5,14,6,27]);
        q29 = data.q(ttt,[24,11,19,23,12,25,26,5,14,6,27]);
        v29 = data.v(ttt,[24,11,19,23,12,25,26,5,14,6,27]);
        w29 = data.w(ttt,[24,11,19,23,12,25,26,5,14,6,27]);
    case 2
        % AREA 2
        p29 = data.p(ttt,[4,10,1,2,28,3,13,29,7]);
        q29 = data.q(ttt,[4,10,1,2,28,3,13,29,7]);
        v29 = data.v(ttt,[4,10,1,2,28,3,13,29,7]);
        w29 = data.w(ttt,[4,10,1,2,28,3,13,29,7]);
    case 3
        % AREA 3
        p29 = data.p(ttt,[9]);%-data.p(1,[9]);
        q29 = data.q(ttt,[9]);
        v29 = data.v(ttt,[9]);
        w29 = data.w(ttt,[9]);
    case 4
        % AREA 4
        p29 = data.p(ttt,[18,8,16,17,15,20,21,22]);
        q29 = data.q(ttt,[18,8,16,17,15,20,21,22]);
        v29 = data.v(ttt,[18,8,16,17,15,20,21,22]);
        w29 = data.w(ttt,[18,8,16,17,15,20,21,22]);
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


datanames = {'...\image1.png'}; %Don't forget change the file name
saveas(data_image, cell2mat(datanames), 'png');
