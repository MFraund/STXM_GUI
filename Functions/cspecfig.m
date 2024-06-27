function cspecfig(varargin)
%
% Name-Value    type        (default):
%------------------------
% 'Labels'  -   bool    -   ture, (false)
% 'Label Type'  str     -   ('bonds'), 'names'
% 'Font Size'   int     -   (12)
%
[varargin,labelFlag_bool] = ExtractVararginValue(varargin,'Labels',false);
[varargin, labelType] = ExtractVararginValue(varargin, 'Label Type', 'bonds');
[varargin, fontSize] = ExtractVararginValue(varargin, 'Font Size', 12);

energyLabels = {...
    'arom.',...
    'sp2',...
    'carbonyl',...
    'alkane',...
    'imide',...
    'carboxyl',...
    'alcohol',...
    'carbonate',...
    'K L2',...
    'K L3'...
    };

energyList = [...
    284.5,... % aromatic
    285.4,... % sp2
    287.7,... % aliphatic
    288.6,... % carboxylic acid
    290.4,...  % carbonate
    294.6,... %KL2
    297.3,... %KL3
    ];



energyLabelsBonds = {...
    'arom.',... %Aromatic
    'C=C',... %Alkene (sp2)
    'C=O',... %Carbonyl
    'CH',... %Alkane
    'R-NH(C=O)R',... %Imide
    'R(C=O)OH',... %Carboxylic acid
    'COH',... %Alcohol
    'CO_3'.... %Carbonate
    'K',... %Potassium L2
    'K',... %Potassium L3
    };

energyListBonds = [...
    284.5,...
    285.1,...
    286.7,...
    287.7,...
    288.3,...
    288.7,...
    289.5,...
    290.4,...
    297.0,...
    299.0,...
    ];


cSpecYLim = get(gca,'YLim');
cSpecYRange = cSpecYLim(2) - cSpecYLim(1);
cSpecTextHeight = cSpecYLim(2) - cSpecYRange.*0.08; % text is lower than top of axes by 10% of axes height

switch labelType
    case 'bonds'
        for cSpecLineIdx = 1:numel(energyListBonds)
            hline(cSpecLineIdx) = vline(energyListBonds(cSpecLineIdx), 'k--');
            if labelFlag_bool
                text(energyListBonds(cSpecLineIdx), cSpecTextHeight - cSpecYRange.*0.05.*(-1).^cSpecLineIdx ,energyLabelsBonds{cSpecLineIdx},'FontSize',fontSize,'FontWeight','bold','Rotation',45);
            end
        end
        
    case 'names'
        for cSpecLineIdx = 1:numel(energyList)
            hline(cSpecLineIdx) = vline(energyList(cSpecLineIdx), 'k--');
            if labelFlag_bool
                text(energyList(cSpecLineIdx), cSpecTextHeight - cSpecYRange.*0.03.*(-1).^cSpecLineIdx ,energyLabels{cSpecLineIdx},'FontSize',18,'FontWeight','bold','Rotation',45);
            end
        end
        
end


set(hline,'LineWidth',1);

end