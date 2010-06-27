package MooseX::Role::ApplyHooks::Meta;

use Moose::Role;
use MooseX::Role::ApplyHooks;

before apply => sub {
  my ($self, $other) = @_;
  if (my $fn = $MooseX::Role::ApplyHooks::Before{$self->name}) {
    $other->$fn($self);
  }
};

after apply => sub {
  my ($self, $other) = @_;
  if (my $fn = $MooseX::Role::ApplyHooks::After{$self->name}) {
    $other->$fn($self);
  }
};

no Moose::Role;
1;
