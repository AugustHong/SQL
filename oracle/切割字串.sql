select regexp_substr('要切割的字串 用,來切', '[^,]+', 1, level) compare_str
      from dual
    connect by regexp_substr('要切割的字串 用,來切', '[^,]+', 1, level) is not null;