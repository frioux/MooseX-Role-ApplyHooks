package MooseX::Role::ApplyHooks::Meta;

use Moose;
use MooseX::Role::ApplyHooks;

extends 'Moose::Meta::Role';

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

no Moose;
1;
