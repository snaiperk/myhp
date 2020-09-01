drop function if exists time_diff;

create
    definer = root@localhost function time_diff(diff int) returns varchar(128) deterministic no sql
BEGIN
    DECLARE years int;
    DECLARE months int;
    DECLARE weeks int;
    DECLARE days int;
    DECLARE hours int;
    DECLARE minutes int;
    DECLARE second int;
    DECLARE result varchar(128);
    SET result = '';

    SET years = FLOOR(diff / 31536000);
    SET diff = diff - years * 31536000;
    if years > 0 then
        set result = concat(result, ' ', years, ' лет');
    end if;

    SET months = FLOOR(diff / 2592000);
    SET diff = diff - months * 2592000;
    if months > 0 then
        set result = concat(result, ' ', months, ' мес.');
    end if;


    SET weeks = FLOOR(diff / 604800);
    SET diff = diff - weeks * 604800;
    if weeks > 0 then
        set result = concat(result, ' ', weeks, ' нед.');
    end if;


    SET days = FLOOR(diff / 86400);
    SET diff = diff - days * 86400;
    if days > 0 then
        set result = concat(result, ' ', days, ' д.');
    end if;


    SET hours = FLOOR(diff / 3600);
    SET diff = diff - hours * 3600;
    if hours > 0 then
        set result = concat(result, ' ', hours, ' ч.');
    end if;


    SET minutes = FLOOR(diff / 60);
    SET diff = diff - minutes * 60;
    if minutes > 0 then
        set result = concat(result, ' ', minutes, ' мин.');
    end if;


    SET second = FLOOR(diff);
    SET diff = 0;
    if second > 0 then
        set result = concat(result, ' ', second, ' сек.');
    end if;

    RETURN trim(result);
END;