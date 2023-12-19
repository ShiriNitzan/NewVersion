function [numberOfChoice] = choiceList(headline,instraction,listOfChoice)
beep;
list = listOfChoice;
numberOfChoice = listdlg('PromptString',{instraction,''},...
    'Name',headline,...
    'SelectionMode','single','ListString',list);

