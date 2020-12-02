% Area 1 model training

clc;
clear;
imds = imageDatastore('...\1\','IncludeSubfolders',true,'LabelSource','foldernames'); %input the image path
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.85,'randomized');

load('system_level_model.mat');
inputSize = net.Layers(1).InputSize;

if isa(net,'SeriesNetwork') 
  lgraph = layerGraph(net.Layers); 
else
  lgraph = layerGraph(net);
end

lgraph = removeLayers(lgraph, {'fc','softmax','classoutput'});

numClasses = numel(categories(imdsTrain.Labels));

newLayers = [
    fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')];
lgraph = addLayers(lgraph,newLayers);
lgraph = connectLayers(lgraph,'drop7','fc');
layers = lgraph.Layers;
connections = lgraph.Connections;

layers(1:17) = freezeWeights(layers(1:17));%0 5 10 17 24 31
lgraph = createLgraphUsingConnections(layers,connections);
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
options = trainingOptions('sgdm', ...
    'MiniBatchSize',16, ...
    'MaxEpochs',30, ...
    'InitialLearnRate',1e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',50, ...
    'ValidationPatience',Inf, ...
    'Verbose',true, ...
    'Plots','training-progress',...
    'ExecutionEnvironment','cpu');


net = trainNetwork(augimdsTrain,lgraph,options);
[YPred,probs] = classify(net,augimdsValidation,'ExecutionEnvironment','cpu');
accuracy = mean(YPred == imdsValidation.Labels)