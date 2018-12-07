function results=SG_invert_subjects(s,k,dummy,restricted)

%addpath(genpath('~/Code/VBA-toolbox'))
%addpath(genpath('~/Code/army-knife'))

is_dummy = (nargin > 2 && dummy );
is_restricted = (nargin > 3 && restricted );

if is_dummy
    target_dir = 'bootstrap';
else
    target_dir = 'subjects';
end

target_file = sprintf('../results/%s/data_s%03d_m%02d_r%d.mat',target_dir,s,k,is_restricted);

if is_dummy
    load(sprintf('../results/bootstrap/data_dummy_s%03d_r%d.mat',s,is_restricted));
else
    data=SG_load_data() ;
    data=data(s);
end

if is_restricted
    
    run_options = factorial_struct(  ...
        'dynamics'      , 1:2       , ...
        'choiceUpdate'  , 0:1       , ...
        'successUpdate' , 0:1       , ...
        'forceUpdate'   , 0:1       , ...
        'driftUpdate'   , 0:1       , ...
        'restricted'    , 1           ...
        );
    
else
    
    run_options = factorial_struct(  ...
        'dynamics'      , 1:3       , ...
        'choiceUpdate'  , 0:1       , ...
        'successUpdate' , 0:1       , ...
        'forceUpdate'   , 0:1       , ...
        'driftUpdate'   , 0:1       , ...
        'restricted'    , 0           ...
        );
end

% clean null hypotheses
run_options([run_options.choiceUpdate]==0 & [run_options.successUpdate]==0 & [run_options.forceUpdate]==0) = [];
run_options = [ ...
    factorial_struct(  ...
    'dynamics'      , 0       , ...
    'choiceUpdate'  , 0       , ...
    'successUpdate' , 0       , ...
    'forceUpdate'   , 0       , ...
    'driftUpdate'   , 0:1     , ...
    'restricted'    , is_restricted   ...
    ), ...
    run_options ];



results = SG_invert(data,run_options(k));

results.run_options.iSuj = s;
results.run_options.iMod = k;



if ~ exist(['../results/' target_dir],'dir')
    mkdir(['../results/' target_dir])
end
save(target_file,'results');
end