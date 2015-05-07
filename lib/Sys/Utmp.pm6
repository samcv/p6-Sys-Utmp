use v6;
use LibraryMake;
use NativeCall;

class Sys::Utmp {

    enum UtmpType is export <Empty RunLevel BootTime NewTime OldTime InitProcess LoginProcess UserProcess DeadProcess Accounting>;

    class Utent is repr('CStruct') {
        has int8 $.type;
        has int32 $.pid;
        has Str $.line;
        has Str $.id;
        has Str $.user;
        has Str $.host;
        has int $.tv;

        method timestamp() {
            DateTime.new($.tv // 0 );
        }

        method gist() {
            $!user ~ "\t" ~ $!line ~ "\t" ~ $.timestamp;
        }

        method Numeric() {
            $!type;
        }

        multi method ACCEPTS(Utent:D: UtmpType $type) {
            $!type == $type;
        }
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

    sub _p_setutent() is native(&library) { * }

    method setutent() {
        _p_setutent();
    }

    sub _p_endutent() is native(&library) { * }

    method endutent() {
        _p_endutent()
    }

    sub _p_utmpname(Str) is native(&library) { * }

    method utpname(Str $utname ) {
        my $n = $utname;
        explicitly-manage($n);
        _p_utmpname($n);
    }

    sub _p_getutent() returns Utent is native(&library) { * }

    method getutent() returns Utent {
        _p_getutent();
    }

    method list() {
        gather {
            loop {
                if self.getutent -> $utent {
                    take $utent;
                }
                else {
                    last;
                }
            }
        }
    }
}
