<?php
require __DIR__ . '/vendor/autoload.php';

use Ratchet\Http\HttpServer;
use Ratchet\ConnectionInterface;
use Ratchet\Server\IoServer;
use Ratchet\Wamp\WampServer;
use Ratchet\Wamp\WampServerInterface;
use React\EventLoop\Factory;
use React\Socket\Server;
use React\ZMQ\Context;

/**
 * Class WsServer
 */
final class WsServer implements WampServerInterface
{
    /**
     * @var SplObjectStorage
     */
    private $clients;

    /**
     * @var array
     */
    private $channels = [];

    /**
     * WsServer constructor.
     */
    public function __construct()
    {
        $this->clients = new SplObjectStorage();
    }

    /**
     * @param ConnectionInterface $conn
     */
    public function onOpen(ConnectionInterface $conn)
    {
        echo "Client connected: {$conn->resourceId}\n";
        $this->clients->attach($conn);
    }

    /**
     * @param ConnectionInterface $conn
     */
    public function onClose(ConnectionInterface $conn)
    {
        echo "Client disconnected: {$conn->resourceId}\n";
        $this->clients->detach($conn);
    }

    /**
     * @param ConnectionInterface $from
     * @param string $msg
     */
    public function onMessage(ConnectionInterface $from, $msg)
    {
        echo "Got message: {$msg}\n";
        /** @var ConnectionInterface $client */
        foreach ($this->clients as $client) {
            if ($from !== $client) {
                $client->send($msg);
            }
        }
    }

    /**
     * @param ConnectionInterface $conn
     * @param Exception $e
     */
    public function onError(ConnectionInterface $conn, Exception $e)
    {
        $conn->close();
    }

    /**
     * @param ConnectionInterface $conn
     * @param string $id
     * @param \Ratchet\Wamp\Topic|string $topic
     * @param array $params
     */
    public function onCall(ConnectionInterface $conn, $id, $topic, array $params)
    {
        $conn->send("You're not allowed to do this");
    }

    /**
     * @param ConnectionInterface $conn
     * @param \Ratchet\Wamp\Topic|string $topic
     */
    public function onSubscribe(ConnectionInterface $conn, $topic)
    {
        echo "Client sub: {$conn->resourceId}\n";
        $this->channels[$topic->getId()] = $topic;
    }

    /**
     * @param ConnectionInterface $conn
     * @param \Ratchet\Wamp\Topic|string $topic
     */
    public function onUnSubscribe(ConnectionInterface $conn, $topic)
    {
        echo "Client unsub: {$conn->resourceId}\n";
        unset($this->channels[$topic->getId()]);
    }

    public function onPublish(ConnectionInterface $conn, $topic, $event, array $exclude, array $eligible)
    {
        echo "Got ZMQ pub\n";
        echo print_r($event, true);
    }

    public function onZMQMessage($event)
    {
        echo "Got ZMQ message\n";
        //echo print_r($event, true);
        $eventData = json_decode($event, true);

        if (!array_key_exists($eventData['channel'], $this->channels)) {
            echo "Skip message as no receivers\n";
            return;
        }

        $topic = $this->channels[$eventData['channel']];
        $topic->broadcast($eventData);
    }
}
$port = $argv[1] ? (int) $argv[1] : 5554;
$wsServerHandler = new WsServer();

echo "Starting ZMQ listener on {$port}\n";
$loop = Factory::create();
$context = new Context($loop);
$pull = $context->getSocket(ZMQ::SOCKET_PULL);
$pull->bind('tcp://0.0.0.0:' . $port);
$pull->on('message', [$wsServerHandler, 'onZMQMessage']); //
$pull->on('error', function ($e) {
    var_dump($e->getMessage());
});



echo "Starting WS server on 8081\n";
$webSock = new Server('0.0.0.0:8081', $loop);
$ws = new \Ratchet\WebSocket\WsServer(new WampServer($wsServerHandler));
$ws->setStrictSubProtocolCheck(false);
$server = new IoServer(new HttpServer($ws), $webSock);

$loop->run();