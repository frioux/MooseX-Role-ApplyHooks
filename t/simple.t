#!perl

use strict;
use warnings;

use Test::More;
use Test::Exception;
{

   package A::Role::Dies;
   use MooseX::Role::ApplyHooks;
   use Moose::Role;

   BEFORE_APPLY { die 'FAIL' };

   sub fail { 1 };

   no Moose::Role;

   1;

}

{

   package A::Class;

   use Moose;

   no Moose;

   1;
}

{

   package A::Role::B;
   use Moose::Role;

   sub b_did { 1 };
   1;

   no Moose::Role;

}

{

   package A::Role::AppliesB;
   use MooseX::Role::ApplyHooks;
   use Moose::Role;

   BEFORE_APPLY { A::Role::B->meta->apply($_[0]) };


   no Moose::Role;
   1;

}

ok( !A::Class->can('b_did'), 'A::Role::B not applied' );
A::Role::AppliesB->meta->apply(A::Class->meta);
ok( A::Class->can('b_did'), 'A::Role::B is applied' );

dies_ok {
   A::Role::Dies->meta->apply(A::Class->meta)
} 'die role kills application process';

ok( !A::Class->can('fail'), 'role did not get applied' );

done_testing;

