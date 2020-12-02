imdsValidation = imageDatastore('C:\Users\Pluto\Desktop\DTL FO_Location\DEF_Invalid_Sample\test\System-level\', ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames'); 

load('...\DTL FO_Location\DEF_Invalid_Sample\test\System-level\system_level_model.mat');

inputSize = net.Layers(1).InputSize;
augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);

[YPred,probs] = classify(net,augimdsValidation,'ExecutionEnvironment','cpu');

accuracy = mean(YPred == imdsValidation.Labels)