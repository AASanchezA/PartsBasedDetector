function fflush(junk)
%FFLUSH Imitation of Octave's FFLUSH.  
%
%  FFLUSH(stdout) does nothing in Matlab.  stdout is a global variable
%  defined at startup if is_octave = 0.
%
%  Octave often requires a call to fflush following each fprintf statement
%  in order to keep messages in order.  This function is provided to make
%  Octave .m files work in Matlab.
