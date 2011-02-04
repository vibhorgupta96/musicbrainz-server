package t::MusicBrainz::Server::Controller::Label::AddAlias;
use Test::Routine;
use Test::More;
use MusicBrainz::Server::Test qw( html_ok );

with 't::Mechanize', 't::Context';

test all => sub {

my $test = shift;
my $mech = $test->mech;
my $c    = $test->c;

MusicBrainz::Server::Test->prepare_test_database($c);

$mech->get_ok('/login');
$mech->submit_form( with_fields => { username => 'new_editor', password => 'password' } );

$mech->get_ok('/label/46f0f4cd-8aab-4b33-b698-f459faf64190/add-alias');
my $response = $mech->submit_form(
    with_fields => {
        'edit-alias.name' => 'An alias'
    });

my $edit = MusicBrainz::Server::Test->get_latest_edit($c);
isa_ok($edit, 'MusicBrainz::Server::Edit::Label::AddAlias');
is_deeply($edit->data, {
    entity_id => 2,
    name => 'An alias',
    locale => undef,
});

$mech->get_ok('/edit/' . $edit->id, 'Fetch edit page');
html_ok($mech->content, '..valid xml');

$mech->content_contains('Warp Records', '..contains label name');
$mech->content_contains('/label/46f0f4cd-8aab-4b33-b698-f459faf64190', '..contains label link');
$mech->content_contains('An alias', '..contains alias name');

};

1;
