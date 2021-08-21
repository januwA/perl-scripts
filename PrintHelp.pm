#!/usr/bin/perl

# 打印help文档

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
   bless $self, $class;

   my $help = "";
   $help .= $self->setUsages();
   $help .= $self->setOptions();
   say encode('utf-8', $help);
   return $self;
}

# 获取options中命令的最大长度
sub getMaxLen {
   my( $self ) = @_;
   my $maxLen = 0;
   my $opts = $self->{options};
   for(keys %{$opts}) {
      $maxLen = length($_) if(length($_) > $maxLen);
   }
   return $maxLen;
}

# 设置Usages
sub setUsages {
   my( $self ) = @_;
   my $help = "";
   my $usages = $self->{usages};
   if(defined($usages)){
      my $usagesLen = @{$usages};
      for(my $i=0; $i < $usagesLen; $i++){
         $help .= ($i == 0) ? "Usage: " : " " x 7;
         $help .= "$usages->[$i]\n";
      }
      $help .= "\n";
   }
   return $help;
}

# 设置options
sub setOptions {
   my( $self ) = @_;
   my $help = "";
   my $opts = $self->{options};
   unless( defined($opts)) { return $help; }
   my $maxLen = $self->getMaxLen();
   $help .= "Options:\n";

   for my $key (sort keys %{$opts}) {
      my $value = $opts->{$key};
      my $keyLen = length($key); # key 长度
      my $alias = $self->getAlias($key); # 默认取key第一个字符作为alias
      $help .= "  ";
      $help .= "-$alias\t";
      $help .= "--$key";
      $help .= " " x ($maxLen - $keyLen) if($keyLen < $maxLen);
      $help .= "\t$value->{msg}" if(defined($value->{msg}));
      $help .= " (default: $value->{default})" if(defined($value->{default}));
      $help .= "\n";
   };

   return $help;
}

# 从key中提起唯一的alias
sub getAlias {
   state @aliasCacke = ();

   my( $self, $key ) = @_;

   # alias 长度默认1，如果存在alias则加一
   my $aliasLen = 1;
   my $alias = substr($key, 0, $aliasLen);

   while($alias ~~ @aliasCacke) {
      $alias = substr($key, 0, ++$aliasLen);
   }

   push(@aliasCacke, $alias);
   return $alias;
}

our @ISA = qw(Exporter); # 继承Exporter
our @EXPORT_OK = qw(); #
1;