hFig=figure(3);
set(hFig,'Name','Create motion trajectories','NumberTitle','Off','MenuBar','None','Position',[706   556   564   426],'Resize','On');
%WinOnTop(hFig,true);

%%% Add subfolders
path_dir=fileparts(mfilename('fullpath'));
addpath(genpath(path_dir))