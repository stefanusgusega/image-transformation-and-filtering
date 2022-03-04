classdef app_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        TabGroup                        matlab.ui.container.TabGroup
        LPFTab                          matlab.ui.container.Tab
        LPFOutputImageLabel             matlab.ui.control.Label
        LPFInputImageLabel              matlab.ui.control.Label
        LPFFilterOrderEditField         matlab.ui.control.NumericEditField
        ButterworthFilterOrderLabel     matlab.ui.control.Label
        LPFFilterImageButton            matlab.ui.control.Button
        LPFUploadImageButton            matlab.ui.control.Button
        LPFCutoffFrequencyEditField     matlab.ui.control.NumericEditField
        CutoffFrequencyEditFieldLabel   matlab.ui.control.Label
        LPFPassFilterNameDropDown       matlab.ui.control.DropDown
        PassFilterNameDropDownLabel     matlab.ui.control.Label
        LPFLabel                        matlab.ui.control.Label
        LPFOutputAxes                   matlab.ui.control.UIAxes
        LPFInputAxes                    matlab.ui.control.UIAxes
        HPFTab                          matlab.ui.container.Tab
        HPFOutputImageLabel             matlab.ui.control.Label
        HPFInputImageLabel              matlab.ui.control.Label
        HPFFilterOrderEditField         matlab.ui.control.NumericEditField
        HPFButterworthFilterOrderLabel  matlab.ui.control.Label
        HPFFilterImageButton            matlab.ui.control.Button
        HPFUploadImageButton            matlab.ui.control.Button
        HPFCutoffFrequencyEditField     matlab.ui.control.NumericEditField
        HPFCutoffFrequencyEditFieldLabel  matlab.ui.control.Label
        HPFPassFilterNameDropDown       matlab.ui.control.DropDown
        HPFPassFilterNameDropDownLabel  matlab.ui.control.Label
        HPFLabel                        matlab.ui.control.Label
        HPFOutputAxes                   matlab.ui.control.UIAxes
        HPFInputAxes                    matlab.ui.control.UIAxes
        HighBoostFilterTab              matlab.ui.container.Tab
        HBFOutputImageLabel             matlab.ui.control.Label
        HBFInputImageLabel              matlab.ui.control.Label
        HBFAmpFactorEditField           matlab.ui.control.NumericEditField
        HBFAmpFactorLabel               matlab.ui.control.Label
        HBFFilterOrderEditField         matlab.ui.control.NumericEditField
        HBFButterworthFilterOrderLabel  matlab.ui.control.Label
        HBFFilterImageButton            matlab.ui.control.Button
        HBFUploadImageButton            matlab.ui.control.Button
        HBFCutoffFrequencyEditField     matlab.ui.control.NumericEditField
        HBFCutoffFrequencyEditFieldLabel  matlab.ui.control.Label
        HBFPassFilterNameDropDown       matlab.ui.control.DropDown
        HBFPassFilterNameDropDownLabel  matlab.ui.control.Label
        HBFLabel                        matlab.ui.control.Label
        HBFOutputAxes                   matlab.ui.control.UIAxes
        HBFInputAxes                    matlab.ui.control.UIAxes
        NoiseReductionTab               matlab.ui.container.Tab
        OutputImageLabel                matlab.ui.control.Label
        InputImageLabel                 matlab.ui.control.Label
        HBFLabel_2                      matlab.ui.control.Label
        SelectImageDropDown             matlab.ui.control.DropDown
        SelectImageDropDownLabel        matlab.ui.control.Label
        FourierSpectrumLabel_2          matlab.ui.control.Label
        FourierSpectrumLabel            matlab.ui.control.Label
        NoiseSpectrumOutAxes            matlab.ui.control.UIAxes
        NoiseSpectrumInAxes             matlab.ui.control.UIAxes
        NoiseOutputImageAxes            matlab.ui.control.UIAxes
        NoiseInputImageAxes             matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        imageaxes_arr % Array to store input image axes
        outaxes_arr % Array to store output image axes
        lpf_fname % Filename for low pass filter image
        hpf_fname % Filename for high pass filter image
        hbf_fname % Filename for high boost filter image
        noise_fname % Filename for notch filter image
    end
    
    methods (Access = private)
        
        function initiateImageAxesComponent(app, component)
            component.Visible = 'off';
            component.Colormap = gray(256);
            axis(component, 'image');
        end
        
        function updateImage(app, fname, tab_num)
            % Read the image
            try
                im = imread(fname);
            catch ME
                % if problem reading image, display error message
                uialert(app.UIFigure, ME.message, 'Image Error');
                return;
            end
            
            % assign current tab input
            currImageAxes = app.imageaxes_arr(tab_num);
            
            % assign current tab output
            currOutAxes = app.outaxes_arr(tab_num);    

            % display the image
            imagesc(currImageAxes, im);

            if (tab_num==4)
                % display input spectrum
                showSpectrum(app, app.NoiseSpectrumInAxes, im(:,:,1));
            end

            % create histograms based on number of color channel
            switch size(im,3)
                case 1
                    % Display the grayscale image

                    imgOut = getOutput(app, im, tab_num);
                    imagesc(currOutAxes, imgOut);

                case 3
                    imgOut(:,:,1) = getOutput(app, im(:,:,1), tab_num);
%                     figure, imshow(imgOut(:,:,1));
                    imgOut(:,:,2) = getOutput(app, im(:,:,2), tab_num);
%                     figure, imshow(imgOut(:,:,2));
                    imgOut(:,:,3) = getOutput(app, im(:,:,3), tab_num);
%                     figure, imshow(imgOut(:,:,3));

                    imagesc(currOutAxes, imgOut);
                    
                otherwise
                    % Error when image is not grayscale or truecolor
                    uialert(app.UIFigure, 'Image must be grayscale or truecolor.', 'Image Error');
                    return;
            end 

            if (tab_num==4)
                % display output spectrum
                showSpectrum(app, app.NoiseSpectrumOutAxes, imgOut(:,:,1));
            end
            
        end
        
        function [imgOut] = getOutput(app, im, tab_num)

            switch (tab_num)
                case 1
                    % Low pass filter
                    filter_name = lower(app.LPFPassFilterNameDropDown.Value);
                    cutoff_freq = app.LPFCutoffFrequencyEditField.Value;
                    filter_order = app.LPFFilterOrderEditField.Value;
                    imgOut = pass_filter(im, 'low', filter_name, cutoff_freq, filter_order);
                case 2
                    % High pass filter
                    filter_name = lower(app.HPFPassFilterNameDropDown.Value);
                    cutoff_freq = app.HPFCutoffFrequencyEditField.Value;
                    filter_order = app.HPFFilterOrderEditField.Value;
                    imgOut = pass_filter(im, 'high', filter_name, cutoff_freq, filter_order);
                case 3
                    % High boost filter
                    filter_name = lower(app.HBFPassFilterNameDropDown.Value);
                    cutoff_freq = app.HBFCutoffFrequencyEditField.Value;
                    filter_order = app.HBFFilterOrderEditField.Value;
                    amp_coef = app.HBFAmpFactorEditField.Value;
                    imgOut = high_boost_filter(im, amp_coef, filter_name, cutoff_freq, filter_order);
                case 4
                    % Noise Reduction
                    noise_type = app.SelectImageDropDown.Value(7);
                    imgOut = notch(im, noise_type);
                    %imgOut = notch_filter(freqIn, arr_x, arr_x1);
                otherwise
                    % Error when the tab is undefined
                    uialert(app.UIFigure, 'Tab invalid.', 'Image Error');
                    return;
            end
        end
        
        function showSpectrum(app, axes, im)
            % fourier transform
            freq = fourier_spectrum(im);

            % transformation for display
            freqDisp = display_spectrum(freq);

            % for checking
            % figure, imagesc(freqDisp), colormap("gray");
            
            % display in the axes
            imshow(freqDisp, [], 'Parent', axes);
            axis(axes, 'on');

            % Get largest bin count
            [x, y] = size(freqDisp);
            
            % Set axes limits based on largest bin count
            axes.XLim = [0 x];
            axes.XTick = round([0 x/2 x], 2, 'significant');
            axes.YLim = [0 y];
            axes.YTick = round([0 y/2 y], 2, 'significant');
            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.imageaxes_arr = [app.LPFInputAxes, app.HPFInputAxes, app.HBFInputAxes, app.NoiseInputImageAxes];

            app.outaxes_arr = [app.LPFOutputAxes, app.HPFOutputAxes, app.HBFOutputAxes, app.NoiseOutputImageAxes];
            
            % image path
            path = [pwd filesep '..' filesep 'images' filesep];

            % Show loading dialog
            d = uiprogressdlg(app.UIFigure, 'Title', 'Filtering image...', 'Indeterminate', 'on');
            drawnow

            %% Low Pass Filter
            initiateImageAxesComponent(app, app.LPFInputAxes);
            initiateImageAxesComponent(app, app.LPFOutputAxes);
            app.lpf_fname = [path 'LPF_3.jpg'];

            updateImage(app, app.lpf_fname, 1);

            %% High Pass Filter
            initiateImageAxesComponent(app, app.HPFInputAxes);
            initiateImageAxesComponent(app, app.HPFOutputAxes);
            app.hpf_fname = [path 'HPF_2.jpg'];
            
            updateImage(app, app.hpf_fname, 2);

            %% High Boost Filter
            initiateImageAxesComponent(app, app.HBFInputAxes);
            initiateImageAxesComponent(app, app.HBFOutputAxes);
            app.hbf_fname = [path 'filter_input.jpg'];
            
            updateImage(app, app.hbf_fname, 3);

            %% Notch (Noise Reduction)
            initiateImageAxesComponent(app, app.NoiseInputImageAxes);
            initiateImageAxesComponent(app, app.NoiseOutputImageAxes);
            initiateImageAxesComponent(app, app.NoiseSpectrumInAxes);
            initiateImageAxesComponent(app, app.NoiseSpectrumOutAxes);
            app.noise_fname = [path 'noisy_image_a.jpg'];

            updateImage(app, app.noise_fname, 4);

            % Close the loading dialog
            close(d);
        end

        % Button pushed function: LPFFilterImageButton
        function LPFFilterImageButtonPushed(app, event)
            d = uiprogressdlg(app.UIFigure, 'Title', 'Filtering image...', 'Indeterminate', 'on');
            drawnow

            updateImage(app, app.lpf_fname, 1);

            close(d);
        end

        % Button pushed function: LPFUploadImageButton
        function LPFUploadImageButtonPushed(app, event)
            % Display uigetfile dialog
            filterspec = {'*.jpg;*.tif;*.png;*.gif','All Image Files'};
            [f, p] = uigetfile(filterspec);
            
            % Make sure user didn't cancel uigetfile dialog
            if (ischar(p))
               app.lpf_fname = [p f];
               d = uiprogressdlg(app.UIFigure, 'Title', 'Filtering image...', 'Indeterminate', 'on');
               drawnow
               updateImage(app, app.lpf_fname, 1);
               close(d);
            end
        end

        % Button pushed function: HPFFilterImageButton
        function HPFFilterImageButtonPushed(app, event)
            d = uiprogressdlg(app.UIFigure, 'Title', 'Filtering image...', 'Indeterminate', 'on');
            drawnow

            updateImage(app, app.hpf_fname, 2);

            close(d);
        end

        % Button pushed function: HPFUploadImageButton
        function HPFUploadImageButtonPushed(app, event)
            % Display uigetfile dialog
            filterspec = {'*.jpg;*.tif;*.png;*.gif','All Image Files'};
            [f, p] = uigetfile(filterspec);
            
            % Make sure user didn't cancel uigetfile dialog
            if (ischar(p))
               app.hpf_fname = [p f];
               d = uiprogressdlg(app.UIFigure, 'Title', 'Filtering image...', 'Indeterminate', 'on');
               drawnow
               updateImage(app, app.hpf_fname, 2);
               close(d);
            end
        end

        % Button pushed function: HBFFilterImageButton
        function HBFFilterImageButtonPushed(app, event)
            d = uiprogressdlg(app.UIFigure, 'Title', 'Filtering image...', 'Indeterminate', 'on');
            drawnow

            updateImage(app, app.hbf_fname, 3);

            close(d);
        end

        % Button pushed function: HBFUploadImageButton
        function HBFUploadImageButtonPushed(app, event)
            % Display uigetfile dialog
            filterspec = {'*.jpg;*.tif;*.png;*.gif','All Image Files'};
            [f, p] = uigetfile(filterspec);
            
            % Make sure user didn't cancel uigetfile dialog
            if (ischar(p))
               app.hbf_fname = [p f];
               d = uiprogressdlg(app.UIFigure, 'Title', 'Filtering image...', 'Indeterminate', 'on');
               drawnow
               updateImage(app, app.hbf_fname, 3);
               close(d);
            end
        end

        % Value changed function: SelectImageDropDown
        function SelectImageDropDownValueChanged(app, event)
            value = app.SelectImageDropDown.Value;
            % image path
            path = [pwd filesep '..' filesep 'images' filesep];
            app.noise_fname = [path, 'noisy_image_', value(7), '.jpg'];

            updateImage(app, app.noise_fname, 4)
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 494];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 15 640 480];

            % Create LPFTab
            app.LPFTab = uitab(app.TabGroup);
            app.LPFTab.Title = 'LPF';

            % Create LPFInputAxes
            app.LPFInputAxes = uiaxes(app.LPFTab);
            zlabel(app.LPFInputAxes, 'Z')
            app.LPFInputAxes.XTick = [];
            app.LPFInputAxes.YTick = [];
            app.LPFInputAxes.Position = [22 212 280 185];

            % Create LPFOutputAxes
            app.LPFOutputAxes = uiaxes(app.LPFTab);
            zlabel(app.LPFOutputAxes, 'Z')
            app.LPFOutputAxes.XTick = [];
            app.LPFOutputAxes.YTick = [];
            app.LPFOutputAxes.Position = [326 212 280 185];

            % Create LPFLabel
            app.LPFLabel = uilabel(app.LPFTab);
            app.LPFLabel.FontSize = 24;
            app.LPFLabel.FontWeight = 'bold';
            app.LPFLabel.Position = [42 404 218 31];
            app.LPFLabel.Text = 'Low Pass Filter';

            % Create PassFilterNameDropDownLabel
            app.PassFilterNameDropDownLabel = uilabel(app.LPFTab);
            app.PassFilterNameDropDownLabel.HorizontalAlignment = 'right';
            app.PassFilterNameDropDownLabel.Position = [48 115 97 22];
            app.PassFilterNameDropDownLabel.Text = 'Pass Filter Name';

            % Create LPFPassFilterNameDropDown
            app.LPFPassFilterNameDropDown = uidropdown(app.LPFTab);
            app.LPFPassFilterNameDropDown.Items = {'Ideal', 'Butterworth', 'Gaussian'};
            app.LPFPassFilterNameDropDown.Position = [160 115 100 22];
            app.LPFPassFilterNameDropDown.Value = 'Ideal';

            % Create CutoffFrequencyEditFieldLabel
            app.CutoffFrequencyEditFieldLabel = uilabel(app.LPFTab);
            app.CutoffFrequencyEditFieldLabel.HorizontalAlignment = 'right';
            app.CutoffFrequencyEditFieldLabel.Position = [48 83 97 22];
            app.CutoffFrequencyEditFieldLabel.Text = 'Cutoff Frequency';

            % Create LPFCutoffFrequencyEditField
            app.LPFCutoffFrequencyEditField = uieditfield(app.LPFTab, 'numeric');
            app.LPFCutoffFrequencyEditField.Position = [160 82 100 22];
            app.LPFCutoffFrequencyEditField.Value = 51.2;

            % Create LPFUploadImageButton
            app.LPFUploadImageButton = uibutton(app.LPFTab, 'push');
            app.LPFUploadImageButton.ButtonPushedFcn = createCallbackFcn(app, @LPFUploadImageButtonPushed, true);
            app.LPFUploadImageButton.Position = [42 155 100 22];
            app.LPFUploadImageButton.Text = 'Upload Image';

            % Create LPFFilterImageButton
            app.LPFFilterImageButton = uibutton(app.LPFTab, 'push');
            app.LPFFilterImageButton.ButtonPushedFcn = createCallbackFcn(app, @LPFFilterImageButtonPushed, true);
            app.LPFFilterImageButton.Position = [202 155 100 22];
            app.LPFFilterImageButton.Text = 'Filter Image';

            % Create ButterworthFilterOrderLabel
            app.ButterworthFilterOrderLabel = uilabel(app.LPFTab);
            app.ButterworthFilterOrderLabel.HorizontalAlignment = 'right';
            app.ButterworthFilterOrderLabel.Position = [15 52 130 22];
            app.ButterworthFilterOrderLabel.Text = 'Butterworth Filter Order';

            % Create LPFFilterOrderEditField
            app.LPFFilterOrderEditField = uieditfield(app.LPFTab, 'numeric');
            app.LPFFilterOrderEditField.Position = [160 52 100 22];
            app.LPFFilterOrderEditField.Value = 2;

            % Create LPFInputImageLabel
            app.LPFInputImageLabel = uilabel(app.LPFTab);
            app.LPFInputImageLabel.Position = [140 191 68 22];
            app.LPFInputImageLabel.Text = 'Input Image';

            % Create LPFOutputImageLabel
            app.LPFOutputImageLabel = uilabel(app.LPFTab);
            app.LPFOutputImageLabel.Position = [439 191 78 22];
            app.LPFOutputImageLabel.Text = 'Output Image';

            % Create HPFTab
            app.HPFTab = uitab(app.TabGroup);
            app.HPFTab.Title = 'HPF';

            % Create HPFInputAxes
            app.HPFInputAxes = uiaxes(app.HPFTab);
            zlabel(app.HPFInputAxes, 'Z')
            app.HPFInputAxes.XTick = [];
            app.HPFInputAxes.YTick = [];
            app.HPFInputAxes.Position = [22 212 280 185];

            % Create HPFOutputAxes
            app.HPFOutputAxes = uiaxes(app.HPFTab);
            zlabel(app.HPFOutputAxes, 'Z')
            app.HPFOutputAxes.XTick = [];
            app.HPFOutputAxes.YTick = [];
            app.HPFOutputAxes.Position = [326 212 280 185];

            % Create HPFLabel
            app.HPFLabel = uilabel(app.HPFTab);
            app.HPFLabel.FontSize = 24;
            app.HPFLabel.FontWeight = 'bold';
            app.HPFLabel.Position = [42 404 218 31];
            app.HPFLabel.Text = 'High Pass Filter';

            % Create HPFPassFilterNameDropDownLabel
            app.HPFPassFilterNameDropDownLabel = uilabel(app.HPFTab);
            app.HPFPassFilterNameDropDownLabel.HorizontalAlignment = 'right';
            app.HPFPassFilterNameDropDownLabel.Position = [48 115 97 22];
            app.HPFPassFilterNameDropDownLabel.Text = 'Pass Filter Name';

            % Create HPFPassFilterNameDropDown
            app.HPFPassFilterNameDropDown = uidropdown(app.HPFTab);
            app.HPFPassFilterNameDropDown.Items = {'Ideal', 'Butterworth', 'Gaussian'};
            app.HPFPassFilterNameDropDown.Position = [160 115 100 22];
            app.HPFPassFilterNameDropDown.Value = 'Ideal';

            % Create HPFCutoffFrequencyEditFieldLabel
            app.HPFCutoffFrequencyEditFieldLabel = uilabel(app.HPFTab);
            app.HPFCutoffFrequencyEditFieldLabel.HorizontalAlignment = 'right';
            app.HPFCutoffFrequencyEditFieldLabel.Position = [48 83 97 22];
            app.HPFCutoffFrequencyEditFieldLabel.Text = 'Cutoff Frequency';

            % Create HPFCutoffFrequencyEditField
            app.HPFCutoffFrequencyEditField = uieditfield(app.HPFTab, 'numeric');
            app.HPFCutoffFrequencyEditField.Position = [160 82 100 22];
            app.HPFCutoffFrequencyEditField.Value = 51.2;

            % Create HPFUploadImageButton
            app.HPFUploadImageButton = uibutton(app.HPFTab, 'push');
            app.HPFUploadImageButton.ButtonPushedFcn = createCallbackFcn(app, @HPFUploadImageButtonPushed, true);
            app.HPFUploadImageButton.Position = [42 155 100 22];
            app.HPFUploadImageButton.Text = 'Upload Image';

            % Create HPFFilterImageButton
            app.HPFFilterImageButton = uibutton(app.HPFTab, 'push');
            app.HPFFilterImageButton.ButtonPushedFcn = createCallbackFcn(app, @HPFFilterImageButtonPushed, true);
            app.HPFFilterImageButton.Position = [202 155 100 22];
            app.HPFFilterImageButton.Text = 'Filter Image';

            % Create HPFButterworthFilterOrderLabel
            app.HPFButterworthFilterOrderLabel = uilabel(app.HPFTab);
            app.HPFButterworthFilterOrderLabel.HorizontalAlignment = 'right';
            app.HPFButterworthFilterOrderLabel.Position = [15 52 130 22];
            app.HPFButterworthFilterOrderLabel.Text = 'Butterworth Filter Order';

            % Create HPFFilterOrderEditField
            app.HPFFilterOrderEditField = uieditfield(app.HPFTab, 'numeric');
            app.HPFFilterOrderEditField.Position = [160 52 100 22];
            app.HPFFilterOrderEditField.Value = 2;

            % Create HPFInputImageLabel
            app.HPFInputImageLabel = uilabel(app.HPFTab);
            app.HPFInputImageLabel.Position = [140 191 68 22];
            app.HPFInputImageLabel.Text = 'Input Image';

            % Create HPFOutputImageLabel
            app.HPFOutputImageLabel = uilabel(app.HPFTab);
            app.HPFOutputImageLabel.Position = [439 191 78 22];
            app.HPFOutputImageLabel.Text = 'Output Image';

            % Create HighBoostFilterTab
            app.HighBoostFilterTab = uitab(app.TabGroup);
            app.HighBoostFilterTab.Title = 'High Boost Filter';

            % Create HBFInputAxes
            app.HBFInputAxes = uiaxes(app.HighBoostFilterTab);
            zlabel(app.HBFInputAxes, 'Z')
            app.HBFInputAxes.XTick = [];
            app.HBFInputAxes.YTick = [];
            app.HBFInputAxes.Position = [22 212 280 185];

            % Create HBFOutputAxes
            app.HBFOutputAxes = uiaxes(app.HighBoostFilterTab);
            zlabel(app.HBFOutputAxes, 'Z')
            app.HBFOutputAxes.XTick = [];
            app.HBFOutputAxes.YTick = [];
            app.HBFOutputAxes.Position = [326 212 280 185];

            % Create HBFLabel
            app.HBFLabel = uilabel(app.HighBoostFilterTab);
            app.HBFLabel.FontSize = 24;
            app.HBFLabel.FontWeight = 'bold';
            app.HBFLabel.Position = [42 404 218 31];
            app.HBFLabel.Text = 'High Boost Filter';

            % Create HBFPassFilterNameDropDownLabel
            app.HBFPassFilterNameDropDownLabel = uilabel(app.HighBoostFilterTab);
            app.HBFPassFilterNameDropDownLabel.HorizontalAlignment = 'right';
            app.HBFPassFilterNameDropDownLabel.Position = [48 113 97 22];
            app.HBFPassFilterNameDropDownLabel.Text = 'Pass Filter Name';

            % Create HBFPassFilterNameDropDown
            app.HBFPassFilterNameDropDown = uidropdown(app.HighBoostFilterTab);
            app.HBFPassFilterNameDropDown.Items = {'Ideal', 'Butterworth', 'Gaussian'};
            app.HBFPassFilterNameDropDown.Position = [160 113 100 22];
            app.HBFPassFilterNameDropDown.Value = 'Ideal';

            % Create HBFCutoffFrequencyEditFieldLabel
            app.HBFCutoffFrequencyEditFieldLabel = uilabel(app.HighBoostFilterTab);
            app.HBFCutoffFrequencyEditFieldLabel.HorizontalAlignment = 'right';
            app.HBFCutoffFrequencyEditFieldLabel.Position = [48 81 97 22];
            app.HBFCutoffFrequencyEditFieldLabel.Text = 'Cutoff Frequency';

            % Create HBFCutoffFrequencyEditField
            app.HBFCutoffFrequencyEditField = uieditfield(app.HighBoostFilterTab, 'numeric');
            app.HBFCutoffFrequencyEditField.Position = [160 80 100 22];
            app.HBFCutoffFrequencyEditField.Value = 51.2;

            % Create HBFUploadImageButton
            app.HBFUploadImageButton = uibutton(app.HighBoostFilterTab, 'push');
            app.HBFUploadImageButton.ButtonPushedFcn = createCallbackFcn(app, @HBFUploadImageButtonPushed, true);
            app.HBFUploadImageButton.Position = [42 153 100 22];
            app.HBFUploadImageButton.Text = 'Upload Image';

            % Create HBFFilterImageButton
            app.HBFFilterImageButton = uibutton(app.HighBoostFilterTab, 'push');
            app.HBFFilterImageButton.ButtonPushedFcn = createCallbackFcn(app, @HBFFilterImageButtonPushed, true);
            app.HBFFilterImageButton.Position = [202 153 100 22];
            app.HBFFilterImageButton.Text = 'Filter Image';

            % Create HBFButterworthFilterOrderLabel
            app.HBFButterworthFilterOrderLabel = uilabel(app.HighBoostFilterTab);
            app.HBFButterworthFilterOrderLabel.HorizontalAlignment = 'right';
            app.HBFButterworthFilterOrderLabel.Position = [15 50 130 22];
            app.HBFButterworthFilterOrderLabel.Text = 'Butterworth Filter Order';

            % Create HBFFilterOrderEditField
            app.HBFFilterOrderEditField = uieditfield(app.HighBoostFilterTab, 'numeric');
            app.HBFFilterOrderEditField.Position = [160 50 100 22];
            app.HBFFilterOrderEditField.Value = 2;

            % Create HBFAmpFactorLabel
            app.HBFAmpFactorLabel = uilabel(app.HighBoostFilterTab);
            app.HBFAmpFactorLabel.HorizontalAlignment = 'right';
            app.HBFAmpFactorLabel.Position = [35 20 110 22];
            app.HBFAmpFactorLabel.Text = 'Amplification Factor';

            % Create HBFAmpFactorEditField
            app.HBFAmpFactorEditField = uieditfield(app.HighBoostFilterTab, 'numeric');
            app.HBFAmpFactorEditField.Limits = [1 Inf];
            app.HBFAmpFactorEditField.Position = [160 20 100 22];
            app.HBFAmpFactorEditField.Value = 2.4;

            % Create HBFInputImageLabel
            app.HBFInputImageLabel = uilabel(app.HighBoostFilterTab);
            app.HBFInputImageLabel.Position = [140 191 68 22];
            app.HBFInputImageLabel.Text = 'Input Image';

            % Create HBFOutputImageLabel
            app.HBFOutputImageLabel = uilabel(app.HighBoostFilterTab);
            app.HBFOutputImageLabel.Position = [439 191 78 22];
            app.HBFOutputImageLabel.Text = 'Output Image';

            % Create NoiseReductionTab
            app.NoiseReductionTab = uitab(app.TabGroup);
            app.NoiseReductionTab.Title = 'Noise Reduction';

            % Create NoiseInputImageAxes
            app.NoiseInputImageAxes = uiaxes(app.NoiseReductionTab);
            zlabel(app.NoiseInputImageAxes, 'Z')
            app.NoiseInputImageAxes.XTick = [];
            app.NoiseInputImageAxes.YTick = [];
            app.NoiseInputImageAxes.Position = [21 216 238 178];

            % Create NoiseOutputImageAxes
            app.NoiseOutputImageAxes = uiaxes(app.NoiseReductionTab);
            zlabel(app.NoiseOutputImageAxes, 'Z')
            app.NoiseOutputImageAxes.XTick = [];
            app.NoiseOutputImageAxes.YTick = [];
            app.NoiseOutputImageAxes.Position = [368 215 241 178];

            % Create NoiseSpectrumInAxes
            app.NoiseSpectrumInAxes = uiaxes(app.NoiseReductionTab);
            zlabel(app.NoiseSpectrumInAxes, 'Z')
            app.NoiseSpectrumInAxes.CLim = [0 1];
            app.NoiseSpectrumInAxes.XTick = [];
            app.NoiseSpectrumInAxes.YTick = [];
            app.NoiseSpectrumInAxes.Position = [21 10 238 171];

            % Create NoiseSpectrumOutAxes
            app.NoiseSpectrumOutAxes = uiaxes(app.NoiseReductionTab);
            zlabel(app.NoiseSpectrumOutAxes, 'Z')
            app.NoiseSpectrumOutAxes.CLim = [0 1];
            app.NoiseSpectrumOutAxes.XTick = [];
            app.NoiseSpectrumOutAxes.YTick = [];
            app.NoiseSpectrumOutAxes.Position = [368 9 241 170];

            % Create FourierSpectrumLabel
            app.FourierSpectrumLabel = uilabel(app.NoiseReductionTab);
            app.FourierSpectrumLabel.Position = [41 186 98 22];
            app.FourierSpectrumLabel.Text = 'Fourier Spectrum';

            % Create FourierSpectrumLabel_2
            app.FourierSpectrumLabel_2 = uilabel(app.NoiseReductionTab);
            app.FourierSpectrumLabel_2.Position = [389 182 98 22];
            app.FourierSpectrumLabel_2.Text = 'Fourier Spectrum';

            % Create SelectImageDropDownLabel
            app.SelectImageDropDownLabel = uilabel(app.NoiseReductionTab);
            app.SelectImageDropDownLabel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.SelectImageDropDownLabel.HorizontalAlignment = 'right';
            app.SelectImageDropDownLabel.FontWeight = 'bold';
            app.SelectImageDropDownLabel.Position = [274 213 79 22];
            app.SelectImageDropDownLabel.Text = 'Select Image';

            % Create SelectImageDropDown
            app.SelectImageDropDown = uidropdown(app.NoiseReductionTab);
            app.SelectImageDropDown.Items = {'image a', 'image b', 'image c'};
            app.SelectImageDropDown.ValueChangedFcn = createCallbackFcn(app, @SelectImageDropDownValueChanged, true);
            app.SelectImageDropDown.BackgroundColor = [0.902 0.902 0.902];
            app.SelectImageDropDown.Position = [274 184 83 27];
            app.SelectImageDropDown.Value = 'image a';

            % Create HBFLabel_2
            app.HBFLabel_2 = uilabel(app.NoiseReductionTab);
            app.HBFLabel_2.FontSize = 24;
            app.HBFLabel_2.FontWeight = 'bold';
            app.HBFLabel_2.Position = [40 412 356 31];
            app.HBFLabel_2.Text = 'Noise Reduction (Notch Filter)';

            % Create InputImageLabel
            app.InputImageLabel = uilabel(app.NoiseReductionTab);
            app.InputImageLabel.Position = [42 391 69 22];
            app.InputImageLabel.Text = 'Input Image';

            % Create OutputImageLabel
            app.OutputImageLabel = uilabel(app.NoiseReductionTab);
            app.OutputImageLabel.Position = [389 391 78 22];
            app.OutputImageLabel.Text = 'Output Image';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end