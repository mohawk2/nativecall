package NativeCall;

use strict;
use warnings;
use Sub::Util qw(subname);
use FFI::Platypus;
use FFI::CheckLib 0.06;

our $VERSION = '0.001';

my %attr2handler = (
  Native => sub {},
  Args => sub {},
  Returns => sub {},
);

sub _attr_parse {
  my ($attr) = @_;
  my ($attribute, $args) = ($attr =~ /
    (\w+)
    (?:
      \(
      (.*?)
      \)
    )?
  /x);
  return ($attribute, [ split /,\s*/, $args ]);
}

sub MODIFY_CODE_ATTRIBUTES {
  my ($package, $subref, @attrs) = @_;
  my @bad;
  my %attr2args;
  for my $attr (@attrs) {
    my ($attribute, $args) = _attr_parse($attr);
    if (!$attr2handler{$attribute}) {
      push @bad, $attribute;
      next;
    } else {
      $attr2args{$attribute} ||= [];
      push @{ $attr2args{$attribute} }, @$args;
    }
  }
  my $subname = subname $subref;
  my $sub_base = (split /::/, $subname)[-1];
  my $ffi = FFI::Platypus->new;
  my $lib = $attr2args{Native}->[0] || undef; # undef means standard library
  $ffi->lib($lib ? find_lib_or_die lib => $lib : undef);
  my $argtypes = $attr2args{Args};
  my $returntype = $attr2args{Returns}->[0] || 'void';
  no warnings qw(redefine);
  undef &{ $subname }; # avoid "redefine" warning in Platypus
  $ffi->attach([ $sub_base => $subname ] => $argtypes => $returntype);
  return @bad;
}

1;

__END__

=head1 NAME

NativeCall - Perl 5 interface to foreign functions in Perl code without XS

=head1 SYNOPSIS

  use parent qw(NativeCall);
  use feature 'say';

  sub cdio_eject_media_drive :Args(string) :Native(cdio) {}
  sub cdio_close_tray :Args(string, int) :Native(cdio) {}

  say "Gimme a CD!";
  cdio_eject_media_drive undef;

  sleep 1;
  say "Ha! Too slow!";
  cdio_close_tray undef, 0;

  sub fmax :Args(double, double) :Native :Returns(double) {warn "dude2"}
  say "fmax(2.0, 3.0) = " . fmax(2.0, 3.0);

=head1 DESCRIPTION

Mimics the C<NativeCall> module and interface from Perl 6. Uses
L<FFI::Platypus> for the actual hard work. Uses inheritance and
L<attributes>.

See F<examples/troll.pl> for the example given above in SYNOPSIS.

=head2 ATTRIBUTES

=over

=item Native

If an argument is given, try to load from that library. If none given,
use what is already loaded.

=item Args

A comma-separated list of L<FFI::Platypus::Type>s.

=item Returns

A single L<FFI::Platypus::Type>.

=back
