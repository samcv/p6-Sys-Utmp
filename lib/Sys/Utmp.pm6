use v6;
use LibraryMake;
use NativeCall;

class Sys::Utmp {
    class Utent is repr('CStruct') {
        has int8 $.type;
        has int32 $.pid;
        has Str $.line;
        has Str $.id;
        has Str $.user;
        has Str $.host;
        has int $.tv;
    }

    sub library {
        my $so = get-vars('')<SO>;
        my $libname = "utmphelper$so";
        my $base = "lib/Sys/Utmp/$libname";
        for @*INC <-> $v {
            if $v ~~ Str {
                $v ~~ s/^.*\#//;
                if ($v ~ '/' ~ $libname).IO.r {
                    return $v ~ '/' ~ $libname;
                }
            }
            else {
                if my @files = ($v.files($base) || $v.files("blib/$base")) {
                    my $files = @files[0]<files>;
                    my $tmp = $files{$base} || $files{"blib/$base"};

                    $tmp.IO.copy($*SPEC.tmpdir ~ '/' ~ $libname);
                    return $*SPEC.tmpdir ~ '/' ~ $libname;
                }
            }
        }
        die "Unable to find library";
    }

    sub _p_getutent() returns Utent is native(&library) { * }
    sub _p_setutent() is native(&library) { * }
    sub _p_endutent() is native(&library) { * }
    sub _p_utmpname(Str) is native(&library) { * }

    method list() {
        gather {
            loop {
                say "ff";
                if _p_getutent() -> $utent {
                    take $utent;
                }
                else {
                    last;
                }
            }
        }
    }
}
