%% Test Cases
clear('a','b','c','d','Lorem');
% non-struct case
a = 0

% basic case, 1 iteration
b.a = 1

% basic case, multiple options
c.a = 1;
c.b = 2;
c.c = 3;
c.d = 4

% multilevel case
d.a = 1;

d.b.a = 1;
d.b.b = 2;
d.b.c = 3;
d.b.d = 4;

d.c.a = 1;
d.c.b = 2;
d.c.c = 3;
d.c.d.a = 1;
d.c.d.b.waldo = 'where?'
d.c.d.walbo = 'wear?'

Lorem.ipsum = 'sit';
Lorem.sit.iPSum = 'sit';
Lorem.adipiscing.a1tempo = 'incididunt';
Lorem.adipiscing.a2te123mor = 'incididunt';
Lorem.adipiscing.id.a.temp91o2j1r = 'incididunt';
Lorem.adipiscing.id.tepor = 'incididunt';

%% Soft error on non-struct
assert(hasfield(a)==0)

%% Test cases where result should be equal to isfield()
assert(hasfield(b,'a') == isfield(b,'a'))
assert(hasfield(b,'b') == isfield(b,'b'))
assert(hasfield(c,'b') == isfield(c,'b'))
assert(hasfield(c,'e') == isfield(c,'e'))

%% Multilevel feature tests
assert(hasfield(d,'waldo')==1)

[x,L] = hasfield(d,'d')
assert(x==1 && L==2)

[x,L] = hasfield(d,'waldo')
assert(x==1 && L==4)

%% regex variant should match vanilla
assert(hasfield(b,'a') == hasfieldrx(b,'a'))
assert(hasfield(b,'b') == hasfieldrx(b,'b'))
assert(hasfield(c,'b') == hasfieldrx(c,'b'))
assert(hasfield(c,'e') == hasfieldrx(c,'e'))
assert(hasfield(d,'waldo')==hasfieldrx(d,'waldo'))
[x1,L1] = hasfield(d,'d')
[x2,L2] = hasfieldrx(d,'d')
assert(x1==x2 && L1==L2)

%% test regex checking
% simple
[x,L] = hasfieldrx(Lorem,'i[pP]Sum')
assert(x==1&&L==2);
[x,L] = hasfieldrx(Lorem,'i[pP][sS]um')
assert(x==1&&L==1);

% a bit more
[x1,L1] = hasfield(d,'waldo')
[x2,L2] = hasfieldrx(d,'wal[db]o')
assert(x1==x2 && L1==(L2+1))

% position matching, wildcard matching, and level limiting
[x,L] = hasfieldrx(Lorem,'te')
assert(x==1&&L==2);
[x,L] = hasfieldrx(Lorem,'^te')
assert(x==1&&L==3);
[x,L] = hasfieldrx(Lorem,'.*temp.*o.*r$')
assert(x==1&&L==4);
[x,L1] = hasfieldrx(Lorem,'^.$')
[x,L2] = hasfieldrx(Lorem,'^.$',L1-1)
assert(x==0&&L2==(L1-1));
