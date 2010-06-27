package MooseX::Role::ApplyHooks;

use strict;
use warnings;

use MooseX::Role::ApplyHooks::Meta;

our %Before;
our %After;

sub BEFORE_APPLY { $Before{scalar caller(1)} = $_[1] };
sub AFTER_APPLY  { $After {scalar caller(1)} = $_[1] };

sub _curry_class {
   my ($class, $name) = @_;
   sub (&) { $class->$name(@_) }
}

use Sub::Exporter -setup => {
   exports => [
      map { $_ => \'_curry_class' }
      qw(BEFORE_APPLY AFTER_APPLY)
   ],
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
