#!perl6

use v6;

use Panda::Common;
use Panda::Builder;
use LibraryMake;
use Shell::Command;

class Build is Panda::Builder {
   method build($workdir) {
         my Str $blib = "$workdir/blib";         
         rm_rf($blib);
         mkpath "$blib/lib/Sys";
         mkpath "$blib/lib/../resources/lib";
         make("$workdir/src", "$blib/lib");
   }
}
# vim: ft=perl6 expandtab sw=4
