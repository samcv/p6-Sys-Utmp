use v6;
use LibraryMake;
use NativeCall;

class Sys::Utmp {
    my class Utent is repr('CStruct') {
        has int $.ut_type;
        has int $.ut_pid;
        has Str $.ut_line;
        has Str $.ut_id;
        has Str $.ut_user;
        has Str $.ut_host;
        has int $.ut_tv;
    }
}
