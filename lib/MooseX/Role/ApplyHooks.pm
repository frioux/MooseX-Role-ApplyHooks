package MooseX::Role::ApplyHooks;

use strict;
use warnings;

use MooseX::Role::ApplyHooks::Meta;

our %Before;
our %After;

sub BEFORE_APPLY(&) { $Before{scalar caller} = $_[0] };
sub AFTER_APPLY (&) { $After {scalar caller} = $_[0] };

use Sub::Exporter -setup => {
   exports => [ qw(BEFORE_APPLY AFTER_APPLY) ],
   groups  => { default => [ qw(BEFORE_APPLY AFTER_APPLY) ] },
   collectors => {
      INIT => sub {
         my $target = $_[1]->{into};

         my $meta = MooseX::Role::ApplyHooks::Meta->initialize($target);
         $meta->add_method('meta' => sub { $meta });
      }
   },
};

1;
