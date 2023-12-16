function [ x,I ] = hasfieldrx( s, regex, varargin)
% X = HASFIELDRX(S,REGEX) checks if the struct S has a fieldname matching
% the regular expression REGEX
%
% [X,L] = HASFIELDRX(S,REGEX,LEVEL) checks LEVEL number of levels into possible
% nested structres for a field name matching REGEX. L returns the first level that the
% field name was found at.

L = 0;% level
I = 0;% level iteratios
x = 0;% default

if(~isstruct(s))
    warning('input is not a struct');
    return
end

if(length(varargin) > 0)
    if(~isnumeric(varargin{1}))
        error('LEVEL must be a numeric variable');
    end
    L = varargin{1};
end

recurseon({s});

    function recurseon(T)
        I = I+1;
        %return if max iterations
        if(L > 0 && I > L)
            I = I-1;
            return
        end
        
        %check for any matching fieldnames
        NEWT = {};
        for i=1:length(T)
            
            t = T{i};
            
            %detection
            N = fieldnames(t);
            x = any(... %is any cell not empty?
                ~cellfun(@isempty,... %have some cellFUN, cells -> logical ary
                regexp(N,regex))); %create cell array of match positions, empty=no match
            if(x) 
                return
            end
            
            %breadth first elaboration
            for j = 1:length(N)
                if(isstruct(t.(N{j})))
                    NEWT = vertcat(NEWT,t.(N{j}));
                end
            end
            
        end
        
        %if theres actually anything to recurse on
        if(~isempty(NEWT))
            recurseon(NEWT);
        end
        
    end
end

