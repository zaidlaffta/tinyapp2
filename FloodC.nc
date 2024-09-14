
module FloodC {
  uses {
    interface Boot;
    interface SplitControl as AMControl;
    interface AMSend;
    interface Receive;
    interface Packet;
    
  }
}

implementation {

  message_t packet;
  uint16_t counter;
  
  // Message type
  typedef nx_struct flood_msg_t {
    nx_uint16_t counter;
  } flood_msg_t;
  
  enum {
    AM_FLOODMSG = 6,
    TIMER_PERIOD_MILLI = 5000,
  };

  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      flood_msg_t *msg = (flood_msg_t *) call Packet.getPayload(&packet, sizeof(flood_msg_t));
      msg->counter = counter;
      call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(flood_msg_t));
    }
  }

  event void AMControl.stopDone(error_t err) {}

  event message_t* Receive.receive(message_t *msg, void *payload, uint8_t len) {
    flood_msg_t *rcvdMsg = (flood_msg_t *) payload;
    counter = rcvdMsg->counter;

    // Forward the message
    flood_msg_t *fwdMsg = (flood_msg_t *) call Packet.getPayload(&packet, sizeof(flood_msg_t));
    fwdMsg->counter = counter;
    call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(flood_msg_t));

    // Blink LED when a message is received
    return msg;
  }

  event void AMSend.sendDone(message_t *msg, error_t error) {
    if (error == SUCCESS) {
      // Blink LED when a message is sent
    }
  }
}
