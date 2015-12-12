requires 'JSON::PP', '2.27300';
requires 'SemVer::V2::Strict', '0.10';

on test => sub {
    requires 'Data::Dumper', '2.154';
    requires 'File::Slurp', '999.19';

    requires 'Capture::Tiny', '0.30';
    requires 'File::Touch', '0.08';
    requires 'File::Path', '2.09';
    requires 'Module::Find', '0.13';

    requires 'Test::More', '1.001014';
    requires 'Test::Deep', '0.117';
    requires 'Test::Deep::Matcher', '0.01';
    requires 'Test::Exception', '0.40';

    requires 'Test::Mock::Guard', '0.10';
    requires 'Test::MockObject', '1.20150527';
    requires 'Test::TCP', '2.12';
    requires 'Plack', '1.0037';

    requires 'Devel::Cover', '1.20';
    requires 'Devel::Cover::Report::Codecov';
    requires 'Perl::Critic', '1.125';
    requires 'Test::Perl::Critic', '1.03';
};
