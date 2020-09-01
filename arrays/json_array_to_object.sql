drop function if exists json_array_to_object;

create
    definer = root@localhost function json_array_to_object(array json) returns json deterministic no sql
begin
    declare i, len int;
    declare result json;
    set len = json_length(array);
    if (json_keys(array) is null) and (len > 0) then
        set i = 0;
        set result = '{}';
        while i < len
            do
                select json_insert(result, concat('$."', i, '"'),
                                   json_extract(array, concat('$[', i, ']')))
                into result;
                set i = i + 1;
            end while;
    else
        set result = array;
    end if;
    return result;
end;