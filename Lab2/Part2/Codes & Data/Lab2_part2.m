%% Q1
clc;
% clear;

%Loading data:
data1 = cell2mat(struct2cell(load('NewData1.mat')));
data2 = cell2mat(struct2cell(load('NewData2.mat')));
data3 = cell2mat(struct2cell(load('NewData3.mat')));
data4 = cell2mat(struct2cell(load('NewData4.mat')));
electrodes = cell2mat(struct2cell(load('Electrodes.mat')));


fs = 250; %Sampling rate

%***************Plotting Data:****************************

%//////////////for data1
X = data1; %Defining the signal to plot
offset = max(abs(X(:))); %Computing maximum signal value for offsets (in order to avoid interference)
ElecName = electrodes.labels; %Electrodes names
disp_eeg(X,offset,fs,ElecName); %Using disp_eeg function for plots
title('Data1');

%///////////////for data2
X = data3;
offset = max(abs(X(:))) ;
disp_eeg(X,offset,fs,ElecName);
title('Data3');
%****************************************
%% Q3&4
% close all;

[F1,W1,K1] = COM2R(data1, size(data1,1)); %Computing ICA for data1:
[F3,W3,K3] = COM2R(data3, size(data3,1)); %Computing ICA for data3:

Z1 = W1*data1; %Computing independent sources for data 1. Dim = sources*samples
Z3 = W3*data3; %Computing independent sources for data 3. Dim = sources*samples


%*****************Time-domain figures:************************
X = Z1;
offset = max(abs(X(:))) ;
disp_eeg(X,offset,fs,[]);
title('Sources for Data1');

X = Z3;
offset = max(abs(X(:))) ;
disp_eeg(X,offset,fs,[]);
title('Sources for Data3');
%**************************************************************

%************************Freq-domain figures:***********************
rows = 7; %Number of rows in each figure
cols = 3; %Number of columns in each figure

figure('Name', 'Pwelch for data1');
pwelch(Z1.', [], [], [], fs);


figure('Name', 'Pwelch for data3');
pwelch(Z3.', [], [], [], fs);

%*********For data1:
figure;
for i=1:rows
    for j=1:cols
        n = (i-1)*cols+j; %The number of plot in the figure
        subplot(rows,cols,n);
        pwelch(Z1(n,:).',[], [], [], fs);
        title("Pwelch for source "+n);
    end
end

%*********For data3:
figure;
for i=1:rows
    for j=1:cols
        n = (i-1)*cols+j;  %The number of plot in the figure
        subplot(rows,cols,n);
        pwelch(Z3(n,:).',[], [], [], fs);
        title("Pwelch for source "+n);
    end
end
%****************************************************************



%***************Topomaps:****************************


%********FOR DATA1:
rows = 3; %Number of rows in each figure
cols = 3; %Number of cols in each figure

%Source number 1 to 9: 
figure;
for i=1:rows
    for j=1:cols
        n = (i-1)*cols+j; %The number of plot in the figure
        subplot(rows,cols,n);
        plottopomap(electrodes.X, electrodes.Y, electrodes.labels, F1(:, n)); %Each column, one source
        title("Data1: Topomap for source "+n);
    end
end

%Source number 10 to 18: 
figure;
for i=1:rows
    for j=1:cols
        tmp_n = (i-1)*cols+j; %The number of plot in the figure
        n = tmp_n + rows*cols; %The number of plot in total
        subplot(rows,cols,tmp_n);
        plottopomap(electrodes.X, electrodes.Y, electrodes.labels, F1(:, n)); %Each column, one source
        title("Data1: Topomap for source "+n);
    end
end

%Source number 19 to 21: 
figure;
for i=1:rows
    for j=1:cols
        tmp_n = (i-1)*cols+j;

        if tmp_n>3
            break;
        end

        n = tmp_n + 2*rows*cols;
        subplot(rows,cols,tmp_n);
        plottopomap(electrodes.X, electrodes.Y, electrodes.labels, F1(:, n)); %Each column, one source
        title("Data1: Topomap for source "+n);
    end
end







%*********FOR DATA3:
rows = 3;
cols = 3;

figure;
for i=1:rows
    for j=1:cols
        n = (i-1)*cols+j;
        subplot(rows,cols,n);
        plottopomap(electrodes.X, electrodes.Y, electrodes.labels, F3(:, n)); %Each column, one source
        title("Data3: Topomap for source "+n);
    end
end

figure;
for i=1:rows
    for j=1:cols
        tmp_n = (i-1)*cols+j;
        n = tmp_n + rows*cols;
        subplot(rows,cols,tmp_n);
        plottopomap(electrodes.X, electrodes.Y, electrodes.labels, F3(:, n)); %Each column, one source
        title("Data3: Topomap for source "+n);
    end
end

figure;
for i=1:rows
    for j=1:cols
        tmp_n = (i-1)*cols+j;

        if tmp_n>3
            break;
        end

        n = tmp_n + 2*rows*cols;
        subplot(rows,cols,tmp_n);
        plottopomap(electrodes.X, electrodes.Y, electrodes.labels, F3(:, n)); %Each column, one source
        title("Data3: Topomap for source "+n);
    end
end
%*****************************************************************




%% Q5
clc;

% Defining selected sources:
selSources1 = 1:size(data1,1);
selSources1([4, 10]) = []; %Removing artifact sources
selSources3 = 1:size(data3,1);
selSources3(1) = []; %Removing artifact sources

data1_denoised = F1(:, selSources1)*Z1(selSources1, :); %Creating denoised signals
data3_denoised = F3(:, selSources3)*Z3(selSources3, :); %Creating denoised signals


%***************Plotting denoised signals**********
X = data1_denoised;
offset = max(abs(X(:))) ;
fs = 250 ;
ElecName = electrodes.labels ;
disp_eeg(X,offset,fs,ElecName);
title('Denoised Data1');

X = data3_denoised;
offset = max(abs(X(:))) ;
disp_eeg(X,offset,fs,ElecName);
title('Denoised Data3');
%**************************************************



%% Q6: changing selSources to a better one
clc;

% Defining selected sources:
selSources1 = 1:size(data1,1);
selSources1([1, 4, 10]) = []; %Removing artifact sources
selSources3 = 1:size(data3,1);
selSources3(1) = []; %Removing artifact sources

data1_denoised = F1(:, selSources1)*Z1(selSources1, :); %Creating denoised signals
data3_denoised = F3(:, selSources3)*Z3(selSources3, :); %Creating denoised signals


%***************Plotting denoised signals**********
X = data1_denoised;
offset = max(abs(X(:))) ;
fs = 250 ;
ElecName = electrodes.labels ;
disp_eeg(X,offset,fs,ElecName);
title('Denoised Data1');

X = data3_denoised;
offset = max(abs(X(:))) ;
disp_eeg(X,offset,fs,ElecName);
title('Denoised Data3');
%**************************************************

