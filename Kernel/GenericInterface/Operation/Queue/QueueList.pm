# --
# Copyright (C) 2001-2021 OTRS AG, https://otrs.com/
# Copyright (C) 2021-2022 Othmar Wigger, https://www.terreactive.ch/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::GenericInterface::Operation::Queue::QueueList;

use strict;
use warnings;

use parent qw(
    Kernel::GenericInterface::Operation::Common
);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(WebserviceID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success      => 0,
                ErrorMessage => "Got no $Needed!",
            };
        }
        $Self->{$Needed} = $Param{$Needed};
    }
    # get config
    $Self->{Config} = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::Operation::QueueList');

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %Queues = $Kernel::OM->Get('Kernel::System::Queue')->QueueList(Valid => 1);

    if (%Queues) {
        return {
            Success => 1,
            Data    => {
                Queues => \%Queues,
            },
        };
    } else {
        return {
            Success => 1,
            Data    => {},
        };
    }
}

1;
