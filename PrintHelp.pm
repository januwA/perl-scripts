#!/usr/bin/perl

# 打印help文档

# Usage
#
# PrintHelp->new([
#     "atree [dir=./] [options]",
#     "atree ./lib",
#     "atree ./lib --depath 1",
#     "or",
#     "atree ./lib -d 1",
#     "atree -i ~/.atree -d 3"
#   ],
#   {
# 	ignores => {
#     msg => "无视目录配置文件路径.",
#     alias => "i",
#     default => "./atree"
# 	},
# 	depath => {
#     msg => "查询目录深度.",
#     alias => "d",
#     default => '0 无限.'
# 	},
#   help => {
#     msg => "帮助文档.",
#     alias => "h",
#   }
# });


# Demo
#
# Usage:  atree [dir=./] [options]
#         atree ./lib
#         atree ./lib --depath 1
#         or
#         atree ./lib -d 1
#         atree -i ~/.atree -d 3

# Options:
#   -h, --help    帮助文档.
#   -i, --ignores 无视目录配置文件路径. (default: ./atree)
#   -d, --depath  查询目录深度. (default: 0 无限.)

package PrintHelp;
require Exporter;

use v5.26;
use strict;
use utf8;
use autodie;
use warnings;
use Encode qw(decode encode);
use experimental 'smartmatch'; # 忽略智能匹配的错误警告
use Data::Dumper;

sub new {
   my $class = shift;
   my $self = {
      usages   => shift,
      options  => shift,
   };

   my $opts = $self->{options};
   my $usages = $self->{usages};

   my $maxLen = 0;
   for(keys %{$opts}) {
      $maxLen = length($_) if(length($_) > $maxLen);
   }

   my $help = "";

   if(defined($usages)){
      my $usagesLen = @{$usages};
      for(my $i=0; $i < $usagesLen; $i++){
         $help .= "Usage:  " if($i == 0);
         $help .= " " x 8 if($i != 0);
         $help .= "$usages->[$i]\n";
      }
      $help .= "\n";
   }


   $help .= "Options:\n";
   for(keys %{$opts}) {
      my $keyLen = length($_);
      $help .= "  ";
      $help .= "-$opts->{$_}{\"alias\"}, " if(defined($opts->{$_}{"alias"}));
      $help .= "--$_";
      $help .= " " x ($maxLen - $keyLen) if($keyLen < $maxLen);
      $help .= "\t$opts->{$_}{\"msg\"}" if(defined($opts->{$_}{"msg"}));
      $help .= " (default: $opts->{$_}{\"default\"})" if(defined($opts->{$_}{"default"}));
      $help .= "\n";
   };

   say encode('utf-8', $help);
   
   bless $self, $class;
   return $self;
}

our @ISA = qw(Exporter); # 继承Exporter
our @EXPORT_OK = qw(); #
1;