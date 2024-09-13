configuration FloodAppC {
}

implementation {
  components MainC, FloodC, ActiveMessageC, LedsC;
  FloodC -> ActiveMessageC.AM[AM_FLOODMSG];
  MainC.Boot -> FloodC;
  MainC.SoftwareInit -> FloodC;
}
