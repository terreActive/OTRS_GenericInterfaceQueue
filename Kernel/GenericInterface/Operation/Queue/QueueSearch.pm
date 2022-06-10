# --
# Copyright (C) 2001-2021 OTRS AG, https://otrs.com/
# Copyright (C) 2021-2022 Othmar Wigger, https://www.terreactive.ch/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::GenericInterface::Operation::Queue::QueueSearch;

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
    $Self->{Config} = $Kernel::OM->Get('Kernel::Config')->Get('GenericInterface::Operation::QueueSearch');

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    return $Self->ReturnError(
        ErrorCode    => 'QueueSearch.ParamFail',
        ErrorMessage => "QueueSearch: Missing parameter!",
    ) unless $Param{Data}->{Queue};

    my @SearchTerms;
    if ( ref $Param{Data}->{Queue} eq "ARRAY" ) {
        @SearchTerms = @{$Param{Data}->{Queue}};
    } elsif ( length($Param{Data}->{Queue}) > 0) {
        @SearchTerms = ( $Param{Data}->{Queue} );
    } else {
        return {
            Success => 1,
            Data    => {},
        };
    }

    # perform queue search
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    my @QueueIDs;
    my $SQL = "
        SELECT
            id
        FROM
            queue
        WHERE
    " . join( "or", map { " name LIKE '%[$_]' " } @SearchTerms ); 
    $Self->{SearchLimit} = $Param{Data}->{Limit}
        || $Self->{Config}->{SearchLimit}
        || 100;
    $DBObject->Prepare(
        SQL => $SQL,
        Limit => $Self->{SearchLimit}
    );
    while (my @Row = $DBObject->FetchrowArray()) {
        push @QueueIDs, $Row[0];
    }

    if (@QueueIDs) {
        return {
            Success => 1,
            Data    => {
                QueueID => \@QueueIDs,
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
