package Net::HTTP::Methods::patch::log_request;

use 5.010001;
use strict;
no warnings;

use parent qw(Module::Patch);

our $VERSION = '0.01'; # VERSION

our %config;

my $p_log_request = sub {
    require Log::Any;

    my $orig = shift;
    my $res = $orig->(@_);

    my $log = Log::Any->get_logger;
    $log->tracef("HTTP request: %s", $res);
    $res;
};

sub patch_data {
    return {
        config => {
        },
        versions => {
            # LWP is at 6.04, Net::HTTP 6.03, Net::HTTP::Methods still at 6.00
            '6.00' => {
                subs => {
                    format_request => $p_log_request,
                },
            },
        },
    };
}

1;
# ABSTRACT: Patch module for Net::HTTP::Methods


__END__
=pod

=head1 NAME

Net::HTTP::Methods::patch::log_request - Patch module for Net::HTTP::Methods

=head1 VERSION

version 0.01

=head1 SYNOPSIS

 use Net::HTTP::Methods;
 use Net::HTTP::Methods::patch::log_request
   -on_unknown_version => 'warn',
   -on_conflict        => 'warn';

 # now all your LWP HTTP requests are logged

 use LWP::UserAgent;
 my $ua = LWP::UserAgent->new;
 my $response = $ua->get('...');

=head1 DESCRIPTION

This module patches LWP::Protocol::http so that raw HTTP request is logged using
L<Log::Any>. If you look into LWP::Protocol::http's source code, you'll see that
it is already doing that (albeit commented):

  my $req_buf = $socket->format_request($method, $fullpath, @h);
  #print "------\n$req_buf\n------\n";

=head1 FAQ

=head2 Why not subclass?

By patching, you do not need to replace all the client code which uses LWP.

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

