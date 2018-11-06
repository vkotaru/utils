function varargout = externalfcn(a,varargin);
% VARARGOUT = EXTERNALFCN(A,VARARGIN)
% Parses string arguments to enable calls to functions outside of the
% current workspace.
%
% EX: externalfcn('[x,y] = c:\testdirectory\testfcn(a,b)')
%
% Written by Brett Shoelson, Ph.D.
% 1/13/04
myfcn = a(findstr(a,'=')+1:end);
outargs = a(1:findstr(a,'=')-1);
tmp=cd;
[tmpdir,myfcn]=fileparts(myfcn);
while double(tmpdir(1))==32
	tmpdir=tmpdir(2:end);
end
try
	eval(['cd(''',tmpdir,''')']);
	evalin('base',[outargs,' = ', myfcn]);
catch
	disp('Unable to complete requested action.');
end
cd(tmp);
return
