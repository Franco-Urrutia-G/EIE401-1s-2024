% Basado en el ejemplo "Compress Audio Signal"
% Franco Urrutia Ghiardo
frameLength = 1024;
fileReader = dsp.AudioFileReader('sample.wav', 'SamplesPerFrame', frameLength);

threshold = -25; 
ratio = 7; 
kneeWidth = 5;
dRC = compressor(threshold, ratio, 'KneeWidth', kneeWidth, 'SampleRate', fileReader.SampleRate);


x_plot = []; 
y_plot = []; 
gain_plot = []; 
time_step = 1 / fileReader.SampleRate; 


while ~isDone(fileReader)
    x = fileReader();
    [y, gain] = dRC(x);
    
    % Append to plot buffers
    x_plot = [x_plot; x(:,1)];
    y_plot = [y_plot; y(:,1)];
    gain_plot = [gain_plot; gain(:,1)];
end

t = (0:length(x_plot)-1) * time_step;

release(fileReader);
release(dRC);

figure;

subplot(3,1,1);
plot(t, x_plot);
title('Señal de audio original');
xlabel('Tiempo (s)');
ylabel('Amplitud');

subplot(3,1,2);
plot(t, y_plot);
title('Señal de audio comprimida');
xlabel('Tiempo (s)');
ylabel('Amplitud');

subplot(3,1,3);
plot(t, gain_plot);
title('Ganancia aplicada por el compresor (dB)');
xlabel('Tiempo (s)');
ylabel('Ganancia (dB)');
ylim([-4 0]); % Ajustar límites verticales

sgtitle('Compresión dinámica de la señal de audio');
