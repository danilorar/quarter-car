% Analyze the CSV included with this project.
projectFolder = fileparts(mfilename('fullpath'));
csvName = '2025-03-15_14-26-10_8_IIB.csv';
dataFile = fullfile(projectFolder, 'csv', csvName);
if ~isfile(dataFile)
    % This also handles MATLAB running a temporary editor copy of the script.
    [pickedFile, pickedFolder] = uigetfile('*.csv', ...
        'Select the quarter-car data CSV');
    if isequal(pickedFile, 0)
        error('No CSV file was selected.');
    end
    dataFile = fullfile(pickedFolder, pickedFile);
end
data = readtable(dataFile);

time = data.Time_s;
potNames = {'fl_pot_travel_distance', 'fr_pot_travel_distance', ...
    'rl_pot_travel_distance', 'rr_pot_travel_distance'};
cornerNames = {'Front Left', 'Front Right', 'Rear Left', 'Rear Right'};

% Plot the four suspension travel signals.
figure('Name', 'Suspension Travel');
for k = 1:numel(potNames)
    subplot(4, 1, k);
    plot(time, data.(potNames{k}));
    ylabel('Travel (mm)');
    title(cornerNames{k});
end
xlabel('Time (s)');

% Plot damper velocity distributions using the values already in the CSV.
velocityNames = {'damper_vel_fl', 'damper_vel_fr', ...
    'damper_vel_rl', 'damper_vel_rr'};
figure('Name', 'Damper Velocity Distribution');
hold on;
for k = 1:numel(velocityNames)
    histogram(data.(velocityNames{k}), 40, 'Normalization', 'probability', ...
        'DisplayStyle', 'stairs', 'DisplayName', cornerNames{k});
end
xlabel('Damper Velocity (mm/s)');
ylabel('Probability');
legend('show');
grid on;
hold off;

% Calculate and plot one-sided FFT amplitude spectra from suspension travel.
dt = mean(diff(time));
sampleRate = 1 / dt;
figure('Name', 'Suspension Travel FFT');
hold on;
for k = 1:numel(potNames)
    values = data.(potNames{k});
    values = values - mean(values, 'omitnan');
    n = numel(values);
    spectrum = abs(fft(values));
    oneSided = spectrum(1:floor(n / 2) + 1) * (2 / n);
    oneSided(1) = oneSided(1) / 2; % DC is not doubled
    if mod(n, 2) == 0
        oneSided(end) = oneSided(end) / 2; % Nyquist bin is not doubled
    end
    frequencies = (0:floor(n / 2))' * (sampleRate / n);
    plot(frequencies, oneSided, 'DisplayName', cornerNames{k});
end
xlabel('Frequency (Hz)');
ylabel('Travel Amplitude (mm)');
legend('show');
grid on;
hold off;
