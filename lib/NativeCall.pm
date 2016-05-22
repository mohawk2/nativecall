package NativeCall;

use strict;
use warnings;

our $VERSION = '0.001';

my %attr2handler = (
  Native => sub {},
  Args => sub {},
);

sub _attr_parse {
  my ($attr) = @_;
  my ($attribute, $args) = ($attr =~ /
    (\w+)
    \(
      (.*?)
    \)
  /x);
  return ($attribute, [ split /,\s*/, $args ]);
}

sub MODIFY_CODE_ATTRIBUTES {
  my ($package, $subref, @attrs) = @_;
  my @bad;
  for my $attr (@attrs) {
    my ($attribute, $args) = _attr_parse($attr);
    if (!$attr2handler{$attribute}) {
      push @bad, $attribute;
      next;
    }
  }
  return @bad;
}

1;

__END__

=head1 NAME

NativeCall - Perl 5 interface to foreign functions in Perl code without XS

=head1 SYNOPSIS

  use NativeCall;

  sub cdio_eject_media_drive(Str) is native('cdio', v13) {};
  sub cdio_close_tray(Str, int32) is native('cdio', v13) {};

  say "Gimme a CD!";
  cdio_eject_media_drive Str;

  sleep .5;
  say "Ha! Too slow!";
  cdio_close_tray Str, 0;

=head1 DESCRIPTION

Mimics the C<NativeCall> module and interface from Perl 6. Uses
L<FFI::Platypus> for the actual hard work.
