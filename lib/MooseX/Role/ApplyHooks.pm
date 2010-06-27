package MooseX::Role::ApplyHooks;

use strict;
use warnings;

use MooseX::Role::ApplyHooks::Meta;
use Moose::Exporter;
use Moose::Util::MetaRole;

use Moose::Util qw/find_meta does_role/;

our %Before;
our %After;

sub BEFORE_APPLY(&) { $Before{scalar caller} = $_[0] };
sub AFTER_APPLY (&) { $After {scalar caller} = $_[0] };

Moose::Exporter->setup_import_methods(
   as_is => [ qw(BEFORE_APPLY AFTER_APPLY) ],
);

sub init_meta {
   my ($class, %options) = @_;

   my $for_class = $options{for_class};
   my $meta = find_meta($for_class);

   return $meta if $meta
     && does_role($meta, 'MooseX::Role::ApplyHooks::Meta');

   $meta = Moose::Meta::Role->initialize( $for_class )
      unless $meta;

   $meta = Moose::Util::MetaRole::apply_metaroles(
       for_class       => $for_class,
       role_metaroles => {
          role => ['MooseX::Role::ApplyHooks::Meta'],
       },
   );

   return $meta
}

1;
