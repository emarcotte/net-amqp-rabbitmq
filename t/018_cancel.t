use Test::More tests => 7;
use Test::Exception;

use strict;
use warnings;

my $host = $ENV{MQHOST} || "dev.rabbitmq.com";

use_ok('Net::AMQP::RabbitMQ');

ok( my $mq = Net::AMQP::RabbitMQ->new(), 'new' );

lives_ok {
	$mq->connect(
		host => $host,
		username => "guest",
		password => "guest",
	);
} 'connect';

lives_ok {
	$mq->channel_open(
		channel => 1,
	);
} 'channel.open';

my $queue;
lives_ok {
	$queue = $mq->queue_declare(
		channel => 1,
	)->queue;
} 'queue.declare';

my $ctag;
lives_ok {
	$ctag = $mq->basic_consume(
		channel => 1,
		queue => $queue,
		consumer_tag => 'ctag',
	);
} 'basic.consume';

lives_ok {
	$mq->basic_cancel(
		channel => 1,
		consumer_tag => $ctag,
	);
} 'basic.cancel';

1;
