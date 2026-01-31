-- 加解密作業 (較舊的，自己也沒試過)
create or replace function encrypt_data(p_source varchar2, p_key varchar2) return varchar2 is
        o_result varchar2(4000);
begin
        -- 加密
        sys.dbms_obfuscation_toolkit.desencrypt(p_source, p_key, o_result);

        -- 解密就用
        --sys.dbms_obfuscation_toolkit.desdecrypt(p_source, p_key, o_result);
    return o_result;
end;