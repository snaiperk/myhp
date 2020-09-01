drop function if exists array_collapse;

create
    definer = root@localhost function array_collapse(array json) returns json deterministic no sql 
begin # Версия от 2020-08-21 13:10
    declare result JSON;
    declare i,  cnt, len int default 0;
    declare num varchar(9);

    set result = if(array is null, null, json_object());
    set len = json_length(array);
    set i = 0;
    while i < len
        do
            set num = json_extract(array, concat('$[', i, ']')); #num - это будущий ключ, который мы суммируем
            if (num <> 'null') then
                set cnt = ifnull(json_extract(result, concat('$."', num, '"')), 0);
                set result = json_set(result, concat('$."', num, '"'), cnt + 1);
            end if;
            set i = i + 1;
        end while;
    return result;
end;