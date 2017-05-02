%% PicoScope 6000 Series Instrument Driver Oscilloscope Signal Generator Example
% Code for communicating with an instrument in order to control the
% signal generator.
%
% This is a modified version of a machine generated representation of an 
% instrument control session using a device object. The instrument 
% control session comprises all the steps you are likely to take when 
% communicating with your instrument. 
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
% PS6000_ID_Sig_Gen_Example, at the MATLAB command prompt.
% 
% The file, PS6000_ID_SIG_GEN_EXAMPLE.M must be on your MATLAB PATH. For
% additional information on setting your MATLAB PATH, type 'help addpath'
% at the MATLAB command prompt.
%
% *Example:*
%   PS6000_ID_Sig_Gen_Example;
%
% *Description:*
%     Demonstrates how to set properties and call functions in order to
%     control the signal generator output of a PicoScope 6000 Series
%     Oscilloscope.
%
% *See also:* <matlab:doc('icdevice') |icdevice|> | <matlab:doc('instrument/invoke') |invoke|>
%
% *Copyright:* © 2014 - 2017 Pico Technology Ltd. All rights reserved.

%% Test Setup
% For this example the 'SIGNAL OUT' connector of the oscilloscope was
% connected to Channel A on another PicoScope oscilloscope running the
% PicoScope 6 software application. Images, where shown, depict output, or
% part of the output in the PicoScope 6 display.
%
% *Note:* The various signal generator functions called in this script may
% be combined with the functions used in the various data acquisition
% examples in order to output a signal and acquire data. These functions
% should be called prior to the start of data collection.

%% Clear Command Window and Close any Figures

clc;
close all;

%% Load Configuration Information

PS6000Config;

%% Device Connection

% Create a device object. 
% The serial number can be specified as a second input parameter.
ps6000DeviceObj = icdevice('picotech_ps6000_generic.mdd');

% Connect device object to hardware.
connect(ps6000DeviceObj);

%% Obtain Signal Generator Group Object
% Signal Generator properties and functions are located in the Instrument
% Driver's Signalgenerator group.

sigGenGroupObj = get(ps6000DeviceObj, 'Signalgenerator');
sigGenGroupObj = sigGenGroupObj(1);

%% Function Generator - Simple
% Output a Sine wave, 2000mVpp, 0mV offset, 1000Hz (uses preset values for
% offset, peak to peak voltage and frequency from the Signalgenerator
% groups's properties).

[status.setSigGenBuiltInSimple] = invoke(sigGenGroupObj, 'setSigGenBuiltInSimple', 0);

%%
% 
% <<../images/ps6000_sine_wave_1kHz.PNG>>
% 

%% Function Generator - Sweep Frequency
% Output a square wave, 2400mVpp, 500mV offset, and sweep continuously from
% 500Hz to 50Hz in steps of 50Hz.

% Set Signalgenerator group properties
set(sigGenGroupObj, 'startFrequency', 50.0); % Hz
set(sigGenGroupObj, 'stopFrequency', 500.0); % Hz
set(sigGenGroupObj, 'offsetVoltage', 500.0); % mV
set(sigGenGroupObj, 'peakToPeakVoltage', 2400.0); % +/-1.2V

% Execute device object function(s).

% Wavetype          : 1 (ps6000Enuminfo.enPS6000WaveType.PS6000_SQUARE) 
% Increment         : 50.0 (Hz)
% Dwell Time        : 1 (s)
% Sweep Type        : 1 (ps6000Enuminfo.enPS6000SweepType.PS6000_DOWN)
% Operation         : 0 (ps6000Enuminfo.enPS6000ExtraOperations.PS6000_ES_OFF)
% Shots             : 0 
% Sweeps            : 0
% Trigger Type      : 0 (ps6000Enuminfo.enPS6000SigGenTrigType.PS6000_SIGGEN_RISING)
% Trigger Source    : 0 (ps6000Enuminfo.enPS6000SigGenTrigSource.PS6000_SIGGEN_NONE)
% Ext. In Threshold : 0 (mV)

[status.setSigGenBuiltIn] = invoke(sigGenGroupObj, 'setSigGenBuiltIn', 1, 50.0, 1, 1, 0, 0, 0, 0, 0, 0);

%%
% 
% <<../images/ps6000_square_wave_sweep_400Hz.PNG>>
% 

%%
% 
% <<../images/ps6000_square_wave_sweep_200Hz.PNG>>
% 

%% Turn Off Signal Generator
% Set the output to 0V DC

[status.setSigGenOff] = invoke(sigGenGroupObj, 'setSigGenOff');

%%
% 
% <<../images/ps6000_sig_gen_off.PNG>>
% 

%% Arbitrary Waveform Generator - Set Parameters
% Set parameters (2000mVpp, 0mV offset, 2000 Hz frequency) and define an
% arbitrary waveform.

% Set Signalgenerator group properties
set(sigGenGroupObj, 'startFrequency', 2000.0); % Hz
set(sigGenGroupObj, 'stopFrequency', 2000.0); % Hz
set(sigGenGroupObj, 'offsetVoltage', 0.0);
set(sigGenGroupObj, 'peakToPeakVoltage', 2000.0); % +/- 1V

%%
% Define an Arbitrary Waveform - values must be in the range -1 to +1.
% Arbitrary waveforms can also be read in from text and csv files using
% |dlmread| and |csvread| respectively or use the |importAWGFile| function
% from the PicoScope Support Toolbox. 
%
% Any AWG files created using the PicoScope 6 application can be read using
% the above method.

awgBufferSize = get(sigGenGroupObj, 'awgBufferSize'); % Obtain the buffer size for the AWG
x = (0: (2*pi)/(awgBufferSize - 1): 2*pi);
y = normalise(sin(x) + sin(2*x));

%% Arbitrary Waveform Generator - Simple
% Output an arbitrary waveform with constant frequency (defined above).

% Arb. Waveform : y (defined above)
[status.setSigGenArbitrarySimple] = invoke(sigGenGroupObj, 'setSigGenArbitrarySimple', y);

%%
% 
% <<../images/ps6000_arbitrary_waveform.PNG>>
% 

%% Turn Off Signal Generator
% Sets the output to 0V DC
[status.setSigGenOff] = invoke(sigGenGroupObj, 'setSigGenOff');

%% Arbitrary Waveform Generator - Output Shots
% Output 2 cycles of an arbitrary waveform using a software trigger.

% Increment         : 0 (Hz)
% Dwell Time        : 1 (s)
% Arb. Waveform     : y (defined above)
% Sweep Type        : 0 (ps6000Enuminfo.enPS6000SweepType.PS6000_UP)
% Operation         : 0 (ps6000Enuminfo.enPS6000ExtraOperations.PS6000_ES_OFF)
% Shots             : 2 
% Sweeps            : 0
% Trigger Type      : 0 (ps6000Enuminfo.enPS6000SigGenTrigType.PS6000_SIGGEN_RISING)
% Trigger Source    : 4 (ps6000Enuminfo.enPS6000SigGenTrigSource.PS6000_SIGGEN_SOFT_TRIG)
% Ext. In Threshold : 0 (mV)
[status.setSigGenArbitrary] = invoke(sigGenGroupObj, 'setSigGenArbitrary', 0, 1, y, 0, 0, 0, 2, 0, 0, 4, 0);

% Trigger the AWG

% State : 1 (a non-zero value will trigger the output)
[status.sigGenSoftwareControl] = invoke(sigGenGroupObj, 'ps6000SigGenSoftwareControl', 1);

%%
% 
% <<../images/ps6000_arbitrary_waveform_shots.PNG>>
% 

%% Turn Off Signal Generator
% Sets the output to 0V DC

[status.setSigGenOff] = invoke(sigGenGroupObj, 'setSigGenOff');

%% Disconnect
% Disconnect device object from hardware.
disconnect(ps6000DeviceObj);
delete(ps6000DeviceObj);
