%PS6000Constants Defines PicoScope 6000 Series constants from the header file ps6000Api.h
%
% The PS6000Constants class defines a number of constant values that can
% be used to define the properties of a PicoScope 6000 Series
% Oscilloscope or for passing as parameters to function calls.
%
% The properties in this file are divided into the following
% sub-sections:
% 
% * ADC Count Properties
% * ETS Mode Properties
% * Trigger Properties
% * Analogue offset values
% * Function/Arbitrary Waveform Parameters
% * Maximum/Minimum Waveform Frequencies
% * PicoScope 6000 Series Models
%
% Ensure that this class file is on the MATLAB Path.		
%
% Copyright: © 2013 - 2015 Pico Technology Ltd. All rights reserved.	

classdef PS6000Constants
    
    properties (Constant)
        
		% ADC Count Properties
		
        PS6000_MAX_VALUE	        = 32512;
		PS6000_MIN_VALUE	        = -32512;
        
        % AUX IN count value
        
        PS6000_MAX_AUX_IN_VALUE     = 32512;
        
		% ETS Mode Properties
		
        PS6000_MAX_ETS_CYCLES      	= 250;		
        PS6000_MAX_ETS_INTERLEAVE  	= 50;

		% Trigger Properties
		
        MAX_PULSE_WIDTH_QUALIFIER_COUNT 	= 16777215;
		
		% Analogue offset values (Volts)
		
		% Supported by the PS6402 and PS6403.
		% For other devices use GetAnalogueOffset also
		% PS6402 and PS6403 supports this function
        MAX_ANALOGUE_OFFSET_50MV_200MV = 0.500;
        MIN_ANALOGUE_OFFSET_50MV_200MV = -0.500;
        MAX_ANALOGUE_OFFSET_500MV_2V   = 2.500;
        MIN_ANALOGUE_OFFSET_500MV_2V   = -2.500;
        MAX_ANALOGUE_OFFSET_5V_20V     = 20;
        MIN_ANALOGUE_OFFSET_5V_20V	   = -20;
		
		% Function/Arbitrary Waveform Parameters
		
		MAX_SIG_GEN_BUFFER_SIZE_PS640X_A_B 	= 16384;
        MAX_SIG_GEN_BUFFER_SIZE_PS640X_C_D 	= 65536;
		
		MIN_SIG_GEN_FREQ = 0.0;
        MAX_SIG_GEN_FREQ = 20000000.0;

        MIN_SIG_GEN_BUFFER_SIZE         = 1;
        MIN_DWELL_COUNT                 = 3;
        MAX_SWEEPS_SHOTS				= pow2(30) - 1; 

        % Maximum/Minimum Waveform Frequencies (in Hertz)
        
        PS6000_SINE_MAX_FREQUENCY		= 20000000;
        PS6000_SQUARE_MAX_FREQUENCY		= 20000000;
        PS6000_TRIANGLE_MAX_FREQUENCY	= 20000000;
        PS6000_SINC_MAX_FREQUENCY		= 20000000
        PS6000_RAMP_MAX_FREQUENCY		= 20000000;
        PS6000_HALF_SINE_MAX_FREQUENCY	= 20000000;
        PS6000_GAUSSIAN_MAX_FREQUENCY  	= 20000000;
        PS6000_PRBS_MAX_FREQUENCY		= 1000000;
        PS6000_PRBS_MIN_FREQUENCY		= 0.03;
        PS6000_MIN_FREQUENCY			= 0.03;
    
        % PicoScope 6000 Series Models
        
        MODEL_NONE      = 'NONE';
        
        % Variants that can be used
		MODEL_PS6402A   = '6402A';
		MODEL_PS6402B   = '6402B';
        MODEL_PS6402C   = '6402C';
		MODEL_PS6402D   = '6402D';
		
		MODEL_PS6403A   = '6403A';
		MODEL_PS6403B   = '6403B';
		MODEL_PS6403C   = '6403C';
		MODEL_PS6403D   = '6403D';
		
		MODEL_PS6404A   = '6404A';
		MODEL_PS6404B   = '6404B';
		MODEL_PS6404C   = '6404C';
		MODEL_PS6404D   = '6404D';
         
        MODEL_PS6407    = '6407';
    
    end

end

