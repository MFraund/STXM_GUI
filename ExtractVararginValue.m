function [remainingargs, value] = ExtractVararginValue(args, name, default)
% [remainingargs, value] = ExtractVararginValue(args, name, default)
%
% Case Insensitive

remainingargs = {};
skipping = false;
value = default;
for i = 1:length(args)
    if strcmpi(args{i}, name)
        value = args{i+1};
        skipping = true;
    elseif skipping
        skipping = false;
    else
        remainingargs{end+1} = args{i};
    end
end
