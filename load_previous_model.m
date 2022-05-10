function model = load_previous_model()
%LOAD_PREVIOUS_MODEL Summary of this function goes here
%   Detailed explanation goes here

try
    model_x = load("model_data", "model_x");
    model_x = model_x.model_x;
catch
    error("No pretrained X-coordinate model found")
end

try
    model_y = load("model_data", "model_y");
    model_y = model_y.model_y;
catch
    error("No pretrained Y-coordinate model found")
end

% Model Return
model = containers.Map({'model_x', 'model_y'}, {model_x, model_y});
    
end

