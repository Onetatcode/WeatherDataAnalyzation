% Load the historical weather data from the CSV file
data = readtable('islamabad_weather_data.csv');

% Convert Date column to datetime format
data.Date = datetime(data.Date, 'InputFormat', 'MM/dd/yyyy');

% Extract relevant columns for analysis
dates = data.Date; % Dates
temperature = data.Temperature_C; % Temperature in °C
humidity = data.Humidity_Percent; % Humidity in %

% Ensure humidity is numeric (remove any percentage symbols if present)
if iscell(humidity) || isstring(humidity)
    humidity = str2double(erase(humidity, '%')); % Convert to numeric
end

% Plotting Temperature as a Line Graph
figure;
subplot(2,1,1); % Create a subplot for two graphs
plot(dates, temperature, '-o', 'LineWidth', 2);
xlabel('Date');
ylabel('Temperature (°C)');
title('Temperature Trend for Islamabad');
grid on;

% Plotting Humidity as a Heatmap
subplot(2,1,2); % Second subplot for heatmap
% Create a 2D matrix for heatmap (dates on X-axis, single row of humidity)
Z = humidity'; % Transpose humidity to create a single row matrix
heatmap(dates, {'Humidity'}, Z); % Use dates as X-axis and "Humidity" as Y-axis label
xlabel('Date');
ylabel('Humidity');
title('Humidity Heatmap for Islamabad');
colormap('jet'); % Change color map to 'jet' for better visualization

% Adjust layout
sgtitle('Weather Data Visualization for Islamabad'); % Overall title for subplots

% Prediction Section
% Prepare numerical indices for regression analysis
days = 1:length(temperature); % Create a numerical index for days

% Fit a linear regression model to predict future temperatures
coeffs = polyfit(days, temperature, 1); % Linear fit (degree 1)

% Predict temperatures for the next 7 days (from Jan 22 to Jan 28)
futureDays = length(days) + (1:7); % Indices for the next 7 days
predictedTemps = polyval(coeffs, futureDays); % Calculate predicted temperatures

% Create future dates based on last date in dataset
futureDates = dates(end) + days(1:7)'; 

% Display predicted temperatures
disp('Predicted Temperatures for Next Week:');
for i = 1:length(predictedTemps)
    fprintf('%s: %.2f °C\n', datestr(futureDates(i)), predictedTemps(i));
end

% Plotting Predictions
figure;
plot(dates, temperature, '-o', 'DisplayName', 'Historical Data', 'LineWidth', 2);
hold on;
plot(futureDates, predictedTemps, '--*', 'DisplayName', 'Predicted Data', 'LineWidth', 2);
xlabel('Date');
ylabel('Temperature (°C)');
title('Temperature Prediction for Islamabad');
legend;
grid on;
