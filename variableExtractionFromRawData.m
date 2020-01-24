%% This Script extracts variables from raw exp data
%______________________________________________________
clear all
close all
clc

file = 'data';

[out, cho, con, willToExchange, startGood, partnersType, proposedGood, statNumber,...
    subjects, lastR, economyParameters, actualExchange, priors] = getVariables(file);

clear file


function [out, cho, con, willToExchange, startGood, partnersType, proposedGood, statNumber,...
    subjects, lastR, economyParameters, actualExchange, priors] = getVariables(file)

    % ------------------------------------------------------------------- %
    % Import raw data and mimic previously used data structure                
    % --------------------------------------------------------------------%

    data = load(file);
    data = data.data;
    
    % should have stayed the same between the two exp
    economyParameters = [0.995,0.01,...
        0.04,0.09,1,480];
    
    willToExchange = data.willToExchange';

    cellsToModify = {data.startGood',...
        data.partnersType',...
        data.proposedGood'};

    for i = 1:numel(cellsToModify)
        cellsToModify{i}(strcmp(cellsToModify{i}, 'cyan')) = {1};
        cellsToModify{i}(strcmp(cellsToModify{i}, 'yellow')) = {2};
        cellsToModify{i}(strcmp(cellsToModify{i}, 'magenta')) = {3};
    end

    startGood = cellsToModify{1};
    partnersType = cellsToModify{2};
    proposedGood = cellsToModify{3};

    statNumber = data.realNumber';
    subjects = unique(statNumber);
    templastR = zeros(length(subjects), 201);
    templastR(:, 201) = 1;

    for i = 1:length(subjects)
        lastR{1, i} = templastR(i, :);
    end
    
    clear i templastR
    

    % con map blue subject may hold good yellow and magenta (2, 3)
    % conceived based on cond infographic
    conMap = {...
        {NaN},...
        {[NaN, 1, 2];...
        [3, NaN, 4];...
        [5, 6, NaN]}, ...
        {[NaN, 7, 8];...
        [9, NaN, 10];...
        [11, 12, NaN]}, ...
    };
    
    % same priors as before
    priors(1:2) = {[-0.0400000000000000,-0.0400000000000000;...
        -0.0400000000000000,-0.0900000000000000;...
        -0.0400000000000000,0.960000000000000;...
        -0.0400000000000000,-0.0900000000000000;...
        -0.0400000000000000,0.960000000000000;...
        -0.0400000000000000,-0.0400000000000000;...
        -0.0900000000000000,-0.0400000000000000;...
        -0.0900000000000000,-0.0900000000000000;...
        -0.0900000000000000,0.960000000000000;...
        -0.0900000000000000,-0.0900000000000000;...
        -0.0900000000000000,0.960000000000000;...
        -0.0900000000000000,-0.0400000000000000]};

    for sub = subjects
        
        out{sub} = ...
            (data.currentConsumption(data.realNumber==sub)...
            -data.currentStockCost(data.realNumber==sub))'./100;
        actualExchange{sub} = (data.willToExchange(data.realNumber==sub) .* ...
        data.partnersWillToExchange(data.realNumber==sub))';
        cho{sub} = data.willToExchange(data.realNumber==sub)'+1;
        
        for t = 1:length(out{sub})
            mask = logical((data.realNumber==sub).*(data.nRound==t));
            goodHold = startGood{mask};
            goodProposed = proposedGood{mask};
            typeOfPartner = partnersType{mask};
            con{sub}(t) = conMap{goodHold}{typeOfPartner, 1}(goodProposed);        
        end
        
    end
    
    proposedGood = cell2mat(proposedGood');
    startGood = cell2mat(startGood');
    partnersType = cell2mat(partnersType');
    statNumber = statNumber';
    willToExchange = willToExchange';
end