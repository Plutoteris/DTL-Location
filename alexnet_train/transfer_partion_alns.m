%区内扰动源定位测试2019.8.30

clc;
clear;
imds = imageDatastore('D:\CNN_location\create_sample\date1126\fix_region_6\\', ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames'); 
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.85,'randomized');

net = alexnet;
% load('islandlocationnet.mat');
inputSize = net.Layers(1).InputSize;
%analyzeNetwork(net);
if isa(net,'SeriesNetwork') 
  lgraph = layerGraph(net.Layers); 
else
  lgraph = layerGraph(net);
end

lgraph = removeLayers(lgraph, {'fc8','prob','output'});

numClasses = numel(categories(imdsTrain.Labels));

newLayers = [
    fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')];
lgraph = addLayers(lgraph,newLayers);
lgraph = connectLayers(lgraph,'drop7','fc');
%lgraph = connectLayers(lgraph,'fc8','fc');
layers = lgraph.Layers;
connections = lgraph.Connections;


% layers(1:17) = freezeWeights(layers(1:17));%0 5 10 17 24 31
% lgraph = createLgraphUsingConnections(layers,connections);


pixelRange = [0 0];
scaleRange = [1 1];
imageAugmenter = imageDataAugmenter( ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange, ...
    'RandXScale',scaleRange, ...
    'RandYScale',scaleRange);
 augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain, ...
    'DataAugmentation',imageAugmenter);
augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);
%valFrequency = floor(numel(augimdsTrain.Files)/miniBatchSize);
options = trainingOptions('sgdm', ...
    'MiniBatchSize',16, ...
    'MaxEpochs',40, ...
    'InitialLearnRate',1e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',50, ...
    'ValidationPatience',Inf, ...
    'Verbose',true, ...
    'Plots','training-progress',...
    'ExecutionEnvironment','cpu');

%net = trainNetwork(augimdsTrain,lgraph,options);
net = trainNetwork(augimdsTrain,lgraph,options);
[YPred,probs] = classify(net,augimdsValidation,'ExecutionEnvironment','cpu');
accuracy = mean(YPred == imdsValidation.Labels)