program test;

uses czmq;

begin
  Write('Loading czmq library...');
  czmq.LoadLib('libczmq.so');
  Writeln('Done!');
  zctx_test(true);
  zsocket_test(true);
  zsockopt_test(true);
  zframe_test(true);
  zmsg_test(true);
  zloop_test(true);
  zauth_test(true);
  zpoller_test(true);
  zmonitor_test(true);
  zbeacon_test(true);
  zuuid_test(true);

  Writeln('Done');

end.

