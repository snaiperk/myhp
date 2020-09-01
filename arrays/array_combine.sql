drop function if exists array_combine;

create
    definer = 'root'@'localhost' function array_combine(jKeys json, jValues json) returns json deterministic no sql
begin
    declare i, j, len1, len2, len int;
    declare result json;
    declare path, pathResult, value varchar(100);
    set len1 = json_length(jKeys);
    set len2 = json_length(jValues);
    set len = greatest(len1, len2);
    set i = 0;
    set result = '{}';
    while (i < len) /*and (i < len2)*/
        do
            set path = concat('$[', i, ']');
            set pathResult = concat('$."', ifnull(json_unquote(json_extract(jKeys, path)), i),'"');
            set value = json_unquote(json_extract(jValues, path));
            if value regexp '^-?[0-9]+$' then
                set result = json_insert(result, pathResult, cast(value as signed)); # К сожалению, просто IF здесь не прокатил, т.к. он портит тип значения
            else
                set result = json_insert(result, pathResult, value);
            end if;

            set i = i + 1;
        end while;
    return result;
end;

select array_combine('[121,17]', '["Lorem Ipsum",12344, "hehe"]') as displays, json_insert('{}', '$."123"', 1);