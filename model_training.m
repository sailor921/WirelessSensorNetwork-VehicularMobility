function model = model_training(data, train_data, n_sinks)
%MODEL_TRAINING Summary of this function goes here
%   Detailed explanation goes here

disp("Model Training Started");
pause(1)

numFeatures = 1;
numHiddenUnits1 = 256;
numHiddenUnits2 = 128;
numClasses = 1;

layers = [sequenceInputLayer(numFeatures) 
    lstmLayer(numHiddenUnits1,'OutputMode','sequence')
    dropoutLayer(0.2)
    lstmLayer(numHiddenUnits2,'OutputMode','last') 
    dropoutLayer(0.2)
    fullyConnectedLayer(numClasses) 
    regressionLayer];

%maxEpochs = ceil(150/(train_data*n_sinks));
maxEpochs = 150;
miniBatchSize = 32;

options = trainingOptions('adam', 'MaxEpochs',maxEpochs, 'MiniBatchSize', ...
    miniBatchSize, 'GradientThreshold',1, 'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', 'LearnRateDropPeriod',int8(maxEpochs/2), ...
    'LearnRateDropFactor',0.2, 'Verbose',0, 'Plots','training-progress',...
    'Shuffle','never');

% Training for the Mobile Sink X-Data
x_train_start = false;
%train_count_end = train_data * n_sinks;
train_count_end = 1;

for training_count = 1:train_count_end
    values = data(training_count).X;
    X = num2cell(values(1:end-1)');
    Y = values(2:end)';
    
    if x_train_start
        model_x = trainNetwork(X, Y, model_x.Layers, options);
        fprintf('.');
    else
        fprintf('Start X-Data Modelling\n.'); 
        model_x = trainNetwork(X, Y, layers, options);
        x_train_start = true;
    end
    
end
fprintf('\nEnd X-Data Modelling'); 

% Training for the Mobile Sink Y-Data
y_train_start = false;
for training_count = 1:train_count_end
    values = data(training_count).Y;
    X = num2cell(values(1:end-1)');
    Y = values(2:end)';
    
    if y_train_start
        model_y = trainNetwork(X, Y, model_y.Layers, options);
        fprintf('.'); 
    else
        fprintf('Start Y-Data Modelling\n.');
        model_y = trainNetwork(X, Y, layers, options);
        y_train_start = true; 
    end
    
end
fprintf('\nEnd Y-Data Modelling'); 

% Saving Model Y
save model_data model_x model_y;

% Model Return
model = containers.Map({'model_x', 'model_y'}, {model_x, model_y});

fprintf('\nModel Training Ended');
disp("............................................................");


end

