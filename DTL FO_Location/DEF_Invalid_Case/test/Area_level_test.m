imdsValidation = imageDatastore('...\DTL FO_Location\DEF_Invalid_Sample\test\Area-level\1\', ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames'); 

load('...\DTL FO_Location\DEF_Invalid_Sample\test\Area-level\area_1_model.mat');

inputSize = net.Layers(1).InputSize;
augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);

[YPred,probs] = classify(net,augimdsValidation,'ExecutionEnvironment','cpu');

accuracy = mean(YPred == imdsValidation.Labels)