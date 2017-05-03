%% PicoScope 6000 Series Instrument Driver Oscilloscope ETS Block Data Capture Example
% This is an example of an instrument control session using a device 
% object. The instrument control session comprises all the steps you 
% are likely to take when communicating with your instrument. 
%
% These steps are:
%       
% # Create a device object   
% # Connect to the instrument 
% # Configure properties 
% # Invoke functions 
% # Disconnect from the instrument 
%  
% To run the instrument control session, type the name of the file,
% PS6000_ID_ETS_Block_Example, at the MATLAB command prompt.
% 
% The file, PS6000_ID_ETS_BLOCK_EXAMPLE.M must be on your MATLAB PATH. 
% For additional information on setting your MATLAB PATH, type 
% 'help addpath' at the MATLAB command prompt.
%
% *Example:*
%     PS6000_ID_ETS_Block_Example;
%
% *Description:*
%     Demonstrates how to call functions in order to capture a block of
%     data using Equivalent Time Sampling from a PicoScope 6000 Series 
%     Oscilloscope.
%
% *See also:* <matlab:doc('icdevice') |icdevice|> | <matlab:doc('instrument/invoke') |invoke|>
%
% *Copyright:* © 2014 - 2017 Pico Technology Ltd. See LICENSE file for terms.

%% Suggested Input Test Signal
% This example was published using the following test signal:
%
% * Channel A: 4 Vpp, 2 MHz sine wave

%% Clear Command Window and Close any Figures

clc;
close all;

%% Load Configuration Information

PS6000Config;

%% Device Connection

% Check if an Instrument session using the device object 'ps6000DeviceObj'
% is still open, and if so, disconnect if the User chooses 'Yes' when prompted.
if (exist('ps6000DeviceObj', 'var') && ps6000DeviceObj.isvalid && strcmp(ps6000DeviceObj.status, 'open'))
    
    openDevice = questionDialog(['Device object ps6000DeviceObj has an open connection. ' ...
        'Do you wish to close the connection and continue?'], ...
        'Device Object Connection Open');
    
    if (openDevice == PicoConstants.TRUE)
        
        % Close connection to device
        disconnect(ps6000DeviceObj);
        delete(ps6000DeviceObj);
        
    else

        % Exit script if User selects 'No'
        return;
        
    end
    
end

% Create a device object. 
% The serial number can be specified as a second input parameter.
ps6000DeviceObj = icdevice('picotech_ps6000_generic.mdd', '');

% Connect device object to hardware.
connect(ps6000DeviceObj);

%% Set Channels

% Default driver settings applied to channels are listed below - 
% use ps6000SetChannel to turn channels on or off and set voltage ranges, 
% coupling, as well as analogue offset.

% In this example, data is only collected on Channel A so default settings
% are used and Channels B, C and D are switched off.

% Channels       : 1 - 3 (ps6000Enuminfo.enPS6000Channel.PS6000_CHANNEL_B - PS6000_CHANNEL_D)
% Enabled        : 0 (off)
% Type           : 1 (ps6000Enuminfo.enPS6000Coupling.PS6000_DC_1M)
% Range          : 3 (ps6000Enuminfo.enPS6000Range.PS6000_100MV) for the PicoScope 6407 or 
%                  8 (ps6000Enuminfo.enPS6000Range.PS6000_5V) for all other PicoScope 6000 Series models
% Analogue Offset: 0.0
% Bandwidth      : 0 (ps6000Enuminfo.enPS6000BandwidthLimiter.PS6000_BW_FULL)

% Select the correct voltage range and coupling to use

voltageRangeIndex = ps6000Enuminfo.enPS6000Range.PS6000_5V;
coupling          = ps6000Enuminfo.enPS6000Coupling.PS6000_DC_1M;

if (strcmp(ps6000DeviceObj.InstrumentModel, PS6000Constants.MODEL_PS6407))

    voltageRangeIndex = ps6000Enuminfo.enPS6000Range.PS6000_100MV;
    coupling          = ps6000Enuminfo.enPS6000Coupling.PS6000_DC_50R;
   
end

% Execute device object function(s).
[status.setChB] = invoke(ps6000DeviceObj, 'ps6000SetChannel', 1, 0, coupling, voltageRangeIndex, 0.0, 0);
[status.setChC] = invoke(ps6000DeviceObj, 'ps6000SetChannel', 2, 0, coupling, voltageRangeIndex, 0.0, 0);
[status.setChD] = invoke(ps6000DeviceObj, 'ps6000SetChannel', 3, 0, coupling, voltageRangeIndex, 0.0, 0);

%% Set ETS Mode Parameters
% Set Equivalent Time Sampling Parameters
% The underlying driver will return the sampling interval to be used (in
% picoseconds).

% Block data acquisition properties and functions are located in the 
% Instrument Driver's Block group.

blockGroupObj = get(ps6000DeviceObj, 'Block');
blockGroupObj = blockGroupObj(1);

mode            = ps6000Enuminfo.enPS6000EtsMode.PS6000_ETS_FAST;
etsCycles       = 20;
etsInterleave   = 4;

[status.setEts, sampleTimePicoSeconds] = invoke(blockGroupObj, 'ps6000SetEts', mode, etsCycles, etsInterleave);

%% Verify Maximum Samples
% Use a fast timebase index for calling the ps6000GetTimebase2 function
% to query the driver as to the maximum number of samples available in the
% buffer memory. The sample time for ETS mode is returned in the call to
% ps6000SetEts above.
%
% When calling the runBlock or ps6000RunBlock function with ETS mode set, a
% timebase index of 0, 1 or 2 must be used.

% timebase     : 0
% segment index: 0

timebaseIndex = 0;

[status.getTimebase2, ~, maxSamples] = invoke(ps6000DeviceObj, 'ps6000GetTimebase2', timebaseIndex, 0);

set(ps6000DeviceObj, 'timebase', timebaseIndex);
  
%% Set Simple Trigger
% Set a trigger on Channel A, with an indefinite wait for a trigger - the
% default value for delay is used. In this example, to trigger the
% oscilloscope, a signal must have rising edge passing through 500mV on
% Channel A.

% Trigger properties and functions are located in the Instrument
% Driver's Trigger group.

triggerGroupObj = get(ps6000DeviceObj, 'Trigger');
triggerGroupObj = triggerGroupObj(1);

% Set the autoTriggerMs property to 0 to wait indefinitely for a trigger event.

set(triggerGroupObj, 'autoTriggerMs', 0);

% Channel     : 0 (ps6000Enuminfo.enPS6000Channel.PS6000_CHANNEL_A)
% Threshold   : 50 mV (for the PicoScope 6407) or 500 mV otherwise
% Direction   : 2 (ps6000Enuminfo.enPS6000ThresholdDirection.PS6000_RISING)

thresholdVoltage = 500;

if (strcmp(ps6000DeviceObj.InstrumentModel, PS6000Constants.MODEL_PS6407))
   
    thresholdVoltage = 50;
    
end

[status.setSimpleTrigger] = invoke(triggerGroupObj, 'setSimpleTrigger', 0, thresholdVoltage, 2);

%% Set Block Parameters and Capture Data
% Capture a block of data and retrieve data values for Channel A.

% Set pre-trigger and post-trigger samples as required - the total of this
% should not exceed the value of maxSamples returned from the call to
% ps6000GetTimebase2.

set(ps6000DeviceObj, 'numPreTriggerSamples', 0);
set(ps6000DeviceObj, 'numPostTriggerSamples', 10000);

%%
% This example uses the _runBlock_ function in order to collect a block of
% data - if other code needs to be executed while waiting for the device to
% indicate that it is ready, use the _ps6000RunBlock_ function and poll
% the _ps6000IsReady_ function.

% Capture a block of data:
%
% segment index: 0 (The buffer memory is not segmented in this example)

[status.runBlock] = invoke(blockGroupObj, 'runBlock', 0);

pause(2);

% Retrieve data values:
%
% start index       : 0
% downsampling ratio: 1
% downsampling mode : 0 (ps6000Enuminfo.enPS6000RatioMode.PS6000_RATIO_MODE_NONE)

% Provide additional output arguments for the remaining channels e.g. chB
% for Channel B.
[numSamples, overflow, etsTimes, chA, ~, ~, ~] = invoke(blockGroupObj, 'getEtsBlockData', 0, 0, 1, 0);

% Stop the device
[status.stop] = invoke(ps6000DeviceObj, 'ps6000Stop');

%% Process Data 
% Plot data values returned from the device.

figure1 = figure('Name','PicoScope 6000 Series Example - ETS Block Mode Capture', ...
    'NumberTitle', 'off');

% Channel A
plot(etsTimes, chA);
title('Channel A', 'FontWeight', 'bold');
xlabel('Time (fs)');
ylabel('Voltage (mV)');
grid on;

%% Turn off ETS Mode
% If another operation is required that does not require Equivalent Time
% Sampling of data, turn ETS mode off.

mode            = ps6000Enuminfo.enPS6000EtsMode.PS6000_ETS_OFF;
etsCycles       = 20;
etsInterleave   = 4;

[status.setEts, ~] = invoke(blockGroupObj, 'ps6000SetEts', mode, etsCycles, etsInterleave);

%% Disconnect Device
% Disconnect device object from hardware.

disconnect(ps6000DeviceObj);
delete(ps6000DeviceObj);