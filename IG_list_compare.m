%% GET BASIC INFO
path = ''; %%%%%%%%%% Enter path to your connections.json file
fields = jsondecode(fileread(path));
s = '';
val1 = 0; str1 = strcat(s, 'followers', s);
val2 = 0; str2 = strcat(s, 'following', s);
names = fieldnames(fields);

for i = 1:length(names)  
    if(isequal(names{i}, str1) == 1)
        val1 = i;
    end    
    if(isequal(names{i}, str2) == 1)
        val2 = i;
    end   
end

%% SORT FOLLOWER AND FOLLOWING LISTS
fields_cells = struct2cell(fields);
followers_list = sort(fieldnames(fields_cells{val1}));
following_list = sort(fieldnames(fields_cells{val2}));

%% SPLITS FOLLOWING INTO MATRICES BASED ON LETTER
L = cell(1,1);
for i = 1:26
    L{i} = i;
end

for n = 1:length(following_list)
    for m = 1:26
        if(following_list{n}(1) == strcat(s, char(m + 96), s))
            L{m} = [L{m} following_list{n}];
        end
    end
end

%% REMOVES PEOPLE THAT FOLLOW YOU BUT YOU DON'T FOLLOW
friends = strings(length(followers_list), 1);
not_so_innocent = strings(length(followers_list), 1);
for i = 1:length(followers_list)
    letter = followers_list{i}(1);
    val = strfind(L(double(letter)-96), followers_list{i});
     if(isequal(val{1}, []) == 0)
         friends(i) = followers_list{i};
     elseif(isequal(val{1}, []) == 1)
        not_so_innocent(i) = followers_list{i};
     end
     
end
friends(cellfun('isempty',friends)) = [];
not_so_innocent(cellfun('isempty',not_so_innocent)) = [];

%% BUILDS THE LIST OF PEOPLE WHO YOU FOLLOW BUT DON'T FOLLOW YOU
traitors = strings(length(following_list), 1);

for i = 1:length(following_list)
    if(isequal(following_list{i}, friends{i}) == 0)
        traitors(i) = [following_list{i}];
        friends(i+1:end+1,:) = friends(i:end,:);
    end
end

traitors(cellfun('isempty',traitors)) = [];       

%% SHOW RELEVANT INFORMATION
not_so_innocent; % These are the people who follow you 
                 % but you don't follow

traitors;        % These are the people who you follow
                 % but don't follow you back
