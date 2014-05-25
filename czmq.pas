{  =========================================================================
    czmq.pas - CZMQ API Pascal Binding

    Copyright (c) 2014 Marcelo Campos Rocha - http://www.marcelorocha.net

    This file is a derived work from headers of czmq library
    http://czmq.zeromq.org.
    Copyright (c) 1991-2014 iMatix Corporation <www.imatix.com>

    This is free software; you can redistribute it and/or modify it under
    the terms of the GNU Lesser General Public License as published by the 
    Free Software Foundation; either version 3 of the License, or (at your 
    option) any later version.

    This software is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABIL-
    ITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General 
    Public License for more details.

    You should have received a copy of the GNU Lesser General Public License 
    along with this program. If not, see <http://www.gnu.org/licenses/>.
    =========================================================================
}

{$IFDEF FPC}
{$MODE OBJFPC}
{$ENDIF}

unit czmq;

interface

uses SysUtils;

type
  size_t = NativeUInt;

const
{$IFDEF FPC}
  ZMQ_LIB = 'libzmq.so';
  CZMQ_LIB = 'libczmq.so';
{$ELSE ~FPC}
  ZMQ_LIB = 'zmq.dll';
  CZMQ_LIB = 'czmq.dll';
{$ENDIF ~FPC}

  {** 0MQ errors **}

const
//  A number random enough not to collide with different errno ranges on     
//  different OSes. The assumption is that error_t is at least 32-bit type.  
    ZMQ_HAUSNUMERO = 156384712;
  
  {  On Windows platform some of the standard POSIX errnos are not defined.    }
    ENOTSUP         = (ZMQ_HAUSNUMERO + 1);
    EPROTONOSUPPORT = (ZMQ_HAUSNUMERO + 2);
    ENOBUFS         = (ZMQ_HAUSNUMERO + 3);
    ENETDOWN        = (ZMQ_HAUSNUMERO + 4);
    EADDRINUSE      = (ZMQ_HAUSNUMERO + 5);
    EADDRNOTAVAIL   = (ZMQ_HAUSNUMERO + 6);
    ECONNREFUSED    = (ZMQ_HAUSNUMERO + 7);
    EINPROGRESS     = (ZMQ_HAUSNUMERO + 8);
    ENOTSOCK        = (ZMQ_HAUSNUMERO + 9);
    EMSGSIZE        = (ZMQ_HAUSNUMERO + 10);
    EAFNOSUPPORT    = (ZMQ_HAUSNUMERO + 11);
    ENETUNREACH     = (ZMQ_HAUSNUMERO + 12);
    ECONNABORTED    = (ZMQ_HAUSNUMERO + 13);
    ECONNRESET      = (ZMQ_HAUSNUMERO + 14);
    ENOTCONN        = (ZMQ_HAUSNUMERO + 15);
    ETIMEDOUT       = (ZMQ_HAUSNUMERO + 16);
    EHOSTUNREACH    = (ZMQ_HAUSNUMERO + 17);
    ENETRESET       = (ZMQ_HAUSNUMERO + 18);
  
  {  Native 0MQ error codes.                                                   }
    EFSM           = (ZMQ_HAUSNUMERO + 51);
    ENOCOMPATPROTO = (ZMQ_HAUSNUMERO + 52);
    ETERM          = (ZMQ_HAUSNUMERO + 53);
    EMTHREAD       = (ZMQ_HAUSNUMERO + 54);    

   {  Socket types   }
    ZMQ_PAIR = 0;
    ZMQ_PUB = 1;
    ZMQ_SUB = 2;
    ZMQ_REQ = 3;
    ZMQ_REP = 4;
    ZMQ_DEALER = 5;
    ZMQ_ROUTER = 6;
    ZMQ_PULL = 7;
    ZMQ_PUSH = 8;
    ZMQ_XPUB = 9;
    ZMQ_XSUB = 10;
    ZMQ_STREAM = 11;

  {** zmq **}

{$IFDEF CZMQ_LINKONREQUEST}

{$ELSE}
  function zmq_send (socket: Pointer; const buf; len: size_t; flags: Integer): Integer; cdecl; external ZMQ_LIB;
  function zmq_send_const (void *s, const void *buf, size_t len, int flags): Integer; cdecl; external ZMQ_LIB;
  function zmq_recv (void *s, void *buf, size_t len, int flags): Integer; cdecl; external ZMQ_LIB;
{$ENDIF}



  {** zctx **}

  type
    pzctx_t = ^zctx_t;
    zctx_t = record
    end;

{$IFDEF CZMQ_LINKONREQUEST}

  type
    zctx_new_func = function: pzctx_t; cdecl;
    zctx_destroy_func = procedure(var self: pzctx_t); cdecl;
    zctx_shadow_func = function(self: pzctx_t): pzctx_t; cdecl;
    zctx_shadow_zmq_ctx_func = function(zmqctx: Pointer): pzctx_t; cdecl;
    zctx_set_iothreads_func = procedure(self: pzctx_t; iothreads: Longint); cdecl;
    zctx_set_linger_func = procedure(self: pzctx_t; linger: Longint); cdecl;
    zctx_set_pipehwm_func = procedure(self: pzctx_t; pipehwm: Longint); cdecl;
    zctx_set_sndhwm_func = procedure(self: pzctx_t; sndhwm: Longint); cdecl;
    zctx_set_rcvhwm_func = procedure(self: pzctx_t; rcvhwm: Longint); cdecl;
    zctx_underlying_func = function(self: pzctx_t): Pointer; cdecl;
    zctx_test_func = function(verbose: Longbool): Longint; cdecl;

  var
    zctx_new : zctx_new_func;
    zctx_destroy : zctx_destroy_func;
    zctx_shadow : zctx_shadow_func;
    zctx_shadow_zmq_ctx := zctx_shadow_zmq_ctx_func;
    zctx_set_iothreads := zctx_set_iothreads_func;
    zctx_set_linger := zctx_set_linger_func;
    zctx_set_pipehwm := zctx_set_pipehwm_func;
    zctx_set_sndhwm := zctx_set_sndhwm_func;
    zctx_set_rcvhwm := zctx_set_rcvhwm_func;
    zctx_underlying := zctx_underlying_func;
    zctx_test := zctx_test_func;

    zctx_interrupted: PInteger;

{$ELSE ~CZMQ_LINKONREQUEST}

  {  Create new context, returns context object, replaces zmq_init }
    function zctx_new: pzctx_t; cdecl; external CZMQ_LIB;

  {  Destroy context and all sockets in it, replaces zmq_term }
    procedure zctx_destroy(var self: pzctx_t); cdecl; external CZMQ_LIB;

  {  Create new shadow context, returns context object }
    function zctx_shadow(self: pzctx_t): pzctx_t; cdecl; external CZMQ_LIB;

  {  Create a new context by shadowing a plain zmq context }
    function zctx_shadow_zmq_ctx(zmqctx: Pointer): pzctx_t; cdecl; external CZMQ_LIB;

  {  Raise default I/O threads from 1, for crazy heavy applications }
  {  The rule of thumb is one I/O thread per gigabyte of traffic in }
  {  or out. Call this method before creating any sockets on the context, }
  {  or calling zctx_shadow, or the setting will have no effect. }
    procedure zctx_set_iothreads(self: pzctx_t; iothreads: Longint); cdecl; external CZMQ_LIB;

  {  Set msecs to flush sockets when closing them, see the ZMQ_LINGER }
  {  man page section for more details. By default, set to zero, so }
  {  any in-transit messages are discarded when you destroy a socket or }
  {  a context. }
    procedure zctx_set_linger(self: pzctx_t; linger: Longint); cdecl; external CZMQ_LIB;

  {  Set initial high-water mark for inter-thread pipe sockets. Note that }
  {  this setting is separate from the default for normal sockets. You  }
  {  should change the default for pipe sockets *with care*. Too low values }
  {  will cause blocked threads, and an infinite setting can cause memory }
  {  exhaustion. The default, no matter the underlying ZeroMQ version, is }
  {  1,000. }
    procedure zctx_set_pipehwm(self: pzctx_t; pipehwm: Longint); cdecl; external CZMQ_LIB;

  {  Set initial send HWM for all new normal sockets created in context. }
  {  You can set this per-socket after the socket is created. }
  {  The default, no matter the underlying ZeroMQ version, is 1,000. }
    procedure zctx_set_sndhwm(self: pzctx_t; sndhwm: Longint); cdecl; external CZMQ_LIB;
    
  {  Set initial receive HWM for all new normal sockets created in context. }
  {  You can set this per-socket after the socket is created. }
  {  The default, no matter the underlying ZeroMQ version, is 1,000. }
    procedure zctx_set_rcvhwm(self: pzctx_t; rcvhwm: Longint); cdecl; external CZMQ_LIB;
    
  {  Return low-level 0MQ context object, will be NULL before first socket }
  {  is created. Use with care. }
    function zctx_underlying(self: pzctx_t): Pointer; cdecl; external CZMQ_LIB;
    
  {  Self test of this class }
    function zctx_test(verbose: Longbool): Longint; cdecl; external CZMQ_LIB;
    
  var
  {  Global signal indicator, TRUE when user presses Ctrl-C or the process }
  {  gets a SIGTERM signal. }
    zctx_interrupted: Integer;
{$ENDIF ~CZMQ_LINKONREQUEST}

  {** zsocket **}

  {  This port range is defined by IANA for dynamic or private ports }
  {  We use this when choosing a port for dynamic binding. }
  const
    ZSOCKET_DYNFROM = $c000;    
    ZSOCKET_DYNTO = $ffff;   

  type
    //  Callback function for zero-copy methods
    zsocket_free_fn = procedure(data: Pointer; arg: Pointer); cdecl;

{$IFDEF CZMQ_LINKONREQUEST}
  type
    zsocket_new_func = function(self: pzctx_t; atype: Longint): Pointer; cdecl;
    zsocket_destroy_func = procedure(self: pzctx_t; socket: Pointer); cdecl;
    zsocket_bind_func = function(socket: Pointer; format: PAnsiChar): Longint; varargs; cdecl;
    zsocket_unbind_func = function(socket: Pointer; format: PAnsiChar): Longint; varargs; cdecl;
    zsocket_connect_func = function(socket: Pointer; format: PAnsiChar): Longint; varargs; cdecl;
    zsocket_disconnect_func = function(socket: Pointer; format: PAnsiChar): Longint; varargs; cdecl;
    zsocket_poll_func = function(socket: Pointer; msecs: Longint): Longbool; varargs; cdecl;
    zsocket_type_str_func = function(socket: Pointer): PAnsiChar; cdecl;
    zsocket_sendmem_func = function(socket: Pointer; const data; size: size_t;
                           flags: Longint): Longint; cdecl;
    zsocket_signal_func = function(socket: Pointer): Longint; cdecl;
    zsocket_wait_func = function(socket: Pointer): Longint; cdecl;
    zsocket_test_func = function(verbose: Longbool): Longint; cdecl;

  var
    zsocket_new: zsocket_new_func;
    zsocket_destroy: zsocket_destroy_func;
    zsocket_bind: zsocket_bind_func;
    zsocket_unbind: zsocket_unbind_func;
    zsocket_connect: zsocket_connect_func;
    zsocket_disconnect: zsocket_disconnect_func;
    zsocket_poll: zsocket_poll_func;
    zsocket_type_str: zsocket_type_str_func;
    zsocket_sendmem: zsocket_sendmem_func;
    zsocket_signal: zsocket_signal_func;
    zsocket_wait: zsocket_wait_func;
    zsocket_test: zsocket_test_func;

{$ELSE ~CZMQ_LINKONREQUEST}

  {  Create a new socket within our CZMQ context, replaces zmq_socket. }
  {  Use this to get automatic management of the socket at shutdown. }
  {  Note: SUB sockets do not automatically subscribe to everything; you }
  {  must set filters explicitly. }
    function zsocket_new(self: pzctx_t; atype: Longint): Pointer; cdecl; external CZMQ_LIB;
    
  {  Destroy a socket within our CZMQ context, replaces zmq_close. }
    procedure zsocket_destroy(self: pzctx_t; socket: Pointer); cdecl; external CZMQ_LIB;
    
  {  Bind a socket to a formatted endpoint. If the port is specified as }
  {  '*', binds to any free port from ZSOCKET_DYNFROM to ZSOCKET_DYNTO }
  {  and returns the actual port number used. Otherwise asserts that the }
  {  bind succeeded with the specified port number. Always returns the }
  {  port number if successful. }
    function zsocket_bind(socket: Pointer; format: PAnsiChar): Longint; varargs; cdecl; external CZMQ_LIB;

  {  Unbind a socket from a formatted endpoint. }
  {  Returns 0 if OK, -1 if the endpoint was invalid or the function }
  {  isn't supported. }
    function zsocket_unbind(socket: Pointer; format: PAnsiChar): Longint; varargs; cdecl; external CZMQ_LIB;
    
  {  Connect a socket to a formatted endpoint }
  {  Returns 0 if OK, -1 if the endpoint was invalid. }
    function zsocket_connect(socket: Pointer; format: PAnsiChar): Longint; varargs; cdecl; external CZMQ_LIB;
    
  {  Disonnect a socket from a formatted endpoint }
  {  Returns 0 if OK, -1 if the endpoint was invalid or the function }
  {  isn't supported. }
    function zsocket_disconnect(socket: Pointer; format: PAnsiChar): Longint; varargs; cdecl; external CZMQ_LIB;
    
  {  Poll for input events on the socket. Returns TRUE if there is input }
  {  ready on the socket, else FALSE. }
    function zsocket_poll(socket: Pointer; msecs: Longint): Longbool; varargs; cdecl; external CZMQ_LIB;
    
  {  Returns socket type as printable constant string }
    function zsocket_type_str(socket: Pointer): PAnsiChar; cdecl; external CZMQ_LIB;
    
  {  Send data over a socket as a single message frame. }
  {  Accepts these flags: ZFRAME_MORE and ZFRAME_DONTWAIT. }
    function zsocket_sendmem(socket: Pointer; const data; size: size_t; flags: Longint = 0): Longint; cdecl; external CZMQ_LIB;
    
  {  Send a signal over a socket. A signal is a zero-byte message. }
  {  Signals are used primarily between threads, over pipe sockets. }
  {  Returns -1 if there was an error sending the signal. }
    function zsocket_signal(socket: Pointer): Longint; cdecl; external CZMQ_LIB;
    
  {  Wait on a signal. Use this to coordinate between threads, over }
  {  pipe pairs. Returns -1 on error, 0 on success. }
    function zsocket_wait(socket: Pointer): Longint; cdecl; external CZMQ_LIB;
    
  {  Self test of this class }
    function zsocket_test(verbose: Longbool): Longint; cdecl; external CZMQ_LIB;

{$ENDIF ~CZMQ_LINKONREQUEST}

  {** zsockopt **}

{$IFDEF CZMQ_LINKONREQUEST}
  type
    zsocket_tos_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_plain_server_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_plain_username_func = function (zocket: Pointer): PAnsiChar; cdecl;
    zsocket_plain_password_func = function (zocket: Pointer): PAnsiChar; cdecl;
    zsocket_curve_server_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_curve_publickey_func = function (zocket: Pointer): PAnsiChar; cdecl;
    zsocket_curve_secretkey_func = function (zocket: Pointer): PAnsiChar; cdecl;
    zsocket_curve_serverkey_func = function (zocket: Pointer): PAnsiChar; cdecl;
    zsocket_zap_domain_func = function (zocket: Pointer): PAnsiChar; cdecl;
    zsocket_mechanism_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_ipv6_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_immediate_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_ipv4only_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_type_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_sndhwm_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_rcvhwm_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_affinity_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_identity_func = function (zocket: Pointer): PAnsiChar; cdecl;
    zsocket_rate_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_recovery_ivl_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_sndbuf_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_rcvbuf_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_linger_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_reconnect_ivl_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_reconnect_ivl_max_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_backlog_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_maxmsgsize_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_multicast_hops_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_rcvtimeo_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_sndtimeo_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_tcp_keepalive_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_tcp_keepalive_idle_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_tcp_keepalive_cnt_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_tcp_keepalive_intvl_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_tcp_accept_filter_func = function (zocket: Pointer): PAnsiChar; cdecl;
    zsocket_rcvmore_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_fd_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_events_func = function (zocket: Pointer): Longint; cdecl;
    zsocket_last_endpoint_func = function (zocket: Pointer): PAnsiChar; cdecl;
    zsocket_set_tos_func = procedure (zocket: Pointer; tos: Longint); cdecl;
    zsocket_set_router_handover_func = procedure (zocket: Pointer; router_handover: Longint); cdecl;
    zsocket_set_router_mandatory_func = procedure (zocket: Pointer; router_mandatory: Longint); cdecl;
    zsocket_set_probe_router_func = procedure (zocket: Pointer; probe_router: Longint); cdecl;
    zsocket_set_req_relaxed_func = procedure (zocket: Pointer; req_relaxed: Longint); cdecl;
    zsocket_set_req_correlate_func = procedure (zocket: Pointer; req_correlate: Longint); cdecl;
    zsocket_set_conflate_func = procedure (zocket: Pointer; conflate: Longint); cdecl;
    zsocket_set_plain_server_func = procedure (zocket: Pointer; plain_server: Longint); cdecl;
    zsocket_set_plain_username_func = procedure (zocket: Pointer; plain_username: PAnsiChar); cdecl;
    zsocket_set_plain_password_func = procedure (zocket: Pointer; plain_password: PAnsiChar); cdecl;
    zsocket_set_curve_server_func = procedure (zocket: Pointer; curve_server: Longint); cdecl;
    zsocket_set_curve_publickey_func = procedure (zocket: Pointer; curve_publickey: PAnsiChar); cdecl;
    zsocket_set_curve_publickey_bin_func = procedure (zocket: Pointer; var curve_publickey:byte); cdecl;
    zsocket_set_curve_secretkey_func = procedure (zocket: Pointer; curve_secretkey: PAnsiChar); cdecl;
    zsocket_set_curve_secretkey_bin_func = procedure (zocket: Pointer; var curve_secretkey:byte); cdecl;
    zsocket_set_curve_serverkey_func = procedure (zocket: Pointer; curve_serverkey: PAnsiChar); cdecl;
    zsocket_set_curve_serverkey_bin_func = procedure (zocket: Pointer; var curve_serverkey:byte); cdecl;
    zsocket_set_zap_domain_func = procedure (zocket: Pointer; zap_domain: PAnsiChar); cdecl;
    zsocket_set_ipv6_func = procedure (zocket: Pointer; ipv6: Longint); cdecl;
    zsocket_set_immediate_func = procedure (zocket: Pointer; immediate: Longint); cdecl;
    zsocket_set_router_raw_func = procedure (zocket: Pointer; router_raw: Longint); cdecl;
    zsocket_set_ipv4only_func = procedure (zocket: Pointer; ipv4only: Longint); cdecl;
    zsocket_set_delay_attach_on_connect_func = procedure (zocket: Pointer; delay_attach_on_connect: Longint); cdecl;
    zsocket_set_sndhwm_func = procedure (zocket: Pointer; sndhwm: Longint); cdecl;
    zsocket_set_rcvhwm_func = procedure (zocket: Pointer; rcvhwm: Longint); cdecl;
    zsocket_set_affinity_func = procedure (zocket: Pointer; affinity: Longint); cdecl;
    zsocket_set_subscribe_func = procedure (zocket: Pointer; subscribe: PAnsiChar); cdecl;
    zsocket_set_unsubscribe_func = procedure (zocket: Pointer; unsubscribe: PAnsiChar); cdecl;
    zsocket_set_identity_func = procedure (zocket: Pointer; identity: PAnsiChar); cdecl;
    zsocket_set_rate_func = procedure (zocket: Pointer; rate: Longint); cdecl;
    zsocket_set_recovery_ivl_func = procedure (zocket: Pointer; recovery_ivl: Longint); cdecl;
    zsocket_set_sndbuf_func = procedure (zocket: Pointer; sndbuf: Longint); cdecl;
    zsocket_set_rcvbuf_func = procedure (zocket: Pointer; rcvbuf: Longint); cdecl;
    zsocket_set_linger_func = procedure (zocket: Pointer; linger: Longint); cdecl;
    zsocket_set_reconnect_ivl_func = procedure (zocket: Pointer; reconnect_ivl: Longint); cdecl;
    zsocket_set_reconnect_ivl_max_func = procedure (zocket: Pointer; reconnect_ivl_max: Longint); cdecl;
    zsocket_set_backlog_func = procedure (zocket: Pointer; backlog: Longint); cdecl;
    zsocket_set_maxmsgsize_func = procedure (zocket: Pointer; maxmsgsize: Longint); cdecl;
    zsocket_set_multicast_hops_func = procedure (zocket: Pointer; multicast_hops: Longint); cdecl;
    zsocket_set_rcvtimeo_func = procedure (zocket: Pointer; rcvtimeo: Longint); cdecl;
    zsocket_set_sndtimeo_func = procedure (zocket: Pointer; sndtimeo: Longint); cdecl;
    zsocket_set_xpub_verbose_func = procedure (zocket: Pointer; xpub_verbose: Longint); cdecl;
    zsocket_set_tcp_keepalive_func = procedure (zocket: Pointer; tcp_keepalive: Longint); cdecl;
    zsocket_set_tcp_keepalive_idle_func = procedure (zocket: Pointer; tcp_keepalive_idle: Longint); cdecl;
    zsocket_set_tcp_keepalive_cnt_func = procedure (zocket: Pointer; tcp_keepalive_cnt: Longint); cdecl;
    zsocket_set_tcp_keepalive_intvl_func = procedure (zocket: Pointer; tcp_keepalive_intvl: Longint); cdecl;
    zsocket_set_tcp_accept_filter_func = procedure (zocket: Pointer; tcp_accept_filter: PAnsiChar); cdecl;
    zsocket_set_hwm_func = procedure (zocket: Pointer; hwm: Longint); cdecl;
    zsockopt_test_func = function (verbose: Longbool): Longint; cdecl;

  var
    zsocket_tos : zsocket_tos_func;
    zsocket_plain_server : zsocket_plain_server_func;
    zsocket_plain_username : zsocket_plain_username_func;
    zsocket_plain_password : zsocket_plain_password_func;
    zsocket_curve_server : zsocket_curve_server_func;
    zsocket_curve_publickey : zsocket_curve_publickey_func;
    zsocket_curve_secretkey : zsocket_curve_secretkey_func;
    zsocket_curve_serverkey : zsocket_curve_serverkey_func;
    zsocket_zap_domain : zsocket_zap_domain_func;
    zsocket_mechanism : zsocket_mechanism_func;
    zsocket_ipv6 : zsocket_ipv6_func;
    zsocket_immediate : zsocket_immediate_func;
    zsocket_ipv4only : zsocket_ipv4only_func;
    zsocket_type : zsocket_type_func;
    zsocket_sndhwm : zsocket_sndhwm_func;
    zsocket_rcvhwm : zsocket_rcvhwm_func;
    zsocket_affinity : zsocket_affinity_func;
    zsocket_identity : zsocket_identity_func;
    zsocket_rate : zsocket_rate_func;
    zsocket_recovery_ivl : zsocket_recovery_ivl_func;
    zsocket_sndbuf : zsocket_sndbuf_func;
    zsocket_rcvbuf : zsocket_rcvbuf_func;
    zsocket_linger : zsocket_linger_func;
    zsocket_reconnect_ivl : zsocket_reconnect_ivl_func;
    zsocket_reconnect_ivl_max : zsocket_reconnect_ivl_max_func;
    zsocket_backlog : zsocket_backlog_func;
    zsocket_maxmsgsize : zsocket_maxmsgsize_func;
    zsocket_multicast_hops : zsocket_multicast_hops_func;
    zsocket_rcvtimeo : zsocket_rcvtimeo_func;
    zsocket_sndtimeo : zsocket_sndtimeo_func;
    zsocket_tcp_keepalive : zsocket_tcp_keepalive_func;
    zsocket_tcp_keepalive_idle : zsocket_tcp_keepalive_idle_func;
    zsocket_tcp_keepalive_cnt : zsocket_tcp_keepalive_cnt_func;
    zsocket_tcp_keepalive_intvl : zsocket_tcp_keepalive_intvl_func;
    zsocket_tcp_accept_filter : zsocket_tcp_accept_filter_func;
    zsocket_rcvmore : zsocket_rcvmore_func;
    zsocket_fd : zsocket_fd_func;
    zsocket_events : zsocket_events_func;
    zsocket_last_endpoint : zsocket_last_endpoint_func;
    zsocket_set_tos : zsocket_set_tos_func;
    zsocket_set_router_handover : zsocket_set_router_handover_func;
    zsocket_set_router_mandatory : zsocket_set_router_mandatory_func;
    zsocket_set_probe_router : zsocket_set_probe_router_func;
    zsocket_set_req_relaxed : zsocket_set_req_relaxed_func;
    zsocket_set_req_correlate : zsocket_set_req_correlate_func;
    zsocket_set_conflate : zsocket_set_conflate_func;
    zsocket_set_plain_server : zsocket_set_plain_server_func;
    zsocket_set_plain_username : zsocket_set_plain_username_func;
    zsocket_set_plain_password : zsocket_set_plain_password_func;
    zsocket_set_curve_server : zsocket_set_curve_server_func;
    zsocket_set_curve_publickey : zsocket_set_curve_publickey_func;
    zsocket_set_curve_publickey_bin : zsocket_set_curve_publickey_bin_func;
    zsocket_set_curve_secretkey : zsocket_set_curve_secretkey_func;
    zsocket_set_curve_secretkey_bin : zsocket_set_curve_secretkey_bin_func;
    zsocket_set_curve_serverkey : zsocket_set_curve_serverkey_func;
    zsocket_set_curve_serverkey_bin : zsocket_set_curve_serverkey_bin_func;
    zsocket_set_zap_domain : zsocket_set_zap_domain_func;
    zsocket_set_ipv6 : zsocket_set_ipv6_func;
    zsocket_set_immediate : zsocket_set_immediate_func;
    zsocket_set_router_raw : zsocket_set_router_raw_func;
    zsocket_set_ipv4only : zsocket_set_ipv4only_func;
    zsocket_set_delay_attach_on_connect : zsocket_set_delay_attach_on_connect_func;
    zsocket_set_sndhwm : zsocket_set_sndhwm_func;
    zsocket_set_rcvhwm : zsocket_set_rcvhwm_func;
    zsocket_set_affinity : zsocket_set_affinity_func;
    zsocket_set_subscribe : zsocket_set_subscribe_func;
    zsocket_set_unsubscribe : zsocket_set_unsubscribe_func;
    zsocket_set_identity : zsocket_set_identity_func;
    zsocket_set_rate : zsocket_set_rate_func;
    zsocket_set_recovery_ivl : zsocket_set_recovery_ivl_func;
    zsocket_set_sndbuf : zsocket_set_sndbuf_func;
    zsocket_set_rcvbuf : zsocket_set_rcvbuf_func;
    zsocket_set_linger : zsocket_set_linger_func;
    zsocket_set_reconnect_ivl : zsocket_set_reconnect_ivl_func;
    zsocket_set_reconnect_ivl_max : zsocket_set_reconnect_ivl_max_func;
    zsocket_set_backlog : zsocket_set_backlog_func;
    zsocket_set_maxmsgsize : zsocket_set_maxmsgsize_func;
    zsocket_set_multicast_hops : zsocket_set_multicast_hops_func;
    zsocket_set_rcvtimeo : zsocket_set_rcvtimeo_func;
    zsocket_set_sndtimeo : zsocket_set_sndtimeo_func;
    zsocket_set_xpub_verbose : zsocket_set_xpub_verbose_func;
    zsocket_set_tcp_keepalive : zsocket_set_tcp_keepalive_func;
    zsocket_set_tcp_keepalive_idle : zsocket_set_tcp_keepalive_idle_func;
    zsocket_set_tcp_keepalive_cnt : zsocket_set_tcp_keepalive_cnt_func;
    zsocket_set_tcp_keepalive_intvl : zsocket_set_tcp_keepalive_intvl_func;
    zsocket_set_tcp_accept_filter : zsocket_set_tcp_accept_filter_func;
    zsocket_set_hwm : zsocket_set_hwm_func;
    zsockopt_test : zsockopt_test_func;

{$ELSE ~CZMQ_LINKONREQUEST}
    function zsocket_tos(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_plain_server(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_plain_username(zocket: Pointer): PAnsiChar; cdecl; external CZMQ_LIB;
    function zsocket_plain_password(zocket: Pointer): PAnsiChar; cdecl; external CZMQ_LIB;
    function zsocket_curve_server(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_curve_publickey(zocket: Pointer): PAnsiChar; cdecl; external CZMQ_LIB;
    function zsocket_curve_secretkey(zocket: Pointer): PAnsiChar; cdecl; external CZMQ_LIB;
    function zsocket_curve_serverkey(zocket: Pointer): PAnsiChar; cdecl; external CZMQ_LIB;
    function zsocket_zap_domain(zocket: Pointer): PAnsiChar; cdecl; external CZMQ_LIB;
    function zsocket_mechanism(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_ipv6(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_immediate(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_ipv4only(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_type(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_sndhwm(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_rcvhwm(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_affinity(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_identity(zocket: Pointer): PAnsiChar; cdecl; external CZMQ_LIB;
    function zsocket_rate(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_recovery_ivl(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_sndbuf(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_rcvbuf(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_linger(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_reconnect_ivl(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_reconnect_ivl_max(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_backlog(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_maxmsgsize(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_multicast_hops(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_rcvtimeo(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_sndtimeo(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_tcp_keepalive(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_tcp_keepalive_idle(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_tcp_keepalive_cnt(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_tcp_keepalive_intvl(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_tcp_accept_filter(zocket: Pointer): PAnsiChar; cdecl; external CZMQ_LIB;
    function zsocket_rcvmore(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_fd(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_events(zocket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zsocket_last_endpoint(zocket: Pointer): PAnsiChar; cdecl; external CZMQ_LIB;
  {  Set socket options }
    procedure zsocket_set_tos(zocket: Pointer; tos: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_router_handover(zocket: Pointer; router_handover: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_router_mandatory(zocket: Pointer; router_mandatory: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_probe_router(zocket: Pointer; probe_router: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_req_relaxed(zocket: Pointer; req_relaxed: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_req_correlate(zocket: Pointer; req_correlate: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_conflate(zocket: Pointer; conflate: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_plain_server(zocket: Pointer; plain_server: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_plain_username(zocket: Pointer; plain_username: PAnsiChar); cdecl; external CZMQ_LIB;
    procedure zsocket_set_plain_password(zocket: Pointer; plain_password: PAnsiChar); cdecl; external CZMQ_LIB;
    procedure zsocket_set_curve_server(zocket: Pointer; curve_server: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_curve_publickey(zocket: Pointer; curve_publickey: PAnsiChar); cdecl; external CZMQ_LIB;
    procedure zsocket_set_curve_publickey_bin(zocket: Pointer; var curve_publickey:byte); cdecl; external CZMQ_LIB;
    procedure zsocket_set_curve_secretkey(zocket: Pointer; curve_secretkey: PAnsiChar); cdecl; external CZMQ_LIB;
    procedure zsocket_set_curve_secretkey_bin(zocket: Pointer; var curve_secretkey:byte); cdecl; external CZMQ_LIB;
    procedure zsocket_set_curve_serverkey(zocket: Pointer; curve_serverkey: PAnsiChar); cdecl; external CZMQ_LIB;
    procedure zsocket_set_curve_serverkey_bin(zocket: Pointer; var curve_serverkey:byte); cdecl; external CZMQ_LIB;
    procedure zsocket_set_zap_domain(zocket: Pointer; zap_domain: PAnsiChar); cdecl; external CZMQ_LIB;
    procedure zsocket_set_ipv6(zocket: Pointer; ipv6: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_immediate(zocket: Pointer; immediate: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_router_raw(zocket: Pointer; router_raw: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_ipv4only(zocket: Pointer; ipv4only: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_delay_attach_on_connect(zocket: Pointer; delay_attach_on_connect: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_sndhwm(zocket: Pointer; sndhwm: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_rcvhwm(zocket: Pointer; rcvhwm: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_affinity(zocket: Pointer; affinity: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_subscribe(zocket: Pointer; subscribe: PAnsiChar); cdecl; external CZMQ_LIB;
    procedure zsocket_set_unsubscribe(zocket: Pointer; unsubscribe: PAnsiChar); cdecl; external CZMQ_LIB;
    procedure zsocket_set_identity(zocket: Pointer; identity: PAnsiChar); cdecl; external CZMQ_LIB;
    procedure zsocket_set_rate(zocket: Pointer; rate: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_recovery_ivl(zocket: Pointer; recovery_ivl: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_sndbuf(zocket: Pointer; sndbuf: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_rcvbuf(zocket: Pointer; rcvbuf: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_linger(zocket: Pointer; linger: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_reconnect_ivl(zocket: Pointer; reconnect_ivl: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_reconnect_ivl_max(zocket: Pointer; reconnect_ivl_max: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_backlog(zocket: Pointer; backlog: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_maxmsgsize(zocket: Pointer; maxmsgsize: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_multicast_hops(zocket: Pointer; multicast_hops: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_rcvtimeo(zocket: Pointer; rcvtimeo: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_sndtimeo(zocket: Pointer; sndtimeo: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_xpub_verbose(zocket: Pointer; xpub_verbose: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_tcp_keepalive(zocket: Pointer; tcp_keepalive: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_tcp_keepalive_idle(zocket: Pointer; tcp_keepalive_idle: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_tcp_keepalive_cnt(zocket: Pointer; tcp_keepalive_cnt: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_tcp_keepalive_intvl(zocket: Pointer; tcp_keepalive_intvl: Longint); cdecl; external CZMQ_LIB;
    procedure zsocket_set_tcp_accept_filter(zocket: Pointer; tcp_accept_filter: PAnsiChar); cdecl; external CZMQ_LIB;
  {  Emulation of widely-used 2.x socket options }
    procedure zsocket_set_hwm(zocket: Pointer; hwm: Longint); cdecl; external CZMQ_LIB;
  {  Self test of this class }
    function zsockopt_test(verbose: Longbool): Longint; cdecl; external CZMQ_LIB;

    {$ENDIF ~CZMQ_LINKONREQUEST}

    {** zframe **}

  type
      pzframe_t = ^zframe_t;
      zframe_t = record // opaque datatype
      end;

  const
      FRAME_MORE = 1;
      FRAME_REUSE = 2;
      FRAME_DONTWAIT = 4;

  {$IFDEF CZMQ_LINKONREQUEST}
  var
    {  Create a new frame with optional size, and optional data }
      zframe_new : function(const data; size: NativeUInt): pzframe_t; cdecl;

    {  Create an empty (zero-sized) frame }
      zframe_new_empty : function: pzframe_t; cdecl;

    {  Destroy a frame }
      zframe_destroy : procedure(var self: pzframe_t); cdecl;

    {  Receive frame from socket, returns zframe_t object or NULL if the recv }
    {  was interrupted. Does a blocking recv, if you want to not block then use }
    {  zframe_recv_nowait(). }
      zframe_recv : function(socket: Pointer): pzframe_t; cdecl;

    {  Receive a new frame off the socket. Returns newly allocated frame, or }
    {  NULL if there was no input waiting, or if the read was interrupted. }
      zframe_recv_nowait : function(socket: Pointer): pzframe_t; cdecl;

    { Send a frame to a socket, destroy frame after sending. }
    { Return -1 on error, 0 on success. }
      zframe_send : function(var self: pzframe_t; socket: Pointer; flags: Longint): Longint; cdecl;

    {  Return number of bytes in frame data }
      zframe_size : function(self: pzframe_t): NativeUInt; cdecl;

    {  Return address of frame data }
      zframe_data : function(self: pzframe_t): PByte; cdecl;

    {  Create a new frame that duplicates an existing frame }
      zframe_dup : function(self: pzframe_t): pzframe_t; cdecl;

    {  Return frame data encoded as printable hex string }
      zframe_strhex : function(self: pzframe_t): PAnsiChar; cdecl;

    {  Return frame data copied into freshly allocated string }
      zframe_strdup : function(self: pzframe_t): PAnsiChar; cdecl;

    {  Return TRUE if frame body is equal to string, excluding terminator }
      zframe_streq : function(self: pzframe_t; _string: PAnsiChar): Longbool; cdecl;

    {  Return frame MORE indicator (1 or 0), set when reading frame from socket }
    {  or by the zframe_set_more() method }
      zframe_more : function(self: pzframe_t): Longint; cdecl;

    {  Set frame MORE indicator (1 or 0). Note this is NOT used when sending  }
    {  frame to socket, you have to specify flag explicitly. }
      zframe_set_more : procedure(self: pzframe_t; more: Longint); cdecl;

    {  Return TRUE if two frames have identical size and data }
    {  If either frame is NULL, equality is always false. }
      zframe_eq : function(self: pzframe_t; other: pzframe_t): Longbool; cdecl;

    {   Print contents of the frame to FILE stream. }
      zframe_fprint : procedure(self: pzframe_t; prefix: PAnsiChar; afile: Pointer); cdecl;

    {  Print contents of frame to stderr }
      zframe_print : procedure(self: pzframe_t; prefix: PAnsiChar); cdecl;

    {  Set new contents for frame }
      zframe_reset : procedure(self: pzframe_t; const data; size: size_t); cdecl;

    {  Put a block of data to the frame payload. }
      zframe_put_block : function(self: pzframe_t; data: PByteArray; size: size_t): Longint; cdecl;

    {  Self test of this class }
      zframe_test : function(verbose: Longbool): Longint; cdecl;

    {$ELSE ~CZMQ_LINKONREQUEST}

      function zframe_new(const data; size: NativeUInt): pzframe_t; cdecl; external CZMQ_LIB;
      function zframe_new_empty: pzframe_t; cdecl; external CZMQ_LIB;
      procedure zframe_destroy(var self: pzframe_t); cdecl; external CZMQ_LIB;
      function zframe_recv(socket: Pointer): pzframe_t; cdecl; external CZMQ_LIB;
      function zframe_recv_nowait(socket: Pointer): pzframe_t; cdecl; external CZMQ_LIB;
      function zframe_send(var self: pzframe_t; socket: Pointer; flags: Longint): Longint; cdecl; external CZMQ_LIB;
      function zframe_size(self: pzframe_t): NativeUInt; cdecl; external CZMQ_LIB;
      function zframe_data(self: pzframe_t): PByte; cdecl; external CZMQ_LIB;
      function zframe_dup(self: pzframe_t): pzframe_t; cdecl; external CZMQ_LIB;
      function zframe_strhex(self: pzframe_t): PAnsiChar; cdecl; external CZMQ_LIB;
      function zframe_strdup(self: pzframe_t): PAnsiChar; cdecl; external CZMQ_LIB;
      function zframe_streq(self: pzframe_t; _string: PAnsiChar): Longbool; cdecl; external CZMQ_LIB;
      function zframe_more(self: pzframe_t): Longint; cdecl; external CZMQ_LIB;
      procedure zframe_set_more(self: pzframe_t; more: Longint); cdecl; external CZMQ_LIB;
      function zframe_eq(self: pzframe_t; other: pzframe_t): Longbool; cdecl; external CZMQ_LIB;
      procedure zframe_fprint(self: pzframe_t; prefix: PAnsiChar; afile: Pointer); cdecl; external CZMQ_LIB;
      procedure zframe_print(self: pzframe_t; prefix: PAnsiChar); cdecl; external CZMQ_LIB;
      procedure zframe_reset(self: pzframe_t; const data; size: size_t); cdecl; external CZMQ_LIB;
      function zframe_put_block(self: pzframe_t; data: PByteArray; size: size_t): Longint; cdecl; external CZMQ_LIB;
      function zframe_test(verbose: Longbool): Longint; cdecl; external CZMQ_LIB;

    {$ENDIF ~CZMQ_LINKONREQUEST}


  {** zmsg **}

  type
    pzmsg_t = ^zmsg_t;
    zmsg_t = record // opaque dataType
    end;


  {$IFDEF CZMQ_LINKONREQUEST}

  var
  {  Create a new empty message object }
    zmsg_new : function: pzmsg_t; cdecl;
    
  {  Destroy a message object and all frames it contains }
    zmsg_destroy : procedure(var self: pzmsg_t); cdecl;
    
  {  Receive message from socket, returns zmsg_t object or NULL if the recv }
  {  was interrupted. Does a blocking recv, if you want to not block then use }
  {  the zloop class or zmsg_recv_nowait() or zmq_poll to check for socket input before receiving. }
    zmsg_recv : function(socket: Pointer): pzmsg_t; cdecl;
    
  {  Receive message from socket, returns zmsg_t object, or NULL either if there was }
  {  no input waiting, or the recv was interrupted. }
    zmsg_recv_nowait : function(socket: Pointer): pzmsg_t; cdecl;
    
  {  Send message to socket, destroy after sending. If the message has no }
  {  frames, sends nothing but destroys the message anyhow. Safe to call }
  {  if zmsg is null. }
    zmsg_send : function(var self: pzmsg_t; socket: Pointer): Longint; cdecl;
    
  {  Return size of message, i.e. number of frames (0 or more). }
    zmsg_size : function(self: pzmsg_t): NativeUInt; cdecl;
    
  {  Return total size of all frames in message. }
    zmsg_content_size : function(self: pzmsg_t): NativeUInt; cdecl;
    
  {  Push frame to the front of the message, i.e. before all other frames. }
  {  Message takes ownership of frame, will destroy it when message is sent. }
  {  Returns 0 on success, -1 on error. Deprecates zmsg_push, which did not }
  {  nullify the caller's frame reference. }
    zmsg_prepend : function(self: pzmsg_t; var frame_p: pzframe_t): Longint; cdecl;
    
  {  Add frame to the end of the message, i.e. after all other frames. }
  {  Message takes ownership of frame, will destroy it when message is sent. }
  {  Returns 0 on success. Deprecates zmsg_add, which did not nullify the }
  {  caller's frame reference. }
    zmsg_append : function(self: pzmsg_t; var frame_p: pzframe_t): Longint; cdecl;
    
  {  Remove first frame from message, if any. Returns frame, or NULL. Caller }
  {  now owns frame and must destroy it when finished with it. }
    zmsg_pop : function(self: pzmsg_t): pzframe_t; cdecl;
    
  {  Push block of memory to front of message, as a new frame. }
  {  Returns 0 on success, -1 on error. }
    zmsg_pushmem : function(self: pzmsg_t; const src; size: NativeUInt): Longint; cdecl;
    
  {  Add block of memory to the end of the message, as a new frame. }
  {  Returns 0 on success, -1 on error. }
    zmsg_addmem : function(self: pzmsg_t; const src; size: NativeUInt): Longint; cdecl;
    
  {  Push string as new frame to front of message. }
  {  Returns 0 on success, -1 on error. }
    zmsg_pushstr : function(self: pzmsg_t; astring: PAnsiChar): Longint; cdecl;
    
  {  Push string as new frame to end of message. }
  {  Returns 0 on success, -1 on error. }
    zmsg_addstr : function(self: pzmsg_t; astring: PAnsiChar): Longint; cdecl;
    
  {  Push formatted string as new frame to front of message. }
  {  Returns 0 on success, -1 on error. }
    zmsg_pushstrf : function(self: pzmsg_t; format: PAnsiChar{, ...}): Longint; varargs; cdecl;
    
  {  Push formatted string as new frame to end of message. }
  {  Returns 0 on success, -1 on error. }
    zmsg_addstrf : function(self: pzmsg_t; format: PAnsiChar{, ...}): Longint; varargs; cdecl;
    
  {  Pop frame off front of message, return as fresh string. If there were }
  {  no more frames in the message, returns NULL. }
    zmsg_popstr : function(self: pzmsg_t): PAnsiChar; cdecl;
    
  {  Pop frame off front of message, caller now owns frame }
  {  If next frame is empty, pops and destroys that empty frame. }
    zmsg_unwrap : function(self: pzmsg_t): pzframe_t; cdecl;
    
  {  Remove specified frame from list, if present. Does not destroy frame. }
    zmsg_remove : procedure(self: pzmsg_t; var frame:zframe_t); cdecl;
    
  {  Set cursor to first frame in message. Returns frame, or NULL, if the  }
  {  message is empty. Use this to navigate the frames as a list. }
    zmsg_first : function(self: pzmsg_t): pzframe_t; cdecl;
    
  {  Return the next frame. If there are no more frames, returns NULL. To move }
  {  to the first frame call zmsg_first(). Advances the cursor. }
    zmsg_next : function(self: pzmsg_t): pzframe_t; cdecl;
    
  {  Return the last frame. If there are no frames, returns NULL. }
    zmsg_last : function(self: pzmsg_t): pzframe_t; cdecl;
    
  {  Save message to an open file, return 0 if OK, else -1. The message is  }
  {  saved as a series of frames, each with length and data. Note that the }
  {  file is NOT guaranteed to be portable between operating systems, not }
  {  versions of CZMQ. The file format is at present undocumented and liable }
  {  to arbitrary change. }
    zmsg_save : function(self: pzmsg_t; afile: Pointer): Longint; cdecl;
    
  {  Load/append an open file into message, create new message if }
  {  null message provided. Returns NULL if the message could not  }
  {  be loaded. }
    zmsg_load : function(self: pzmsg_t; afile: Pointer): pzmsg_t; cdecl;
    
  {  Serialize multipart message to a single buffer. Use this method to send }
  {  structured messages across transports that do not support multipart data. }
  {  Allocates and returns a new buffer containing the serialized message. }
  {  To decode a serialized message buffer, use zmsg_decode (). }
    zmsg_encode : function(self: pzmsg_t; var buffer:Pbyte): NativeUInt; cdecl;
    
  {  Decodes a serialized message buffer created by zmsg_encode () and returns }
  {  a new zmsg_t object. Returns NULL if the buffer was badly formatted or  }
  {  there was insufficient memory to work. }
    zmsg_decode : function(var buffer; buffer_size: NativeUInt): pzmsg_t; cdecl;
    
  {  Create copy of message, as new message object. Returns a fresh zmsg_t }
  {  object, or NULL if there was not enough heap memory. }
    zmsg_dup : function(self: pzmsg_t): pzmsg_t; cdecl;
    
  {  Print message to open stream }
  {  Truncates to first 10 frames, for readability. }
    zmsg_fprint : procedure(self: pzmsg_t; afile: Pointer); cdecl;
    
  {  Print message to stdout }
    zmsg_print : procedure(self: pzmsg_t); cdecl;
    
  {  Self test of this class }
    zmsg_test : function(verbose: Longbool): Longint; cdecl;
    
  {$ELSE ~CZMQ_LINKONREQUEST}

    function zmsg_new: pzmsg_t; cdecl; external CZMQ_LIB;
    procedure zmsg_destroy(var self: pzmsg_t); cdecl; external CZMQ_LIB;
    function zmsg_recv(socket: Pointer): pzmsg_t; cdecl; external CZMQ_LIB;
    function zmsg_recv_nowait(socket: Pointer): pzmsg_t; cdecl; external CZMQ_LIB;
    function zmsg_send(var self: pzmsg_t; socket: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zmsg_size(self: pzmsg_t): NativeUInt; cdecl; external CZMQ_LIB;
    function zmsg_content_size(self: pzmsg_t): NativeUInt; cdecl; external CZMQ_LIB;
    function zmsg_prepend(self: pzmsg_t; var frame_p: pzframe_t): Longint; cdecl; external CZMQ_LIB;
    function zmsg_append(self: pzmsg_t; var frame_p: pzframe_t): Longint; cdecl; external CZMQ_LIB;
    function zmsg_pop(self: pzmsg_t): pzframe_t; cdecl; external CZMQ_LIB;
    function zmsg_pushmem(self: pzmsg_t; const src; size: NativeUInt): Longint; cdecl; external CZMQ_LIB;
    function zmsg_addmem(self: pzmsg_t; const src; size: NativeUInt): Longint; cdecl; external CZMQ_LIB;
    function zmsg_pushstr(self: pzmsg_t; astring: PAnsiChar): Longint; cdecl; external CZMQ_LIB;
    function zmsg_addstr(self: pzmsg_t; astring: PAnsiChar): Longint; cdecl; external CZMQ_LIB;
    function zmsg_pushstrf(self: pzmsg_t; format: PAnsiChar{, ...}): Longint; varargs; cdecl; external CZMQ_LIB;
    function zmsg_addstrf(self: pzmsg_t; format: PAnsiChar{, ...}): Longint; varargs; cdecl; external CZMQ_LIB;
    function zmsg_popstr(self: pzmsg_t): PAnsiChar; cdecl; external CZMQ_LIB;
    function zmsg_unwrap(self: pzmsg_t): pzframe_t; cdecl; external CZMQ_LIB;
    procedure zmsg_remove(self: pzmsg_t; var frame:zframe_t); cdecl; external CZMQ_LIB;
    function zmsg_first(self: pzmsg_t): pzframe_t; cdecl; external CZMQ_LIB;
    function zmsg_next(self: pzmsg_t): pzframe_t; cdecl; external CZMQ_LIB;
    function zmsg_last(self: pzmsg_t): pzframe_t; cdecl; external CZMQ_LIB;
    function zmsg_save(self: pzmsg_t; afile: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zmsg_load(self: pzmsg_t; afile: Pointer): pzmsg_t; cdecl; external CZMQ_LIB;
    function zmsg_encode(self: pzmsg_t; var buffer:Pbyte): NativeUInt; cdecl; external CZMQ_LIB;
    function zmsg_decode(var buffer; buffer_size: NativeUInt): pzmsg_t; cdecl; external CZMQ_LIB;
    function zmsg_dup(self: pzmsg_t): pzmsg_t; cdecl; external CZMQ_LIB;
    procedure zmsg_fprint(self: pzmsg_t; afile: Pointer); cdecl; external CZMQ_LIB;
    procedure zmsg_print(self: pzmsg_t); cdecl; external CZMQ_LIB;
    function zmsg_test(verbose: Longbool): Longint; cdecl; external CZMQ_LIB;

  {$ENDIF ~CZMQ_LINKONREQUEST}

{** zloop **}

  type
    pzloop_t = ^zloop_t;
    zloop_t = record // opaque struct
    end;

    //  Callback function for reactor events
    zloop_fn = function(loop: pzloop_t; poolitem: Pointer; arg: Pointer): Longint; cdecl;
    
    // Callback for reactor timer events
    zloop_timer_fn = function(loop: pzloop_t; timer_id: Longint; arg: Pointer): Longint; cdecl;

  {$IFDEF CZMQ_LINKONREQUEST}
  var
  {  Create a new zloop reactor }
    zloop_new : function: pzloop_t; cdecl;
    
  {  Destroy a reactor }
    zloop_destroy : procedure(var self: pzloop_t); cdecl;
    
  {  Register pollitem with the reactor. When the pollitem is ready, will call }
  {  the handler, passing the arg. Returns 0 if OK, -1 if there was an error. }
  {  If you register the pollitem more than once, each instance will invoke its }
  {  corresponding handler. }
    zloop_poller : function(self: pzloop_t; poolitem: Pointer; handler: zloop_fn; arg: Pointer): Longint; cdecl;
    
  {  Cancel a pollitem from the reactor, specified by socket or FD. If both }
  {  are specified, uses only socket. If multiple poll items exist for same }
  {  socket/FD, cancels ALL of them. }
    zloop_poller_end : procedure(self: pzloop_t; poolitem: Pointer); cdecl;
    
  {  Configure a registered pollitem to ignore errors. If you do not set this,  }
  {  then pollitems that have errors are removed from the reactor silently. }
    zloop_set_tolerant : procedure(self: pzloop_t; poolitem: Pointer); cdecl;
    
  {  Register a timer that expires after some delay and repeats some number of }
  {  times. At each expiry, will call the handler, passing the arg. To }
  {  run a timer forever, use 0 times. Returns a timer_id that is used to cancel }
  {  the timer in the future. Returns -1 if there was an error. }
    zloop_timer : function(self: pzloop_t; delay: NativeUInt; times: NativeUInt; handler: zloop_timer_fn;
                           arg: Pointer): Longint; cdecl;
    
  {  Cancel a specific timer identified by a specific timer_id (as returned by }
  {  zloop_timer). }
    zloop_timer_end : function(self: pzloop_t; timer_id: Longint): Longint; cdecl;
    
  {  Set verbose tracing of reactor on/off }
    zloop_set_verbose : procedure(self: pzloop_t; verbose: Longbool); cdecl;
    
  {  Start the reactor. Takes control of the thread and returns when the 0MQ }
  {  context is terminated or the process is interrupted, or any event handler }
  {  returns -1. Event handlers may register new sockets and timers, and }
  {  cancel sockets. Returns 0 if interrupted, -1 if cancelled by a handler. }
    zloop_start : function(self: pzloop_t): Longint; cdecl;
    
  {  Self test of this class }
    zloop_test : procedure(verbose: Longbool); cdecl;

  {$ELSE ~CZMQ_LINKONREQUEST}

    function zloop_new: pzloop_t; cdecl; external CZMQ_LIB;
    procedure zloop_destroy(var self: pzloop_t); cdecl; external CZMQ_LIB;
    function zloop_poller(self: pzloop_t; poolitem: Pointer; handler: zloop_fn; arg: Pointer): Longint; cdecl; external CZMQ_LIB;
    procedure zloop_poller_end(self: pzloop_t; poolitem: Pointer); cdecl; external CZMQ_LIB;
    procedure zloop_set_tolerant(self: pzloop_t; poolitem: Pointer); cdecl; external CZMQ_LIB;
    function zloop_timer(self: pzloop_t; delay: NativeUInt; times: NativeUInt; handler: zloop_timer_fn; arg: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zloop_timer_end(self: pzloop_t; timer_id: Longint): Longint; cdecl; external CZMQ_LIB;
    procedure zloop_set_verbose(self: pzloop_t; verbose: Longbool); cdecl; external CZMQ_LIB;
    function zloop_start(self: pzloop_t): Longint; cdecl; external CZMQ_LIB;
    procedure zloop_test(verbose: Longbool); cdecl; external CZMQ_LIB;

  {$ENDIF ~CZMQ_LINKONREQUEST}

{** zauth **}

  type
    pzauth_t = ^zauth_t;
    zauth_t = record // opaque struct
    end;

  const
    CURVE_ALLOW_ANY = '*';    

  {$IFDEF CZMQ_LINKONREQUEST}

  var
  {  Constructor }
  {  Install authentication for the specified context. Returns a new zauth }
  {  object that you can use to configure authentication. Note that until you }
  {  add policies, all incoming NULL connections are allowed (classic ZeroMQ }
  {  behaviour), and all PLAIN and CURVE connections are denied. If there was }
  {  an error during initialization, returns NULL. }
    zauth_new : function(ctx: pzctx_t): pzauth_t; cdecl;
    
  {  Allow (whitelist) a single IP address. For NULL, all clients from this }
  {  address will be accepted. For PLAIN and CURVE, they will be allowed to }
  {  continue with authentication. You can call this method multiple times  }
  {  to whitelist multiple IP addresses. If you whitelist a single address, }
  {  any non-whitelisted addresses are treated as blacklisted. }
    zauth_allow : procedure(self: pzauth_t; address: PAnsiChar); cdecl;
    
  {  Deny (blacklist) a single IP address. For all security mechanisms, this }
  {  rejects the connection without any further authentication. Use either a }
  {  whitelist, or a blacklist, not not both. If you define both a whitelist  }
  {  and a blacklist, only the whitelist takes effect. }
    zauth_deny : procedure(self: pzauth_t; address: PAnsiChar); cdecl;
    
  {  Configure PLAIN authentication for a given domain. PLAIN authentication }
  {  uses a plain-text password file. To cover all domains, use "*". You can }
  {  modify the password file at any time; it is reloaded automatically. }
    zauth_configure_plain : procedure(self: pzauth_t; domain: PAnsiChar; filename: PAnsiChar); cdecl;
    
  {  Configure CURVE authentication for a given domain. CURVE authentication }
  {  uses a directory that holds all public client certificates, i.e. their }
  {  public keys. The certificates must be in zcert_save () format. To cover }
  {  all domains, use "*". You can add and remove certificates in that }
  {  directory at any time. To allow all client keys without checking, specify }
  {  CURVE_ALLOW_ANY for the location. }
    zauth_configure_curve : procedure(self: pzauth_t; domain: PAnsiChar; location: PAnsiChar); cdecl;
    
  {  Enable verbose tracing of commands and activity }
    zauth_set_verbose : procedure(self: pzauth_t; verbose: Longbool); cdecl;
    
  {  Destructor }
    zauth_destroy : procedure(var self: pzauth_t); cdecl;
    
  {  Selftest }
    zauth_test : function(verbose: Longbool): Longint; cdecl;

  {$ELSE ~CZMQ_LINKONREQUEST}

    function zauth_new(ctx: pzctx_t): pzauth_t; cdecl; external CZMQ_LIB;
    procedure zauth_allow(self: pzauth_t; address: PAnsiChar); cdecl; external CZMQ_LIB;
    procedure zauth_deny(self: pzauth_t; address: PAnsiChar); cdecl; external CZMQ_LIB;
    procedure zauth_configure_plain(self: pzauth_t; domain: PAnsiChar; filename: PAnsiChar); cdecl; external CZMQ_LIB;
    procedure zauth_configure_curve(self: pzauth_t; domain: PAnsiChar; location: PAnsiChar); cdecl; external CZMQ_LIB;
    procedure zauth_set_verbose(self: pzauth_t; verbose: Longbool); cdecl; external CZMQ_LIB;
    procedure zauth_destroy(var self: pzauth_t); cdecl; external CZMQ_LIB;
    function zauth_test(verbose: Longbool): Longint; cdecl; external CZMQ_LIB;

  {$ENDIF ~CZMQ_LINKONREQUEST}


  {** zpoller **}
  type
    pzpoller_t = ^zpoller_t;
    zpoller_t = record
    end;

  {$IFDEF CZMQ_LINKONREQUEST}
  var
  {  Create new poller }
    zpoller_new : function(var reader: Pointer{, ...}): pzpoller_t; varargs; cdecl;
    
  {  Destroy a poller }
    zpoller_destroy : procedure(var self: pzpoller_t); cdecl;
    
  { Add a reader to be polled. }
    zpoller_add : function(self: pzpoller_t; reader: Pointer): Longint; cdecl;
    
  {  Poll the registered readers for I/O, return first socket that has input. }
  {  This means the order that sockets are defined in the poll list affects }
  {  their priority. If you need a balanced poll, use the low level zmq_poll }
  {  method directly. If the poll call was interrupted (SIGINT), or the ZMQ }
  {  context was destroyed, or the timeout expired, returns NULL. You can }
  {  test the actual exit condition by calling zpoller_expired () and }
  {  zpoller_terminated (). Timeout is in msec. }
    zpoller_wait : function(self: pzpoller_t; timeout: Longint): Pointer; cdecl;
    
  {  Return true if the last zpoller_wait () call ended because the timeout }
  {  expired, without any error. }
    zpoller_expired : function(self: pzpoller_t): Longbool; cdecl;
    
  {  Return true if the last zpoller_wait () call ended because the process }
  {  was interrupted, or the parent context was destroyed. }
    zpoller_terminated : function(self: pzpoller_t): Longbool; cdecl;
    
  {  Self test of this class }
    zpoller_test : function(verbose: Longbool): Longint; cdecl;

  {$ELSE ~CZMQ_LINKONREQUEST}
    function zpoller_new(var reader: Pointer{, ...}): pzpoller_t; varargs; cdecl; external CZMQ_LIB;
    procedure zpoller_destroy(var self: pzpoller_t); cdecl; external CZMQ_LIB;
    function zpoller_add(self: pzpoller_t; reader: Pointer): Longint; cdecl; external CZMQ_LIB;
    function zpoller_wait(self: pzpoller_t; timeout: Longint): Pointer; cdecl; external CZMQ_LIB;
    function zpoller_expired(self: pzpoller_t): Longbool; cdecl; external CZMQ_LIB;
    function zpoller_terminated(self: pzpoller_t): Longbool; cdecl; external CZMQ_LIB;
    function zpoller_test(verbose: Longbool): Longint; cdecl; external CZMQ_LIB;
  {$ENDIF ~CZMQ_LINKONREQUEST}

  {** zmonitor **}
  
  type
    pzmonitor_t = ^zmonitor_t;
    zmonitor_t = record // opaque struct
    end;

  {$IFDEF CZMQ_LINKONREQUEST}
  var
  {  Create a new socket monitor }
    zmonitor_new : function(ctx: pzctx_t; socket: Pointer; events: Longint): pzmonitor_t; cdecl;
    
  {  Destroy a socket monitor }
    zmonitor_destroy : procedure(var self: pzmonitor_t); cdecl;
    
  {  Receive a status message from the monitor; if no message arrives within }
  {  500 msec, or the call was interrupted, returns NULL. }
    zmonitor_recv : function(self: pzmonitor_t): pzmsg_t; cdecl;
    
  {  Get the ZeroMQ socket, for polling  }
    zmonitor_socket : function(self: pzmonitor_t): Pointer; cdecl;
    
  {  Enable verbose tracing of commands and activity }
    zmonitor_set_verbose : procedure(self: pzmonitor_t; verbose: Longbool); cdecl;
    
  { Self test of this class }
    zmonitor_test : procedure(verbose: Longbool); cdecl;

  {$ELSE ~CZMQ_LINKONREQUEST}

    function zmonitor_new(ctx: pzctx_t; socket: Pointer; events: Longint): pzmonitor_t; cdecl; external CZMQ_LIB;
    procedure zmonitor_destroy(var self: pzmonitor_t); cdecl; external CZMQ_LIB;
    function zmonitor_recv(self: pzmonitor_t): pzmsg_t; cdecl; external CZMQ_LIB;
    function zmonitor_socket(self: pzmonitor_t): Pointer; cdecl; external CZMQ_LIB;
    procedure zmonitor_set_verbose(self: pzmonitor_t; verbose: Longbool); cdecl; external CZMQ_LIB;
    procedure zmonitor_test(verbose: Longbool); cdecl; external CZMQ_LIB;

  {$ENDIF ~CZMQ_LINKONREQUEST}

  {** zbeacon **}
  type
    pzbeacon_t = ^zbeacon_t;
    zbeacon_t = record
    end;
    
  {$IFDEF CZMQ_LINKONREQUEST}
  var
  {  Create a new beacon on a certain UDP port }
    zbeacon_new : function(ctx: pzctx_t; port_nbr: Longint): pzbeacon_t; cdecl;
    
  {  Destroy a beacon }
    zbeacon_destroy : procedure(self: pzbeacon_t); cdecl;
    
  {  Return our own IP address as printable string }
    zbeacon_hostname : function(self: pzbeacon_t): PAnsiChar; cdecl;
    
  {  Set broadcast interval in milliseconds (default is 1000 msec) }
    zbeacon_set_interval : procedure(self: pzbeacon_t; interval: Longint); cdecl;
    
  {  Filter out any beacon that looks exactly like ours }
    zbeacon_noecho : procedure(self: pzbeacon_t); cdecl;
    
  {  Start broadcasting beacon to peers at the specified interval }
    zbeacon_publish : procedure(self: pzbeacon_t; transmit: PByteArray; size: NativeUInt); cdecl;
    
  {  Stop broadcasting beacons }
    zbeacon_silence : procedure(self: pzbeacon_t); cdecl;
    
  {  Start listening to other peers; zero-sized filter means get everything }
    zbeacon_subscribe : procedure(self: pzbeacon_t; var filter:byte; size: NativeUInt); cdecl;
    
  {  Stop listening to other peers }
    zbeacon_unsubscribe : procedure(self: pzbeacon_t); cdecl;
    
  {  Get beacon ZeroMQ socket, for polling or receiving messages }
    zbeacon_socket : function(self: pzbeacon_t): Pointer; cdecl;
    
  {  Self test of this class }
    zbeacon_test : procedure(verbose: Longbool); cdecl;

  {$ELSE ~CZMQ_LINKONREQUEST}
    function zbeacon_new(ctx: pzctx_t; port_nbr: Longint): pzbeacon_t; cdecl; external CZMQ_LIB;
    procedure zbeacon_destroy(self: pzbeacon_t); cdecl; external CZMQ_LIB;
    function zbeacon_hostname(self: pzbeacon_t): PAnsiChar; cdecl; external CZMQ_LIB;
    procedure zbeacon_set_interval(self: pzbeacon_t; interval: Longint); cdecl; external CZMQ_LIB;
    procedure zbeacon_noecho(self: pzbeacon_t); cdecl; external CZMQ_LIB;
    procedure zbeacon_publish(self: pzbeacon_t; transmit: PByteArray; size: NativeUInt); cdecl; external CZMQ_LIB;
    procedure zbeacon_silence(self: pzbeacon_t); cdecl; external CZMQ_LIB;
    procedure zbeacon_subscribe(self: pzbeacon_t; var filter:byte; size: NativeUInt); cdecl; external CZMQ_LIB;
    procedure zbeacon_unsubscribe(self: pzbeacon_t); cdecl; external CZMQ_LIB;
    function zbeacon_socket(self: pzbeacon_t): Pointer; cdecl; external CZMQ_LIB;
    procedure zbeacon_test(verbose: Longbool); cdecl; external CZMQ_LIB;
  {$ENDIF ~CZMQ_LINKONREQUEST}

  {** zuuid **}

  const
    ZUUID_LEN = 16;    

  type
    pzuuid_t = ^zuuid_t;
    zuuid_t = record // opaque struct
    end;

  {$IFDEF CZMQ_LINKONREQUEST}
  var
  {  Constructor }
    zuuid_new : function: pzuuid_t; cdecl;
    
  {  Destructor }
    zuuid_destroy : procedure(var self:pzuuid_t); cdecl;
    
  {  Return UUID binary data }
    zuuid_data : function(self: pzuuid_t): PByteArray; cdecl;
    
  {  Return UUID binary size }
    zuuid_size : function(self: pzuuid_t): NativeUInt; cdecl;
    
  {  Returns UUID as string }
    zuuid_str : function(self: pzuuid_t): PAnsiChar; cdecl;
    
  {  Set UUID to new supplied value  }
    zuuid_set : procedure(self: pzuuid_t; source: PByteArray); cdecl;
    
  {  Store UUID blob in target array }
    zuuid_export : procedure(self: pzuuid_t; target: PByteArray); cdecl;
    
  {  Check if UUID is same as supplied value }
    zuuid_eq : function(self: pzuuid_t; compare: PByteArray): Longbool; cdecl;
    
  {  Check if UUID is different from supplied value }
    zuuid_neq : function(self: pzuuid_t; compare: PByteArray): Longbool; cdecl;
    
  {  Make copy of UUID object }
    zuuid_dup : function(self: pzuuid_t): pzuuid_t; cdecl;
    
  {  Self test of this class }
    zuuid_test : function(verbose: Longbool): Longint; cdecl;

  {$ELSE ~CZMQ_LINKONREQUEST}
    function zuuid_new: pzuuid_t; cdecl; external CZMQ_LIB;
    procedure zuuid_destroy(var self:pzuuid_t); cdecl; external CZMQ_LIB;
    function zuuid_data(self: pzuuid_t): PByteArray; cdecl; external CZMQ_LIB;
    function zuuid_size(self: pzuuid_t): NativeUInt; cdecl; external CZMQ_LIB;
    function zuuid_str(self: pzuuid_t): PAnsiChar; cdecl; external CZMQ_LIB;
    procedure zuuid_set(self: pzuuid_t; source: PByteArray); cdecl; external CZMQ_LIB;
    procedure zuuid_export(self: pzuuid_t; target: PByteArray); cdecl; external CZMQ_LIB;
    function zuuid_eq(self: pzuuid_t; compare: PByteArray): Longbool; cdecl; external CZMQ_LIB;
    function zuuid_neq(self: pzuuid_t; compare: PByteArray): Longbool; cdecl; external CZMQ_LIB;
    function zuuid_dup(self: pzuuid_t): pzuuid_t; cdecl; external CZMQ_LIB;
    function zuuid_test(verbose: Longbool): Longint; cdecl; external CZMQ_LIB;
  {$ENDIF ~CZMQ_LINKONREQUEST}

{$IFDEF CZMQ_LINKONREQUEST}
  procedure LoadLib(lib : PAnsiChar);
  procedure FreeLib;
{$ENDIF}

implementation

{$IFDEF FPC}
{$IFDEF CZMQ_LINKONREQUEST}
  uses dynlibs;
{$ENDIF CZMQ_LINKONREQUEST}
{$ELSE ~FPC}
  uses Windows;
{$ENDIF ~FPC}

{$IFDEF CZMQ_LINKONREQUEST}
  var
    _hlib : TLibHandle;

  procedure FreeLib;
    begin
      FreeLibrary(_hlib);

      zctx_new:=nil;
      zctx_destroy:=nil;
      zctx_shadow:=nil;
      zctx_shadow_zmq_ctx:=nil;
      zctx_set_iothreads:=nil;
      zctx_set_linger:=nil;
      zctx_set_pipehwm:=nil;
      zctx_set_sndhwm:=nil;
      zctx_set_rcvhwm:=nil;
      zctx_underlying:=nil;
      zctx_test:=nil;
      zctx_interrupted:=nil;

      zsocket_new:=nil;
      zsocket_destroy:=nil;
      zsocket_bind:=nil;
      zsocket_bind:=nil;
      zsocket_unbind:=nil;
      zsocket_unbind:=nil;
      zsocket_connect:=nil;
      zsocket_connect:=nil;
      zsocket_disconnect:=nil;
      zsocket_disconnect:=nil;
      zsocket_poll:=nil;
      zsocket_type_str:=nil;
      zsocket_sendmem:=nil;
      zsocket_signal:=nil;
      zsocket_wait:=nil;
      zsocket_test:=nil;

      zmsg_new:=nil;
      zmsg_destroy:=nil;
      zmsg_recv:=nil;
      zmsg_recv_nowait:=nil;
      zmsg_send:=nil;
      zmsg_size:=nil;
      zmsg_content_size:=nil;
      zmsg_prepend:=nil;
      zmsg_append:=nil;
      zmsg_pop:=nil;
      zmsg_pushmem:=nil;
      zmsg_addmem:=nil;
      zmsg_pushstr:=nil;
      zmsg_addstr:=nil;
      zmsg_pushstrf:=nil;
      zmsg_pushstrf:=nil;
      zmsg_addstrf:=nil;
      zmsg_addstrf:=nil;
      zmsg_popstr:=nil;
      zmsg_unwrap:=nil;
      zmsg_remove:=nil;
      zmsg_first:=nil;
      zmsg_next:=nil;
      zmsg_last:=nil;
      zmsg_save:=nil;
      zmsg_load:=nil;
      zmsg_encode:=nil;
      zmsg_decode:=nil;
      zmsg_dup:=nil;
      zmsg_fprint:=nil;
      zmsg_print:=nil;
      zmsg_test:=nil;

      zframe_new:=nil;
      zframe_new_empty:=nil;
      zframe_destroy:=nil;
      zframe_recv:=nil;
      zframe_recv_nowait:=nil;
      zframe_send:=nil;
      zframe_size:=nil;
      zframe_data:=nil;
      zframe_dup:=nil;
      zframe_strhex:=nil;
      zframe_strdup:=nil;
      zframe_streq:=nil;
      zframe_more:=nil;
      zframe_set_more:=nil;
      zframe_eq:=nil;
      zframe_fprint:=nil;
      zframe_print:=nil;
      zframe_reset:=nil;
      zframe_put_block:=nil;
      zframe_test:=nil;

      zauth_new:=nil;
      zauth_allow:=nil;
      zauth_deny:=nil;
      zauth_configure_plain:=nil;
      zauth_configure_curve:=nil;
      zauth_set_verbose:=nil;
      zauth_destroy:=nil;
      zauth_test:=nil;

      zpoller_new:=nil;
      zpoller_new:=nil;
      zpoller_destroy:=nil;
      zpoller_add:=nil;
      zpoller_wait:=nil;
      zpoller_expired:=nil;
      zpoller_terminated:=nil;
      zpoller_test:=nil;

      zloop_new:=nil;
      zloop_destroy:=nil;
      zloop_poller:=nil;
      zloop_poller_end:=nil;
      zloop_set_tolerant:=nil;
      zloop_timer:=nil;
      zloop_timer_end:=nil;
      zloop_set_verbose:=nil;
      zloop_start:=nil;
      zloop_test:=nil;

      zmonitor_new:=nil;
      zmonitor_destroy:=nil;
      zmonitor_recv:=nil;
      zmonitor_socket:=nil;
      zmonitor_set_verbose:=nil;
      zmonitor_test:=nil;
      
      zsocket_tos:=nil;
      zsocket_plain_server:=nil;
      zsocket_plain_username:=nil;
      zsocket_plain_password:=nil;
      zsocket_curve_server:=nil;
      zsocket_curve_publickey:=nil;
      zsocket_curve_secretkey:=nil;
      zsocket_curve_serverkey:=nil;
      zsocket_zap_domain:=nil;
      zsocket_mechanism:=nil;
      zsocket_ipv6:=nil;
      zsocket_immediate:=nil;
      zsocket_ipv4only:=nil;
      zsocket_type:=nil;
      zsocket_sndhwm:=nil;
      zsocket_rcvhwm:=nil;
      zsocket_affinity:=nil;
      zsocket_identity:=nil;
      zsocket_rate:=nil;
      zsocket_recovery_ivl:=nil;
      zsocket_sndbuf:=nil;
      zsocket_rcvbuf:=nil;
      zsocket_linger:=nil;
      zsocket_reconnect_ivl:=nil;
      zsocket_reconnect_ivl_max:=nil;
      zsocket_backlog:=nil;
      zsocket_maxmsgsize:=nil;
      zsocket_multicast_hops:=nil;
      zsocket_rcvtimeo:=nil;
      zsocket_sndtimeo:=nil;
      zsocket_tcp_keepalive:=nil;
      zsocket_tcp_keepalive_idle:=nil;
      zsocket_tcp_keepalive_cnt:=nil;
      zsocket_tcp_keepalive_intvl:=nil;
      zsocket_tcp_accept_filter:=nil;
      zsocket_rcvmore:=nil;
      zsocket_fd:=nil;
      zsocket_events:=nil;
      zsocket_last_endpoint:=nil;
      zsocket_set_tos:=nil;
      zsocket_set_router_handover:=nil;
      zsocket_set_router_mandatory:=nil;
      zsocket_set_probe_router:=nil;
      zsocket_set_req_relaxed:=nil;
      zsocket_set_req_correlate:=nil;
      zsocket_set_conflate:=nil;
      zsocket_set_plain_server:=nil;
      zsocket_set_plain_username:=nil;
      zsocket_set_plain_password:=nil;
      zsocket_set_curve_server:=nil;
      zsocket_set_curve_publickey:=nil;
      zsocket_set_curve_publickey_bin:=nil;
      zsocket_set_curve_secretkey:=nil;
      zsocket_set_curve_secretkey_bin:=nil;
      zsocket_set_curve_serverkey:=nil;
      zsocket_set_curve_serverkey_bin:=nil;
      zsocket_set_zap_domain:=nil;
      zsocket_set_ipv6:=nil;
      zsocket_set_immediate:=nil;
      zsocket_set_router_raw:=nil;
      zsocket_set_ipv4only:=nil;
      zsocket_set_delay_attach_on_connect:=nil;
      zsocket_set_sndhwm:=nil;
      zsocket_set_rcvhwm:=nil;
      zsocket_set_affinity:=nil;
      zsocket_set_subscribe:=nil;
      zsocket_set_unsubscribe:=nil;
      zsocket_set_identity:=nil;
      zsocket_set_rate:=nil;
      zsocket_set_recovery_ivl:=nil;
      zsocket_set_sndbuf:=nil;
      zsocket_set_rcvbuf:=nil;
      zsocket_set_linger:=nil;
      zsocket_set_reconnect_ivl:=nil;
      zsocket_set_reconnect_ivl_max:=nil;
      zsocket_set_backlog:=nil;
      zsocket_set_maxmsgsize:=nil;
      zsocket_set_multicast_hops:=nil;
      zsocket_set_rcvtimeo:=nil;
      zsocket_set_sndtimeo:=nil;
      zsocket_set_xpub_verbose:=nil;
      zsocket_set_tcp_keepalive:=nil;
      zsocket_set_tcp_keepalive_idle:=nil;
      zsocket_set_tcp_keepalive_cnt:=nil;
      zsocket_set_tcp_keepalive_intvl:=nil;
      zsocket_set_tcp_accept_filter:=nil;
      zsocket_set_hwm:=nil;
      zsockopt_test:=nil;

      zbeacon_new:=nil;
      zbeacon_destroy:=nil;
      zbeacon_hostname:=nil;
      zbeacon_set_interval:=nil;
      zbeacon_noecho:=nil;
      zbeacon_publish:=nil;
      zbeacon_silence:=nil;
      zbeacon_subscribe:=nil;
      zbeacon_unsubscribe:=nil;
      zbeacon_socket:=nil;
      zbeacon_test:=nil;
      
      zuuid_new:=nil;
      zuuid_destroy:=nil;
      zuuid_data:=nil;
      zuuid_size:=nil;
      zuuid_str:=nil;
      zuuid_set:=nil;
      zuuid_export:=nil;
      zuuid_eq:=nil;
      zuuid_neq:=nil;
      zuuid_dup:=nil;
      zuuid_test:=nil;
    end;


  procedure LoadLib(lib : PAnsiChar);
    begin
      //Freezsocket;
      _hlib := LoadLibrary(lib);
      if _hlib = 0 then
        raise Exception.Create(Format('Could not load library: %s',[lib]));

      Pointer(zctx_new) := GetProcAddress(_hlib, 'zctx_new');
      Pointer(zctx_destroy) := GetProcAddress(_hlib, 'zctx_destroy');
      Pointer(zctx_shadow) := GetProcAddress(_hlib, 'zctx_shadow');
      Pointer(zctx_shadow_zmq_ctx) := GetProcAddress(_hlib, 'zctx_shadow_zmq_ctx');
      Pointer(zctx_set_iothreads) := GetProcAddress(_hlib, 'zctx_set_iothreads');
      Pointer(zctx_set_linger) := GetProcAddress(_hlib, 'zctx_set_linger');
      Pointer(zctx_set_pipehwm) := GetProcAddress(_hlib, 'zctx_set_pipehwm');
      Pointer(zctx_set_sndhwm) := GetProcAddress(_hlib, 'zctx_set_sndhwm');
      Pointer(zctx_set_rcvhwm) := GetProcAddress(_hlib, 'zctx_set_rcvhwm');
      Pointer(zctx_underlying) := GetProcAddress(_hlib, 'zctx_underlying');
      Pointer(zctx_test) := GetProcAddress(_hlib, 'zctx_test');
      Pointer(zctx_interrupted) := GetProcAddress(_hlib, 'zctx_interrupted');

      Pointer(zsocket_new) := GetProcAddress(_hlib, 'zsocket_new');
      Pointer(zsocket_destroy) := GetProcAddress(_hlib, 'zsocket_destroy');
      Pointer(zsocket_bind) := GetProcAddress(_hlib, 'zsocket_bind');
      Pointer(zsocket_bind) := GetProcAddress(_hlib, 'zsocket_bind');
      Pointer(zsocket_unbind) := GetProcAddress(_hlib, 'zsocket_unbind');
      Pointer(zsocket_unbind) := GetProcAddress(_hlib, 'zsocket_unbind');
      Pointer(zsocket_connect) := GetProcAddress(_hlib, 'zsocket_connect');
      Pointer(zsocket_connect) := GetProcAddress(_hlib, 'zsocket_connect');
      Pointer(zsocket_disconnect) := GetProcAddress(_hlib, 'zsocket_disconnect');
      Pointer(zsocket_disconnect) := GetProcAddress(_hlib, 'zsocket_disconnect');
      Pointer(zsocket_poll) := GetProcAddress(_hlib, 'zsocket_poll');
      Pointer(zsocket_type_str) := GetProcAddress(_hlib, 'zsocket_type_str');
      Pointer(zsocket_sendmem) := GetProcAddress(_hlib, 'zsocket_sendmem');
      Pointer(zsocket_signal) := GetProcAddress(_hlib, 'zsocket_signal');
      Pointer(zsocket_wait) := GetProcAddress(_hlib, 'zsocket_wait');
      Pointer(zsocket_test) := GetProcAddress(_hlib, 'zsocket_test');

      Pointer(zmsg_new) := GetProcAddress(_hlib, 'zmsg_new');
      Pointer(zmsg_destroy) := GetProcAddress(_hlib, 'zmsg_destroy');
      Pointer(zmsg_recv) := GetProcAddress(_hlib, 'zmsg_recv');
      Pointer(zmsg_recv_nowait) := GetProcAddress(_hlib, 'zmsg_recv_nowait');
      Pointer(zmsg_send) := GetProcAddress(_hlib, 'zmsg_send');
      Pointer(zmsg_size) := GetProcAddress(_hlib, 'zmsg_size');
      Pointer(zmsg_content_size) := GetProcAddress(_hlib, 'zmsg_content_size');
      Pointer(zmsg_prepend) := GetProcAddress(_hlib, 'zmsg_prepend');
      Pointer(zmsg_append) := GetProcAddress(_hlib, 'zmsg_append');
      Pointer(zmsg_pop) := GetProcAddress(_hlib, 'zmsg_pop');
      Pointer(zmsg_pushmem) := GetProcAddress(_hlib, 'zmsg_pushmem');
      Pointer(zmsg_addmem) := GetProcAddress(_hlib, 'zmsg_addmem');
      Pointer(zmsg_pushstr) := GetProcAddress(_hlib, 'zmsg_pushstr');
      Pointer(zmsg_addstr) := GetProcAddress(_hlib, 'zmsg_addstr');
      Pointer(zmsg_pushstrf) := GetProcAddress(_hlib, 'zmsg_pushstrf');
      Pointer(zmsg_pushstrf) := GetProcAddress(_hlib, 'zmsg_pushstrf');
      Pointer(zmsg_addstrf) := GetProcAddress(_hlib, 'zmsg_addstrf');
      Pointer(zmsg_addstrf) := GetProcAddress(_hlib, 'zmsg_addstrf');
      Pointer(zmsg_popstr) := GetProcAddress(_hlib, 'zmsg_popstr');
      Pointer(zmsg_unwrap) := GetProcAddress(_hlib, 'zmsg_unwrap');
      Pointer(zmsg_remove) := GetProcAddress(_hlib, 'zmsg_remove');
      Pointer(zmsg_first) := GetProcAddress(_hlib, 'zmsg_first');
      Pointer(zmsg_next) := GetProcAddress(_hlib, 'zmsg_next');
      Pointer(zmsg_last) := GetProcAddress(_hlib, 'zmsg_last');
      Pointer(zmsg_save) := GetProcAddress(_hlib, 'zmsg_save');
      Pointer(zmsg_load) := GetProcAddress(_hlib, 'zmsg_load');
      Pointer(zmsg_encode) := GetProcAddress(_hlib, 'zmsg_encode');
      Pointer(zmsg_decode) := GetProcAddress(_hlib, 'zmsg_decode');
      Pointer(zmsg_dup) := GetProcAddress(_hlib, 'zmsg_dup');
      Pointer(zmsg_fprint) := GetProcAddress(_hlib, 'zmsg_fprint');
      Pointer(zmsg_print) := GetProcAddress(_hlib, 'zmsg_print');
      Pointer(zmsg_test) := GetProcAddress(_hlib, 'zmsg_test');

      Pointer(zframe_new) := GetProcAddress(_hlib, 'zframe_new');
      Pointer(zframe_new_empty) := GetProcAddress(_hlib, 'zframe_new_empty');
      Pointer(zframe_destroy) := GetProcAddress(_hlib, 'zframe_destroy');
      Pointer(zframe_recv) := GetProcAddress(_hlib, 'zframe_recv');
      Pointer(zframe_recv_nowait) := GetProcAddress(_hlib, 'zframe_recv_nowait');
      Pointer(zframe_send) := GetProcAddress(_hlib, 'zframe_send');
      Pointer(zframe_size) := GetProcAddress(_hlib, 'zframe_size');
      Pointer(zframe_data) := GetProcAddress(_hlib, 'zframe_data');
      Pointer(zframe_dup) := GetProcAddress(_hlib, 'zframe_dup');
      Pointer(zframe_strhex) := GetProcAddress(_hlib, 'zframe_strhex');
      Pointer(zframe_strdup) := GetProcAddress(_hlib, 'zframe_strdup');
      Pointer(zframe_streq) := GetProcAddress(_hlib, 'zframe_streq');
      Pointer(zframe_more) := GetProcAddress(_hlib, 'zframe_more');
      Pointer(zframe_set_more) := GetProcAddress(_hlib, 'zframe_set_more');
      Pointer(zframe_eq) := GetProcAddress(_hlib, 'zframe_eq');
      Pointer(zframe_fprint) := GetProcAddress(_hlib, 'zframe_fprint');
      Pointer(zframe_print) := GetProcAddress(_hlib, 'zframe_print');
      Pointer(zframe_reset) := GetProcAddress(_hlib, 'zframe_reset');
      Pointer(zframe_put_block) := GetProcAddress(_hlib, 'zframe_put_block');
      Pointer(zframe_test) := GetProcAddress(_hlib, 'zframe_test');

      Pointer(zauth_new) := GetProcAddress(_hlib, 'zauth_new');
      Pointer(zauth_allow) := GetProcAddress(_hlib, 'zauth_allow');
      Pointer(zauth_deny) := GetProcAddress(_hlib, 'zauth_deny');
      Pointer(zauth_configure_plain) := GetProcAddress(_hlib, 'zauth_configure_plain');
      Pointer(zauth_configure_curve) := GetProcAddress(_hlib, 'zauth_configure_curve');
      Pointer(zauth_set_verbose) := GetProcAddress(_hlib, 'zauth_set_verbose');
      Pointer(zauth_destroy) := GetProcAddress(_hlib, 'zauth_destroy');
      Pointer(zauth_test) := GetProcAddress(_hlib, 'zauth_test');

      Pointer(zpoller_new) := GetProcAddress(_hlib, 'zpoller_new');
      Pointer(zpoller_new) := GetProcAddress(_hlib, 'zpoller_new');
      Pointer(zpoller_destroy) := GetProcAddress(_hlib, 'zpoller_destroy');
      Pointer(zpoller_add) := GetProcAddress(_hlib, 'zpoller_add');
      Pointer(zpoller_wait) := GetProcAddress(_hlib, 'zpoller_wait');
      Pointer(zpoller_expired) := GetProcAddress(_hlib, 'zpoller_expired');
      Pointer(zpoller_terminated) := GetProcAddress(_hlib, 'zpoller_terminated');
      Pointer(zpoller_test) := GetProcAddress(_hlib, 'zpoller_test');

      Pointer(zloop_new) := GetProcAddress(_hlib, 'zloop_new');
      Pointer(zloop_destroy) := GetProcAddress(_hlib, 'zloop_destroy');
      Pointer(zloop_poller) := GetProcAddress(_hlib, 'zloop_poller');
      Pointer(zloop_poller_end) := GetProcAddress(_hlib, 'zloop_poller_end');
      Pointer(zloop_set_tolerant) := GetProcAddress(_hlib, 'zloop_set_tolerant');
      Pointer(zloop_timer) := GetProcAddress(_hlib, 'zloop_timer');
      Pointer(zloop_timer_end) := GetProcAddress(_hlib, 'zloop_timer_end');
      Pointer(zloop_set_verbose) := GetProcAddress(_hlib, 'zloop_set_verbose');
      Pointer(zloop_start) := GetProcAddress(_hlib, 'zloop_start');
      Pointer(zloop_test) := GetProcAddress(_hlib, 'zloop_test');

      Pointer(zmonitor_new) := GetProcAddress(_hlib, 'zmonitor_new');
      Pointer(zmonitor_destroy) := GetProcAddress(_hlib, 'zmonitor_destroy');
      Pointer(zmonitor_recv) := GetProcAddress(_hlib, 'zmonitor_recv');
      Pointer(zmonitor_socket) := GetProcAddress(_hlib, 'zmonitor_socket');
      Pointer(zmonitor_set_verbose) := GetProcAddress(_hlib, 'zmonitor_set_verbose');
      Pointer(zmonitor_test) := GetProcAddress(_hlib, 'zmonitor_test');
      
      Pointer(zsocket_tos) := GetProcAddress(_hlib, 'zsocket_tos');
      Pointer(zsocket_plain_server) := GetProcAddress(_hlib, 'zsocket_plain_server');
      Pointer(zsocket_plain_username) := GetProcAddress(_hlib, 'zsocket_plain_username');
      Pointer(zsocket_plain_password) := GetProcAddress(_hlib, 'zsocket_plain_password');
      Pointer(zsocket_curve_server) := GetProcAddress(_hlib, 'zsocket_curve_server');
      Pointer(zsocket_curve_publickey) := GetProcAddress(_hlib, 'zsocket_curve_publickey');
      Pointer(zsocket_curve_secretkey) := GetProcAddress(_hlib, 'zsocket_curve_secretkey');
      Pointer(zsocket_curve_serverkey) := GetProcAddress(_hlib, 'zsocket_curve_serverkey');
      Pointer(zsocket_zap_domain) := GetProcAddress(_hlib, 'zsocket_zap_domain');
      Pointer(zsocket_mechanism) := GetProcAddress(_hlib, 'zsocket_mechanism');
      Pointer(zsocket_ipv6) := GetProcAddress(_hlib, 'zsocket_ipv6');
      Pointer(zsocket_immediate) := GetProcAddress(_hlib, 'zsocket_immediate');
      Pointer(zsocket_ipv4only) := GetProcAddress(_hlib, 'zsocket_ipv4only');
      Pointer(zsocket_type) := GetProcAddress(_hlib, 'zsocket_type');
      Pointer(zsocket_sndhwm) := GetProcAddress(_hlib, 'zsocket_sndhwm');
      Pointer(zsocket_rcvhwm) := GetProcAddress(_hlib, 'zsocket_rcvhwm');
      Pointer(zsocket_affinity) := GetProcAddress(_hlib, 'zsocket_affinity');
      Pointer(zsocket_identity) := GetProcAddress(_hlib, 'zsocket_identity');
      Pointer(zsocket_rate) := GetProcAddress(_hlib, 'zsocket_rate');
      Pointer(zsocket_recovery_ivl) := GetProcAddress(_hlib, 'zsocket_recovery_ivl');
      Pointer(zsocket_sndbuf) := GetProcAddress(_hlib, 'zsocket_sndbuf');
      Pointer(zsocket_rcvbuf) := GetProcAddress(_hlib, 'zsocket_rcvbuf');
      Pointer(zsocket_linger) := GetProcAddress(_hlib, 'zsocket_linger');
      Pointer(zsocket_reconnect_ivl) := GetProcAddress(_hlib, 'zsocket_reconnect_ivl');
      Pointer(zsocket_reconnect_ivl_max) := GetProcAddress(_hlib, 'zsocket_reconnect_ivl_max');
      Pointer(zsocket_backlog) := GetProcAddress(_hlib, 'zsocket_backlog');
      Pointer(zsocket_maxmsgsize) := GetProcAddress(_hlib, 'zsocket_maxmsgsize');
      Pointer(zsocket_multicast_hops) := GetProcAddress(_hlib, 'zsocket_multicast_hops');
      Pointer(zsocket_rcvtimeo) := GetProcAddress(_hlib, 'zsocket_rcvtimeo');
      Pointer(zsocket_sndtimeo) := GetProcAddress(_hlib, 'zsocket_sndtimeo');
      Pointer(zsocket_tcp_keepalive) := GetProcAddress(_hlib, 'zsocket_tcp_keepalive');
      Pointer(zsocket_tcp_keepalive_idle) := GetProcAddress(_hlib, 'zsocket_tcp_keepalive_idle');
      Pointer(zsocket_tcp_keepalive_cnt) := GetProcAddress(_hlib, 'zsocket_tcp_keepalive_cnt');
      Pointer(zsocket_tcp_keepalive_intvl) := GetProcAddress(_hlib, 'zsocket_tcp_keepalive_intvl');
      Pointer(zsocket_tcp_accept_filter) := GetProcAddress(_hlib, 'zsocket_tcp_accept_filter');
      Pointer(zsocket_rcvmore) := GetProcAddress(_hlib, 'zsocket_rcvmore');
      Pointer(zsocket_fd) := GetProcAddress(_hlib, 'zsocket_fd');
      Pointer(zsocket_events) := GetProcAddress(_hlib, 'zsocket_events');
      Pointer(zsocket_last_endpoint) := GetProcAddress(_hlib, 'zsocket_last_endpoint');
      Pointer(zsocket_set_tos) := GetProcAddress(_hlib, 'zsocket_set_tos');
      Pointer(zsocket_set_router_handover) := GetProcAddress(_hlib, 'zsocket_set_router_handover');
      Pointer(zsocket_set_router_mandatory) := GetProcAddress(_hlib, 'zsocket_set_router_mandatory');
      Pointer(zsocket_set_probe_router) := GetProcAddress(_hlib, 'zsocket_set_probe_router');
      Pointer(zsocket_set_req_relaxed) := GetProcAddress(_hlib, 'zsocket_set_req_relaxed');
      Pointer(zsocket_set_req_correlate) := GetProcAddress(_hlib, 'zsocket_set_req_correlate');
      Pointer(zsocket_set_conflate) := GetProcAddress(_hlib, 'zsocket_set_conflate');
      Pointer(zsocket_set_plain_server) := GetProcAddress(_hlib, 'zsocket_set_plain_server');
      Pointer(zsocket_set_plain_username) := GetProcAddress(_hlib, 'zsocket_set_plain_username');
      Pointer(zsocket_set_plain_password) := GetProcAddress(_hlib, 'zsocket_set_plain_password');
      Pointer(zsocket_set_curve_server) := GetProcAddress(_hlib, 'zsocket_set_curve_server');
      Pointer(zsocket_set_curve_publickey) := GetProcAddress(_hlib, 'zsocket_set_curve_publickey');
      Pointer(zsocket_set_curve_publickey_bin) := GetProcAddress(_hlib, 'zsocket_set_curve_publickey_bin');
      Pointer(zsocket_set_curve_secretkey) := GetProcAddress(_hlib, 'zsocket_set_curve_secretkey');
      Pointer(zsocket_set_curve_secretkey_bin) := GetProcAddress(_hlib, 'zsocket_set_curve_secretkey_bin');
      Pointer(zsocket_set_curve_serverkey) := GetProcAddress(_hlib, 'zsocket_set_curve_serverkey');
      Pointer(zsocket_set_curve_serverkey_bin) := GetProcAddress(_hlib, 'zsocket_set_curve_serverkey_bin');
      Pointer(zsocket_set_zap_domain) := GetProcAddress(_hlib, 'zsocket_set_zap_domain');
      Pointer(zsocket_set_ipv6) := GetProcAddress(_hlib, 'zsocket_set_ipv6');
      Pointer(zsocket_set_immediate) := GetProcAddress(_hlib, 'zsocket_set_immediate');
      Pointer(zsocket_set_router_raw) := GetProcAddress(_hlib, 'zsocket_set_router_raw');
      Pointer(zsocket_set_ipv4only) := GetProcAddress(_hlib, 'zsocket_set_ipv4only');
      Pointer(zsocket_set_delay_attach_on_connect) := GetProcAddress(_hlib, 'zsocket_set_delay_attach_on_connect');
      Pointer(zsocket_set_sndhwm) := GetProcAddress(_hlib, 'zsocket_set_sndhwm');
      Pointer(zsocket_set_rcvhwm) := GetProcAddress(_hlib, 'zsocket_set_rcvhwm');
      Pointer(zsocket_set_affinity) := GetProcAddress(_hlib, 'zsocket_set_affinity');
      Pointer(zsocket_set_subscribe) := GetProcAddress(_hlib, 'zsocket_set_subscribe');
      Pointer(zsocket_set_unsubscribe) := GetProcAddress(_hlib, 'zsocket_set_unsubscribe');
      Pointer(zsocket_set_identity) := GetProcAddress(_hlib, 'zsocket_set_identity');
      Pointer(zsocket_set_rate) := GetProcAddress(_hlib, 'zsocket_set_rate');
      Pointer(zsocket_set_recovery_ivl) := GetProcAddress(_hlib, 'zsocket_set_recovery_ivl');
      Pointer(zsocket_set_sndbuf) := GetProcAddress(_hlib, 'zsocket_set_sndbuf');
      Pointer(zsocket_set_rcvbuf) := GetProcAddress(_hlib, 'zsocket_set_rcvbuf');
      Pointer(zsocket_set_linger) := GetProcAddress(_hlib, 'zsocket_set_linger');
      Pointer(zsocket_set_reconnect_ivl) := GetProcAddress(_hlib, 'zsocket_set_reconnect_ivl');
      Pointer(zsocket_set_reconnect_ivl_max) := GetProcAddress(_hlib, 'zsocket_set_reconnect_ivl_max');
      Pointer(zsocket_set_backlog) := GetProcAddress(_hlib, 'zsocket_set_backlog');
      Pointer(zsocket_set_maxmsgsize) := GetProcAddress(_hlib, 'zsocket_set_maxmsgsize');
      Pointer(zsocket_set_multicast_hops) := GetProcAddress(_hlib, 'zsocket_set_multicast_hops');
      Pointer(zsocket_set_rcvtimeo) := GetProcAddress(_hlib, 'zsocket_set_rcvtimeo');
      Pointer(zsocket_set_sndtimeo) := GetProcAddress(_hlib, 'zsocket_set_sndtimeo');
      Pointer(zsocket_set_xpub_verbose) := GetProcAddress(_hlib, 'zsocket_set_xpub_verbose');
      Pointer(zsocket_set_tcp_keepalive) := GetProcAddress(_hlib, 'zsocket_set_tcp_keepalive');
      Pointer(zsocket_set_tcp_keepalive_idle) := GetProcAddress(_hlib, 'zsocket_set_tcp_keepalive_idle');
      Pointer(zsocket_set_tcp_keepalive_cnt) := GetProcAddress(_hlib, 'zsocket_set_tcp_keepalive_cnt');
      Pointer(zsocket_set_tcp_keepalive_intvl) := GetProcAddress(_hlib, 'zsocket_set_tcp_keepalive_intvl');
      Pointer(zsocket_set_tcp_accept_filter) := GetProcAddress(_hlib, 'zsocket_set_tcp_accept_filter');
      Pointer(zsocket_set_hwm) := GetProcAddress(_hlib, 'zsocket_set_hwm');
      Pointer(zsockopt_test) := GetProcAddress(_hlib, 'zsockopt_test');

      Pointer(zbeacon_new) := GetProcAddress(_hlib, 'zbeacon_new');
      Pointer(zbeacon_destroy) := GetProcAddress(_hlib, 'zbeacon_destroy');
      Pointer(zbeacon_hostname) := GetProcAddress(_hlib, 'zbeacon_hostname');
      Pointer(zbeacon_set_interval) := GetProcAddress(_hlib, 'zbeacon_set_interval');
      Pointer(zbeacon_noecho) := GetProcAddress(_hlib, 'zbeacon_noecho');
      Pointer(zbeacon_publish) := GetProcAddress(_hlib, 'zbeacon_publish');
      Pointer(zbeacon_silence) := GetProcAddress(_hlib, 'zbeacon_silence');
      Pointer(zbeacon_subscribe) := GetProcAddress(_hlib, 'zbeacon_subscribe');
      Pointer(zbeacon_unsubscribe) := GetProcAddress(_hlib, 'zbeacon_unsubscribe');
      Pointer(zbeacon_socket) := GetProcAddress(_hlib, 'zbeacon_socket');
      Pointer(zbeacon_test) := GetProcAddress(_hlib, 'zbeacon_test');

      Pointer(zuuid_new) := GetProcAddress(_hlib, 'zuuid_new');
      Pointer(zuuid_destroy) := GetProcAddress(_hlib, 'zuuid_destroy');
      Pointer(zuuid_data) := GetProcAddress(_hlib, 'zuuid_data');
      Pointer(zuuid_size) := GetProcAddress(_hlib, 'zuuid_size');
      Pointer(zuuid_str) := GetProcAddress(_hlib, 'zuuid_str');
      Pointer(zuuid_set) := GetProcAddress(_hlib, 'zuuid_set');
      Pointer(zuuid_export) := GetProcAddress(_hlib, 'zuuid_export');
      Pointer(zuuid_eq) := GetProcAddress(_hlib, 'zuuid_eq');
      Pointer(zuuid_neq) := GetProcAddress(_hlib, 'zuuid_neq');
      Pointer(zuuid_dup) := GetProcAddress(_hlib, 'zuuid_dup');
      Pointer(zuuid_test) := GetProcAddress(_hlib, 'zuuid_test');
    end;

  {$ENDIF CZMQ_LINKONREQUEST}


end.
