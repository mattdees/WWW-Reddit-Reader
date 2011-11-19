package WWW::Reddit::Reader;

use 5.010;
use strict;
use warnings;

use feature 'state';

use HTTP::Tiny ();
use JSON::XS   ();
use Data::Dumper;

our $VERSION = 0.01;

my $debug = 1;

sub new {
    my ( $class, @subreddits ) = @_;
    my $self = bless {
        'subreddits'   => \@subreddits,
        'num_of_pages' => 5,
    }, $class;
    return $self;
}

sub get_result {
    my ($self) = @_;
    return $self->{'result'};
}

# sub that is passed a code ref to change how each link is processed
sub set_process_sub {
    my ( $self, $process_cr ) = @_;
    *process_result = $process_cr if ref $process_cr eq 'CODE';
}

# sub called to determine if links are done processing
sub set_stop_sub {

}

sub set_number_of_pages {
    my ( $self, $num_of_pages ) = @_;
    $self->{'num_of_pages'} = $num_of_pages;
}

sub _go_on {
    my ( $self, $counter ) = @_;
    return 1 if $counter < $self->{'num_of_pages'};

}

sub process_result {
    my ( $self, $subreddit, $result ) = @_;
    $self->{'result'}->{$subreddit} = [] if !exists $self->{'result'}->{'subreddit'};
    push @{ $self->{'result'}->{$subreddit} }, @{$result};
}

sub read {
    my ( $self, $sort, $timeline, $number_of_pages ) = @_;
    $self->{'result'} = {};
    my $http = HTTP::Tiny->new( 'agent' => 'Reddit Reader v' . $VERSION );
    foreach my $subreddit ( @{ $self->{'subreddits'} } ) {
        my ( $parsed_response, $page_url, $next, $res );
        my $counter = 0;
        while ( $self->_go_on($counter) ) {
            $counter++;
            
            $page_url = "http://www.reddit.com/r/$subreddit/top.json?sort=$sort&t=$timeline";

            if ( $counter > 1 ) {
                $page_url .= "&after=$next&count=" . $counter * 25;
            }

            print "grabbing page $counter: $page_url\n" if $debug;

            $res = $http->get($page_url);
            if ( $res->{'status'} != 200 ) {
                return 'non-200 response recieved';
            }

            $parsed_response = JSON::XS::decode_json( $res->{'content'} );
            $next            = $parsed_response->{'data'}->{'after'};

            $self->process_result( $subreddit, $parsed_response->{'data'}->{'children'} );
            last if !$next;
            sleep 3;
        }

    }
}

=head1 NAME

WWW::Reddit::Reader - The great new WWW::Reddit::Reader!

=head1 VERSION

Version 0.01

=cut

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use WWW::Reddit::Reader;

    my $foo = WWW::Reddit::Reader->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 function1

=cut

sub function1 {
}

=head2 function2

=cut

sub function2 {
}

=head1 AUTHOR

Matt Dees, C<< <matt at lessthan3.net> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-reddit-reader at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Reddit-Reader>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Reddit::Reader


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Reddit-Reader>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-Reddit-Reader>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-Reddit-Reader>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-Reddit-Reader/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Matt Dees.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1;    # End of WWW::Reddit::Reader
