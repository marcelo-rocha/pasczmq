{  =========================================================================
    czmq.pas - CZMQ API Pascal Binding

    Copyright (c) 2014 Marcelo Campos Rocha

    This file is derived from headers of czmq library
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
unit czmq;

interface

  { Pointers to basic pascal types, inserted by h2pas conversion program.}
  Type
    PLongint  = ^Longint;
    PSmallInt = ^SmallInt;
    PByte     = ^Byte;
    PWord     = ^Word;
    PDWord    = ^DWord;
    PDouble   = ^Double;

{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}


  {  This port range is defined by IANA for dynamic or private ports }
  {  We use this when choosing a port for dynamic binding. }

  const
    ZSOCKET_DYNFROM = $c000;    
    ZSOCKET_DYNTO = $ffff;   

    ZFRAME_MORE = 1;    
    ZFRAME_REUSE = 2;    
    ZFRAME_DONTWAIT = 4;    


  {  Callback function for zero-copy methods }


  type
    pzcx_t = ^zctx_t;
    zctx_t = record
    end;
    
    
    
    

  var
  {** zctx **}

  {  Create new context, returns context object, replaces zmq_init }
    zctx_new : function: pzctx_t; cdecl;

  {  Destroy context and all sockets in it, replaces zmq_term }
    zctx_destroy : procedure(var self_p: pzctx_t); cdecl;

  {  Create new shadow context, returns context object }
    zctx_shadow : function(self: pzctx_t): pzctx_t; cdecl;

  {  Create a new context by shadowing a plain zmq context }
    zctx_shadow_zmq_ctx : function(zmqctx: Pointer): pzctx_t; cdecl;

  {  Raise default I/O threads from 1, for crazy heavy applications }
  {  The rule of thumb is one I/O thread per gigabyte of traffic in }
  {  or out. Call this method before creating any sockets on the context, }
  {  or calling zctx_shadow, or the setting will have no effect. }
    zctx_set_iothreads : procedure(self: pzctx_t; iothreads: Longint); cdecl;

  {  Set msecs to flush sockets when closing them, see the ZMQ_LINGER }
  {  man page section for more details. By default, set to zero, so }
  {  any in-transit messages are discarded when you destroy a socket or }
  {  a context. }
    zctx_set_linger : procedure(self: pzctx_t; linger: Longint); cdecl;

  {  Set initial high-water mark for inter-thread pipe sockets. Note that }
  {  this setting is separate from the default for normal sockets. You  }
  {  should change the default for pipe sockets *with care*. Too low values }
  {  will cause blocked threads, and an infinite setting can cause memory }
  {  exhaustion. The default, no matter the underlying ZeroMQ version, is }
  {  1,000. }
    zctx_set_pipehwm : procedure(self: pzctx_t; pipehwm: Longint); cdecl;

  {  Set initial send HWM for all new normal sockets created in context. }
  {  You can set this per-socket after the socket is created. }
  {  The default, no matter the underlying ZeroMQ version, is 1,000. }
    zctx_set_sndhwm : procedure(self: pzctx_t; sndhwm: Longint); cdecl;
    
  {  Set initial receive HWM for all new normal sockets created in context. }
  {  You can set this per-socket after the socket is created. }
  {  The default, no matter the underlying ZeroMQ version, is 1,000. }
    zctx_set_rcvhwm : procedure(self: pzctx_t; rcvhwm: Longint); cdecl;
    
  {  Return low-level 0MQ context object, will be NULL before first socket }
  {  is created. Use with care. }
    zctx_underlying : function(self: pzctx_t): Pointer; cdecl;
    
  {  Self test of this class }
    zctx_test : function(verbose:bool): Longint; cdecl;
    
  {  Global signal indicator, TRUE when user presses Ctrl-C or the process }
  {  gets a SIGTERM signal. }
  { extern volatile int zctx_interrupted; }

  {** zsocket **}

  {  Create a new socket within our CZMQ context, replaces zmq_socket. }
  {  Use this to get automatic management of the socket at shutdown. }
  {  Note: SUB sockets do not automatically subscribe to everything; you }
  {  must set filters explicitly. }
    zsocket_new : function(self: pzctx_t; atype: Longint): Pointer; cdecl;
    
  {  Destroy a socket within our CZMQ context, replaces zmq_close. }
    zsocket_destroy : procedure(self: pzctx_t; socket:pointer); cdecl;
    
  {  Bind a socket to a formatted endpoint. If the port is specified as }
  {  '*', binds to any free port from ZSOCKET_DYNFROM to ZSOCKET_DYNTO }
  {  and returns the actual port number used. Otherwise asserts that the }
  {  bind succeeded with the specified port number. Always returns the }
  {  port number if successful. }
    zsocket_bind : function(socket: Pointer; format: PAnsiChar): Longint; cdecl; varargs; 

  {  Unbind a socket from a formatted endpoint. }
  {  Returns 0 if OK, -1 if the endpoint was invalid or the function }
  {  isn't supported. }
    zsocket_unbind : function(socket: Pointer; format: PAnsiChar): Longint; cdecl; varargs;
    
  {  Connect a socket to a formatted endpoint }
  {  Returns 0 if OK, -1 if the endpoint was invalid. }
    zsocket_connect : function(socket:pointer; format: PAnsiChar): Longint; cdecl; varargs;
    
  {  Disonnect a socket from a formatted endpoint }
  {  Returns 0 if OK, -1 if the endpoint was invalid or the function }
  {  isn't supported. }
    zsocket_disconnect : function(socket:pointer; format: PAnsiChar): Longint; cdecl; varargs;
    
  {  Poll for input events on the socket. Returns TRUE if there is input }
  {  ready on the socket, else FALSE. }
    zsocket_poll : function(socket:pointer; msecs: Longint): bool; cdecl; varargs;
    
  {  Returns socket type as printable constant string }
    zsocket_type_str : function(socket:pointer): PAnsiChar; cdecl;
    
  {  Send data over a socket as a single message frame. }
  {  Accepts these flags: ZFRAME_MORE and ZFRAME_DONTWAIT. }
    zsocket_sendmem : function(socket:pointer; const data; size: Longint; flags: Longint): Longint; cdecl;
    
    
  {  Send a signal over a socket. A signal is a zero-byte message. }
  {  Signals are used primarily between threads, over pipe sockets. }
  {  Returns -1 if there was an error sending the signal. }
    zsocket_signal : function(socket:pointer): Longint; cdecl;
    
  {  Wait on a signal. Use this to coordinate between threads, over }
  {  pipe pairs. Returns -1 on error, 0 on success. }
    zsocket_wait : function(socket:pointer): Longint; cdecl;
    
  {  Send data over a socket as a single message frame. }
  {  Returns -1 on error, 0 on success }
    zsocket_sendmem : function(socket:pointer; const data; size: Longint; flags: Longint): Longint; cdecl;
    
  {  Self test of this class }
    zsocket_test : function(verbose: bool): Longint; cdecl;

    zsocket_tos : function(var zocket:pointer): Longint; cdecl;
    zsocket_plain_server : function(var zocket:pointer): Longint; cdecl;
    zsocket_plain_username : function(var zocket:pointer):PAnsiChar; cdecl;
    zsocket_plain_password : function(var zocket:pointer):PAnsiChar; cdecl;
    zsocket_curve_server : function(var zocket:pointer): Longint; cdecl;
    zsocket_curve_publickey : function(var zocket:pointer):PAnsiChar; cdecl;
    zsocket_curve_secretkey : function(var zocket:pointer):PAnsiChar; cdecl;
    zsocket_curve_serverkey : function(var zocket:pointer):PAnsiChar; cdecl;
    zsocket_zap_domain : function(var zocket:pointer):PAnsiChar; cdecl;
    zsocket_mechanism : function(var zocket:pointer): Longint; cdecl;
    zsocket_ipv6 : function(var zocket:pointer): Longint; cdecl;
    zsocket_immediate : function(var zocket:pointer): Longint; cdecl;
    zsocket_ipv4only : function(var zocket:pointer): Longint; cdecl;
    zsocket_type : function(var zocket:pointer): Longint; cdecl;
    zsocket_sndhwm : function(var zocket:pointer): Longint; cdecl;
    zsocket_rcvhwm : function(var zocket:pointer): Longint; cdecl;
    zsocket_affinity : function(var zocket:pointer): Longint; cdecl;
    zsocket_identity : function(var zocket:pointer):PAnsiChar; cdecl;
    zsocket_rate : function(var zocket:pointer): Longint; cdecl;
    zsocket_recovery_ivl : function(var zocket:pointer): Longint; cdecl;
    zsocket_sndbuf : function(var zocket:pointer): Longint; cdecl;
    zsocket_rcvbuf : function(var zocket:pointer): Longint; cdecl;
    zsocket_linger : function(var zocket:pointer): Longint; cdecl;
    zsocket_reconnect_ivl : function(var zocket:pointer): Longint; cdecl;
    zsocket_reconnect_ivl_max : function(var zocket:pointer): Longint; cdecl;
    zsocket_backlog : function(var zocket:pointer): Longint; cdecl;
    zsocket_maxmsgsize : function(var zocket:pointer): Longint; cdecl;
    zsocket_multicast_hops : function(var zocket:pointer): Longint; cdecl;
    zsocket_rcvtimeo : function(var zocket:pointer): Longint; cdecl;
    zsocket_sndtimeo : function(var zocket:pointer): Longint; cdecl;
    zsocket_tcp_keepalive : function(var zocket:pointer): Longint; cdecl;
    zsocket_tcp_keepalive_idle : function(var zocket:pointer): Longint; cdecl;
    zsocket_tcp_keepalive_cnt : function(var zocket:pointer): Longint; cdecl;
    zsocket_tcp_keepalive_intvl : function(var zocket:pointer): Longint; cdecl;
    zsocket_tcp_accept_filter : function(var zocket:pointer):PAnsiChar; cdecl;
    zsocket_rcvmore : function(var zocket:pointer): Longint; cdecl;
    zsocket_fd : function(var zocket:pointer): Longint; cdecl;
    zsocket_events : function(var zocket:pointer): Longint; cdecl;
    zsocket_last_endpoint : function(var zocket:pointer):PAnsiChar; cdecl;
  {  Set socket options }
    zsocket_set_tos : procedure(var zocket:pointer; tos: Longint); cdecl;
    zsocket_set_router_handover : procedure(var zocket:pointer; router_handover: Longint); cdecl;
    zsocket_set_router_mandatory : procedure(var zocket:pointer; router_mandatory: Longint); cdecl;
    zsocket_set_probe_router : procedure(var zocket:pointer; probe_router: Longint); cdecl;
    zsocket_set_req_relaxed : procedure(var zocket:pointer; req_relaxed: Longint); cdecl;
    zsocket_set_req_correlate : procedure(var zocket:pointer; req_correlate: Longint); cdecl;
    zsocket_set_conflate : procedure(var zocket:pointer; conflate: Longint); cdecl;
    zsocket_set_plain_server : procedure(var zocket:pointer; plain_server: Longint); cdecl;
(* Const before type ignored *)
    zsocket_set_plain_username : procedure(var zocket:pointer; plain_username:PAnsiChar); cdecl;
(* Const before type ignored *)
    zsocket_set_plain_password : procedure(var zocket:pointer; plain_password:PAnsiChar); cdecl;
    zsocket_set_curve_server : procedure(var zocket:pointer; curve_server: Longint); cdecl;
(* Const before type ignored *)
    zsocket_set_curve_publickey : procedure(var zocket:pointer; curve_publickey:PAnsiChar); cdecl;
(* Const before type ignored *)
    zsocket_set_curve_publickey_bin : procedure(var zocket:pointer; var curve_publickey:byte); cdecl;
(* Const before type ignored *)
    zsocket_set_curve_secretkey : procedure(var zocket:pointer; curve_secretkey:PAnsiChar); cdecl;
(* Const before type ignored *)
    zsocket_set_curve_secretkey_bin : procedure(var zocket:pointer; var curve_secretkey:byte); cdecl;
(* Const before type ignored *)
    zsocket_set_curve_serverkey : procedure(var zocket:pointer; curve_serverkey:PAnsiChar); cdecl;
(* Const before type ignored *)
    zsocket_set_curve_serverkey_bin : procedure(var zocket:pointer; var curve_serverkey:byte); cdecl;
(* Const before type ignored *)
    zsocket_set_zap_domain : procedure(var zocket:pointer; zap_domain:PAnsiChar); cdecl;
    zsocket_set_ipv6 : procedure(var zocket:pointer; ipv6: Longint); cdecl;
    zsocket_set_immediate : procedure(var zocket:pointer; immediate: Longint); cdecl;
    zsocket_set_router_raw : procedure(var zocket:pointer; router_raw: Longint); cdecl;
    zsocket_set_ipv4only : procedure(var zocket:pointer; ipv4only: Longint); cdecl;
    zsocket_set_delay_attach_on_connect : procedure(var zocket:pointer; delay_attach_on_connect: Longint); cdecl;
    zsocket_set_sndhwm : procedure(var zocket:pointer; sndhwm: Longint); cdecl;
    zsocket_set_rcvhwm : procedure(var zocket:pointer; rcvhwm: Longint); cdecl;
    zsocket_set_affinity : procedure(var zocket:pointer; affinity: Longint); cdecl;
(* Const before type ignored *)
    zsocket_set_subscribe : procedure(var zocket:pointer; subscribe:PAnsiChar); cdecl;
(* Const before type ignored *)
    zsocket_set_unsubscribe : procedure(var zocket:pointer; unsubscribe:PAnsiChar); cdecl;
(* Const before type ignored *)
    zsocket_set_identity : procedure(var zocket:pointer; identity:PAnsiChar); cdecl;
    zsocket_set_rate : procedure(var zocket:pointer; rate: Longint); cdecl;
    zsocket_set_recovery_ivl : procedure(var zocket:pointer; recovery_ivl: Longint); cdecl;
    zsocket_set_sndbuf : procedure(var zocket:pointer; sndbuf: Longint); cdecl;
    zsocket_set_rcvbuf : procedure(var zocket:pointer; rcvbuf: Longint); cdecl;
    zsocket_set_linger : procedure(var zocket:pointer; linger: Longint); cdecl;
    zsocket_set_reconnect_ivl : procedure(var zocket:pointer; reconnect_ivl: Longint); cdecl;
    zsocket_set_reconnect_ivl_max : procedure(var zocket:pointer; reconnect_ivl_max: Longint); cdecl;
    zsocket_set_backlog : procedure(var zocket:pointer; backlog: Longint); cdecl;
    zsocket_set_maxmsgsize : procedure(var zocket:pointer; maxmsgsize: Longint); cdecl;
    zsocket_set_multicast_hops : procedure(var zocket:pointer; multicast_hops: Longint); cdecl;
    zsocket_set_rcvtimeo : procedure(var zocket:pointer; rcvtimeo: Longint); cdecl;
    zsocket_set_sndtimeo : procedure(var zocket:pointer; sndtimeo: Longint); cdecl;
    zsocket_set_xpub_verbose : procedure(var zocket:pointer; xpub_verbose: Longint); cdecl;
    zsocket_set_tcp_keepalive : procedure(var zocket:pointer; tcp_keepalive: Longint); cdecl;
    zsocket_set_tcp_keepalive_idle : procedure(var zocket:pointer; tcp_keepalive_idle: Longint); cdecl;
    zsocket_set_tcp_keepalive_cnt : procedure(var zocket:pointer; tcp_keepalive_cnt: Longint); cdecl;
    zsocket_set_tcp_keepalive_intvl : procedure(var zocket:pointer; tcp_keepalive_intvl: Longint); cdecl;
(* Const before type ignored *)
    zsocket_set_tcp_accept_filter : procedure(var zocket:pointer; tcp_accept_filter:PAnsiChar); cdecl;
  {  Emulation of widely-used 2.x socket options }
    zsocket_set_hwm : procedure(var zocket:pointer; hwm: Longint); cdecl;
  {  Self test of this class }
    zsockopt_test : function(verbose:bool): Longint; cdecl;

  {  Create a new empty message object }
    zmsg_new : function:Pzmsg_t; cdecl;
  {  Destroy a message object and all frames it contains }
    zmsg_destroy : procedure(var self_p:Pzmsg_t); cdecl;
  {  Receive message from socket, returns zmsg_t object or NULL if the recv }
  {  was interrupted. Does a blocking recv, if you want to not block then use }
  {  the zloop class or zmsg_recv_nowait() or zmq_poll to check for socket input before receiving. }
    zmsg_recv : function(var socket:pointer):Pzmsg_t; cdecl;
  {  Receive message from socket, returns zmsg_t object, or NULL either if there was }
  {  no input waiting, or the recv was interrupted. }
    zmsg_recv_nowait : function(var socket:pointer):Pzmsg_t; cdecl;
  {  Send message to socket, destroy after sending. If the message has no }
  {  frames, sends nothing but destroys the message anyhow. Safe to call }
  {  if zmsg is null. }
    zmsg_send : function(var self_p:Pzmsg_t; var socket:pointer): Longint; cdecl;
  {  Return size of message, i.e. number of frames (0 or more). }
    zmsg_size : function(var self:zmsg_t):size_t; cdecl;
  {  Return total size of all frames in message. }
    zmsg_content_size : function(var self:zmsg_t):size_t; cdecl;
  {  Push frame to the front of the message, i.e. before all other frames. }
  {  Message takes ownership of frame, will destroy it when message is sent. }
  {  Returns 0 on success, -1 on error. Deprecates zmsg_push, which did not }
  {  nullify the caller's frame reference. }
    zmsg_prepend : function(var self:zmsg_t; var frame_p:Pzframe_t): Longint; cdecl;
  {  Add frame to the end of the message, i.e. after all other frames. }
  {  Message takes ownership of frame, will destroy it when message is sent. }
  {  Returns 0 on success. Deprecates zmsg_add, which did not nullify the }
  {  caller's frame reference. }
    zmsg_append : function(var self:zmsg_t; var frame_p:Pzframe_t): Longint; cdecl;
  {  Remove first frame from message, if any. Returns frame, or NULL. Caller }
  {  now owns frame and must destroy it when finished with it. }
    zmsg_pop : function(var self:zmsg_t):Pzframe_t; cdecl;
  {  Push block of memory to front of message, as a new frame. }
  {  Returns 0 on success, -1 on error. }
    zmsg_pushmem : function(var self:zmsg_t; var src:pointer; size:size_t): Longint; cdecl;
  {  Add block of memory to the end of the message, as a new frame. }
  {  Returns 0 on success, -1 on error. }
    zmsg_addmem : function(var self:zmsg_t; var src:pointer; size:size_t): Longint; cdecl;
  {  Push string as new frame to front of message. }
  {  Returns 0 on success, -1 on error. }
    zmsg_pushstr : function(var self:zmsg_t; _string:PAnsiChar): Longint; cdecl;
  {  Push string as new frame to end of message. }
  {  Returns 0 on success, -1 on error. }
    zmsg_addstr : function(var self:zmsg_t; _string:PAnsiChar): Longint; cdecl;
  {  Push formatted string as new frame to front of message. }
  {  Returns 0 on success, -1 on error. }
    zmsg_pushstrf : function(var self:zmsg_t; format:PAnsiChar; args:array of const): Longint; cdecl;
    zmsg_pushstrf : function(var self:zmsg_t; format:PAnsiChar): Longint; cdecl;
  {  Push formatted string as new frame to end of message. }
  {  Returns 0 on success, -1 on error. }
    zmsg_addstrf : function(var self:zmsg_t; format:PAnsiChar; args:array of const): Longint; cdecl;
    zmsg_addstrf : function(var self:zmsg_t; format:PAnsiChar): Longint; cdecl;
  {  Pop frame off front of message, return as fresh string. If there were }
  {  no more frames in the message, returns NULL. }
    zmsg_popstr : function(var self:zmsg_t):PAnsiChar; cdecl;
  {  Pop frame off front of message, caller now owns frame }
  {  If next frame is empty, pops and destroys that empty frame. }
    zmsg_unwrap : function(var self:zmsg_t):Pzframe_t; cdecl;
  {  Remove specified frame from list, if present. Does not destroy frame. }
    zmsg_remove : procedure(var self:zmsg_t; var frame:zframe_t); cdecl;
  {  Set cursor to first frame in message. Returns frame, or NULL, if the  }
  {  message is empty. Use this to navigate the frames as a list. }
    zmsg_first : function(var self:zmsg_t):Pzframe_t; cdecl;
  {  Return the next frame. If there are no more frames, returns NULL. To move }
  {  to the first frame call zmsg_first(). Advances the cursor. }
    zmsg_next : function(var self:zmsg_t):Pzframe_t; cdecl;
  {  Return the last frame. If there are no frames, returns NULL. }
    zmsg_last : function(var self:zmsg_t):Pzframe_t; cdecl;
  {  Save message to an open file, return 0 if OK, else -1. The message is  }
  {  saved as a series of frames, each with length and data. Note that the }
  {  file is NOT guaranteed to be portable between operating systems, not }
  {  versions of CZMQ. The file format is at present undocumented and liable }
  {  to arbitrary change. }
    zmsg_save : function(var self:zmsg_t; var file:FILE): Longint; cdecl;
  {  Load/append an open file into message, create new message if }
  {  null message provided. Returns NULL if the message could not  }
  {  be loaded. }
    zmsg_load : function(var self:zmsg_t; var file:FILE):Pzmsg_t; cdecl;
  {  Serialize multipart message to a single buffer. Use this method to send }
  {  structured messages across transports that do not support multipart data. }
  {  Allocates and returns a new buffer containing the serialized message. }
  {  To decode a serialized message buffer, use zmsg_decode (). }
    zmsg_encode : function(var self:zmsg_t; var buffer:Pbyte):size_t; cdecl;
  {  Decodes a serialized message buffer created by zmsg_encode () and returns }
  {  a new zmsg_t object. Returns NULL if the buffer was badly formatted or  }
  {  there was insufficient memory to work. }
    zmsg_decode : function(var buffer:byte; buffer_size:size_t):Pzmsg_t; cdecl;
  {  Create copy of message, as new message object. Returns a fresh zmsg_t }
  {  object, or NULL if there was not enough heap memory. }
    zmsg_dup : function(var self:zmsg_t):Pzmsg_t; cdecl;
  {  Print message to open stream }
  {  Truncates to first 10 frames, for readability. }
    zmsg_fprint : procedure(var self:zmsg_t; var file:FILE); cdecl;
  {  Print message to stdout }
    zmsg_print : procedure(var self:zmsg_t); cdecl;
  {  Self test of this class }
    zmsg_test : function(verbose:bool): Longint; cdecl;
  {  Push frame plus empty frame to front of message, before first frame. }
  {  Message takes ownership of frame, will destroy it when message is sent. }
  {  DEPRECATED as unsafe -- does not nullify frame reference. }
    zmsg_wrap : procedure(var self:zmsg_t; var frame:zframe_t); cdecl;
  {  DEPRECATED - will be removed for next + 1 stable release }
  {  Add frame to the front of the message, i.e. before all other frames. }
  {  Message takes ownership of frame, will destroy it when message is sent. }
  {  Returns 0 on success, -1 on error. }
    zmsg_push : function(var self:zmsg_t; var frame:zframe_t): Longint; cdecl;
  {  DEPRECATED - will be removed for next stable release }
    zmsg_add : function(var self:zmsg_t; var frame:zframe_t): Longint; cdecl;

  {  Create a new frame with optional size, and optional data }
    zframe_new : function(var data:pointer; size:size_t):Pzframe_t; cdecl;
  {  Create an empty (zero-sized) frame }
    zframe_new_empty : function:Pzframe_t; cdecl;
  {  Destroy a frame }
    zframe_destroy : procedure(var self_p:Pzframe_t); cdecl;
  {  Receive frame from socket, returns zframe_t object or NULL if the recv }
  {  was interrupted. Does a blocking recv, if you want to not block then use }
  {  zframe_recv_nowait(). }
    zframe_recv : function(var socket:pointer):Pzframe_t; cdecl;
  {  Receive a new frame off the socket. Returns newly allocated frame, or }
  {  NULL if there was no input waiting, or if the read was interrupted. }
    zframe_recv_nowait : function(var socket:pointer):Pzframe_t; cdecl;
  { Send a frame to a socket, destroy frame after sending. }
  { Return -1 on error, 0 on success. }
    zframe_send : function(var self_p:Pzframe_t; var socket:pointer; flags: Longint): Longint; cdecl;
  {  Return number of bytes in frame data }
    zframe_size : function(var self:zframe_t):size_t; cdecl;
  {  Return address of frame data }
    zframe_data : function(var self:zframe_t):Pbyte; cdecl;
  {  Create a new frame that duplicates an existing frame }
    zframe_dup : function(var self:zframe_t):Pzframe_t; cdecl;
  {  Return frame data encoded as printable hex string }
    zframe_strhex : function(var self:zframe_t):PAnsiChar; cdecl;
  {  Return frame data copied into freshly allocated string }
    zframe_strdup : function(var self:zframe_t):PAnsiChar; cdecl;
  {  Return TRUE if frame body is equal to string, excluding terminator }
    zframe_streq : function(var self:zframe_t; _string:PAnsiChar):bool; cdecl;
  {  Return frame MORE indicator (1 or 0), set when reading frame from socket }
  {  or by the zframe_set_more() method }
    zframe_more : function(var self:zframe_t): Longint; cdecl;
  {  Set frame MORE indicator (1 or 0). Note this is NOT used when sending  }
  {  frame to socket, you have to specify flag explicitly. }
    zframe_set_more : procedure(var self:zframe_t; more: Longint); cdecl;
  {  Return TRUE if two frames have identical size and data }
  {  If either frame is NULL, equality is always false. }
    zframe_eq : function(var self:zframe_t; var other:zframe_t):bool; cdecl;
  {   Print contents of the frame to FILE stream. }
    zframe_fprint : procedure(var self:zframe_t; prefix:PAnsiChar; var file:FILE); cdecl;
  {  Print contents of frame to stderr }
    zframe_print : procedure(var self:zframe_t; prefix:PAnsiChar); cdecl;
  {  Set new contents for frame }
    zframe_reset : procedure(var self:zframe_t; var data:pointer; size:size_t); cdecl;
  {  Put a block of data to the frame payload. }
    zframe_put_block : function(var self:zframe_t; var data:byte; size:size_t): Longint; cdecl;
  {  Self test of this class }
    zframe_test : function(verbose:bool): Longint; cdecl;


  var
  {  Create a new zloop reactor }
    zloop_new : function:Pzloop_t; cdecl;
  {  Destroy a reactor }
    zloop_destroy : procedure(var self_p:Pzloop_t); cdecl;
  {  Register pollitem with the reactor. When the pollitem is ready, will call }
  {  the handler, passing the arg. Returns 0 if OK, -1 if there was an error. }
  {  If you register the pollitem more than once, each instance will invoke its }
  {  corresponding handler. }
    zloop_poller : function(var self:zloop_t; var item:zmq_pollitem_t; handler:zloop_fn; var arg:pointer): Longint; cdecl;
  {  Cancel a pollitem from the reactor, specified by socket or FD. If both }
  {  are specified, uses only socket. If multiple poll items exist for same }
  {  socket/FD, cancels ALL of them. }
    zloop_poller_end : procedure(var self:zloop_t; var item:zmq_pollitem_t); cdecl;
  {  Configure a registered pollitem to ignore errors. If you do not set this,  }
  {  then pollitems that have errors are removed from the reactor silently. }
    zloop_set_tolerant : procedure(var self:zloop_t; var item:zmq_pollitem_t); cdecl;
  {  Register a timer that expires after some delay and repeats some number of }
  {  times. At each expiry, will call the handler, passing the arg. To }
  {  run a timer forever, use 0 times. Returns a timer_id that is used to cancel }
  {  the timer in the future. Returns -1 if there was an error. }
    zloop_timer : function(var self:zloop_t; delay:size_t; times:size_t; handler:zloop_timer_fn; var arg:pointer): Longint; cdecl;
  {  Cancel a specific timer identified by a specific timer_id (as returned by }
  {  zloop_timer). }
    zloop_timer_end : function(var self:zloop_t; timer_id: Longint): Longint; cdecl;
  {  Set verbose tracing of reactor on/off }
    zloop_set_verbose : procedure(var self:zloop_t; verbose:bool); cdecl;
  {  Start the reactor. Takes control of the thread and returns when the 0MQ }
  {  context is terminated or the process is interrupted, or any event handler }
  {  returns -1. Event handlers may register new sockets and timers, and }
  {  cancel sockets. Returns 0 if interrupted, -1 if cancelled by a handler. }
    zloop_start : function(var self:zloop_t): Longint; cdecl;
  {  Self test of this class }
    zloop_test : procedure(verbose:bool); cdecl;


  const
    CURVE_ALLOW_ANY = '*';    

  var
  {  Constructor }
  {  Install authentication for the specified context. Returns a new zauth }
  {  object that you can use to configure authentication. Note that until you }
  {  add policies, all incoming NULL connections are allowed (classic ZeroMQ }
  {  behaviour), and all PLAIN and CURVE connections are denied. If there was }
  {  an error during initialization, returns NULL. }
    zauth_new : function(var ctx:zctx_t):Pzauth_t; cdecl;
  {  Allow (whitelist) a single IP address. For NULL, all clients from this }
  {  address will be accepted. For PLAIN and CURVE, they will be allowed to }
  {  continue with authentication. You can call this method multiple times  }
  {  to whitelist multiple IP addresses. If you whitelist a single address, }
  {  any non-whitelisted addresses are treated as blacklisted. }
    zauth_allow : procedure(var self:zauth_t; address:PAnsiChar); cdecl;
  {  Deny (blacklist) a single IP address. For all security mechanisms, this }
  {  rejects the connection without any further authentication. Use either a }
  {  whitelist, or a blacklist, not not both. If you define both a whitelist  }
  {  and a blacklist, only the whitelist takes effect. }
    zauth_deny : procedure(var self:zauth_t; address:PAnsiChar); cdecl;
  {  Configure PLAIN authentication for a given domain. PLAIN authentication }
  {  uses a plain-text password file. To cover all domains, use "*". You can }
  {  modify the password file at any time; it is reloaded automatically. }
    zauth_configure_plain : procedure(var self:zauth_t; domain:PAnsiChar; filename:PAnsiChar); cdecl;
  {  Configure CURVE authentication for a given domain. CURVE authentication }
  {  uses a directory that holds all public client certificates, i.e. their }
  {  public keys. The certificates must be in zcert_save () format. To cover }
  {  all domains, use "*". You can add and remove certificates in that }
  {  directory at any time. To allow all client keys without checking, specify }
  {  CURVE_ALLOW_ANY for the location. }
    zauth_configure_curve : procedure(var self:zauth_t; domain:PAnsiChar; location:PAnsiChar); cdecl;
  {  Enable verbose tracing of commands and activity }
    zauth_set_verbose : procedure(var self:zauth_t; verbose:bool); cdecl;
  {  Destructor }
    zauth_destroy : procedure(var self_p:Pzauth_t); cdecl;
  {  Selftest }
    zauth_test : function(verbose:bool): Longint; cdecl;

  {  Create new poller }
    zpoller_new : function(var reader:pointer; args:array of const):Pzpoller_t; cdecl;
    zpoller_new : function(var reader:pointer):Pzpoller_t; cdecl;
  {  Destroy a poller }
    zpoller_destroy : procedure(var self_p:Pzpoller_t); cdecl;
  { Add a reader to be polled. }
    zpoller_add : function(var self:zpoller_t; var reader:pointer): Longint; cdecl;
  {  Poll the registered readers for I/O, return first socket that has input. }
  {  This means the order that sockets are defined in the poll list affects }
  {  their priority. If you need a balanced poll, use the low level zmq_poll }
  {  method directly. If the poll call was interrupted (SIGINT), or the ZMQ }
  {  context was destroyed, or the timeout expired, returns NULL. You can }
  {  test the actual exit condition by calling zpoller_expired () and }
  {  zpoller_terminated (). Timeout is in msec. }
    zpoller_wait : function(var self:zpoller_t; timeout: Longint):pointer; cdecl;
  {  Return true if the last zpoller_wait () call ended because the timeout }
  {  expired, without any error. }
    zpoller_expired : function(var self:zpoller_t):bool; cdecl;
  {  Return true if the last zpoller_wait () call ended because the process }
  {  was interrupted, or the parent context was destroyed. }
    zpoller_terminated : function(var self:zpoller_t):bool; cdecl;
  {  Self test of this class }
    zpoller_test : function(verbose:bool): Longint; cdecl;

  {  Create a new socket monitor }
    zmonitor_new : function(var ctx:zctx_t; var socket:pointer; events: Longint):Pzmonitor_t; cdecl;
  {  Destroy a socket monitor }
    zmonitor_destroy : procedure(var self_p:Pzmonitor_t); cdecl;
  {  Receive a status message from the monitor; if no message arrives within }
  {  500 msec, or the call was interrupted, returns NULL. }
    zmonitor_recv : function(var self:zmonitor_t):Pzmsg_t; cdecl;
  {  Get the ZeroMQ socket, for polling  }
    zmonitor_socket : function(var self:zmonitor_t):pointer; cdecl;
  {  Enable verbose tracing of commands and activity }
    zmonitor_set_verbose : procedure(var self:zmonitor_t; verbose:bool); cdecl;
  { Self test of this class }
    zmonitor_test : procedure(verbose:bool); cdecl;

  {  Create a new beacon on a certain UDP port }
    zbeacon_new : function(var ctx:zctx_t; port_nbr: Longint):Pzbeacon_t; cdecl;
  {  Destroy a beacon }
    zbeacon_destroy : procedure(var self_p:Pzbeacon_t); cdecl;
  {  Return our own IP address as printable string }
    zbeacon_hostname : function(var self:zbeacon_t):PAnsiChar; cdecl;
  {  Set broadcast interval in milliseconds (default is 1000 msec) }
    zbeacon_set_interval : procedure(var self:zbeacon_t; interval: Longint); cdecl;
  {  Filter out any beacon that looks exactly like ours }
    zbeacon_noecho : procedure(var self:zbeacon_t); cdecl;
  {  Start broadcasting beacon to peers at the specified interval }
    zbeacon_publish : procedure(var self:zbeacon_t; var transmit:byte; size:size_t); cdecl;
  {  Stop broadcasting beacons }
    zbeacon_silence : procedure(var self:zbeacon_t); cdecl;
  {  Start listening to other peers; zero-sized filter means get everything }
    zbeacon_subscribe : procedure(var self:zbeacon_t; var filter:byte; size:size_t); cdecl;
  {  Stop listening to other peers }
    zbeacon_unsubscribe : procedure(var self:zbeacon_t); cdecl;
  {  Get beacon ZeroMQ socket, for polling or receiving messages }
    zbeacon_socket : function(var self:zbeacon_t):pointer; cdecl;
  {  Self test of this class }
    zbeacon_test : procedure(verbose:bool); cdecl;

  const
    ZUUID_LEN = 16;    

  type
    _zuuid_t = zuuid_t;

  var
  {  Constructor }
    zuuid_new : function:Pzuuid_t; cdecl;
  {  Destructor }
    zuuid_destroy : procedure(var self_p:Pzuuid_t); cdecl;
  {  Return UUID binary data }
    zuuid_data : function(var self:zuuid_t):Pbyte; cdecl;
  {  Return UUID binary size }
    zuuid_size : function(var self:zuuid_t):size_t; cdecl;
  {  Returns UUID as string }
    zuuid_str : function(var self:zuuid_t):PAnsiChar; cdecl;
  {  Set UUID to new supplied value  }
    zuuid_set : procedure(var self:zuuid_t; var source:byte); cdecl;
  {  Store UUID blob in target array }
    zuuid_export : procedure(var self:zuuid_t; var target:byte); cdecl;
  {  Check if UUID is same as supplied value }
    zuuid_eq : function(var self:zuuid_t; var compare:byte):bool; cdecl;
  {  Check if UUID is different from supplied value }
    zuuid_neq : function(var self:zuuid_t; var compare:byte):bool; cdecl;
  {  Make copy of UUID object }
    zuuid_dup : function(var self:zuuid_t):Pzuuid_t; cdecl;
  {  Self test of this class }
    zuuid_test : function(verbose:bool): Longint; cdecl;


implementation

  uses
    SysUtils
    {IFDEF FPC}, dynlibs{$ELSE}, Windows{$ENDIF};

  var
    hlib : tlibhandle;


  procedure FreeLib;
    begin
      FreeLibrary(hlib);

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
      zsocket_sendmem:=nil;
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
      zmsg_wrap:=nil;
      zmsg_push:=nil;
      zmsg_add:=nil;

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


  procedure LoadLib(lib : pchar);
    begin
      Freezsocket;
      hlib:=LoadLibrary(lib);
      if hlib=0 then
        raise Exception.Create(format('Could not load library: %s',[lib]));

      pointer(zctx_new):=GetProcAddress(hlib,'zctx_new');
      pointer(zctx_destroy):=GetProcAddress(hlib,'zctx_destroy');
      pointer(zctx_shadow):=GetProcAddress(hlib,'zctx_shadow');
      pointer(zctx_shadow_zmq_ctx):=GetProcAddress(hlib,'zctx_shadow_zmq_ctx');
      pointer(zctx_set_iothreads):=GetProcAddress(hlib,'zctx_set_iothreads');
      pointer(zctx_set_linger):=GetProcAddress(hlib,'zctx_set_linger');
      pointer(zctx_set_pipehwm):=GetProcAddress(hlib,'zctx_set_pipehwm');
      pointer(zctx_set_sndhwm):=GetProcAddress(hlib,'zctx_set_sndhwm');
      pointer(zctx_set_rcvhwm):=GetProcAddress(hlib,'zctx_set_rcvhwm');
      pointer(zctx_underlying):=GetProcAddress(hlib,'zctx_underlying');
      pointer(zctx_test):=GetProcAddress(hlib,'zctx_test');

      pointer(zsocket_new):=GetProcAddress(hlib,'zsocket_new');
      pointer(zsocket_destroy):=GetProcAddress(hlib,'zsocket_destroy');
      pointer(zsocket_bind):=GetProcAddress(hlib,'zsocket_bind');
      pointer(zsocket_bind):=GetProcAddress(hlib,'zsocket_bind');
      pointer(zsocket_unbind):=GetProcAddress(hlib,'zsocket_unbind');
      pointer(zsocket_unbind):=GetProcAddress(hlib,'zsocket_unbind');
      pointer(zsocket_connect):=GetProcAddress(hlib,'zsocket_connect');
      pointer(zsocket_connect):=GetProcAddress(hlib,'zsocket_connect');
      pointer(zsocket_disconnect):=GetProcAddress(hlib,'zsocket_disconnect');
      pointer(zsocket_disconnect):=GetProcAddress(hlib,'zsocket_disconnect');
      pointer(zsocket_poll):=GetProcAddress(hlib,'zsocket_poll');
      pointer(zsocket_type_str):=GetProcAddress(hlib,'zsocket_type_str');
      pointer(zsocket_sendmem):=GetProcAddress(hlib,'zsocket_sendmem');
      pointer(zsocket_signal):=GetProcAddress(hlib,'zsocket_signal');
      pointer(zsocket_wait):=GetProcAddress(hlib,'zsocket_wait');
      pointer(zsocket_sendmem):=GetProcAddress(hlib,'zsocket_sendmem');
      pointer(zsocket_test):=GetProcAddress(hlib,'zsocket_test');

      pointer(zmsg_new):=GetProcAddress(hlib,'zmsg_new');
      pointer(zmsg_destroy):=GetProcAddress(hlib,'zmsg_destroy');
      pointer(zmsg_recv):=GetProcAddress(hlib,'zmsg_recv');
      pointer(zmsg_recv_nowait):=GetProcAddress(hlib,'zmsg_recv_nowait');
      pointer(zmsg_send):=GetProcAddress(hlib,'zmsg_send');
      pointer(zmsg_size):=GetProcAddress(hlib,'zmsg_size');
      pointer(zmsg_content_size):=GetProcAddress(hlib,'zmsg_content_size');
      pointer(zmsg_prepend):=GetProcAddress(hlib,'zmsg_prepend');
      pointer(zmsg_append):=GetProcAddress(hlib,'zmsg_append');
      pointer(zmsg_pop):=GetProcAddress(hlib,'zmsg_pop');
      pointer(zmsg_pushmem):=GetProcAddress(hlib,'zmsg_pushmem');
      pointer(zmsg_addmem):=GetProcAddress(hlib,'zmsg_addmem');
      pointer(zmsg_pushstr):=GetProcAddress(hlib,'zmsg_pushstr');
      pointer(zmsg_addstr):=GetProcAddress(hlib,'zmsg_addstr');
      pointer(zmsg_pushstrf):=GetProcAddress(hlib,'zmsg_pushstrf');
      pointer(zmsg_pushstrf):=GetProcAddress(hlib,'zmsg_pushstrf');
      pointer(zmsg_addstrf):=GetProcAddress(hlib,'zmsg_addstrf');
      pointer(zmsg_addstrf):=GetProcAddress(hlib,'zmsg_addstrf');
      pointer(zmsg_popstr):=GetProcAddress(hlib,'zmsg_popstr');
      pointer(zmsg_unwrap):=GetProcAddress(hlib,'zmsg_unwrap');
      pointer(zmsg_remove):=GetProcAddress(hlib,'zmsg_remove');
      pointer(zmsg_first):=GetProcAddress(hlib,'zmsg_first');
      pointer(zmsg_next):=GetProcAddress(hlib,'zmsg_next');
      pointer(zmsg_last):=GetProcAddress(hlib,'zmsg_last');
      pointer(zmsg_save):=GetProcAddress(hlib,'zmsg_save');
      pointer(zmsg_load):=GetProcAddress(hlib,'zmsg_load');
      pointer(zmsg_encode):=GetProcAddress(hlib,'zmsg_encode');
      pointer(zmsg_decode):=GetProcAddress(hlib,'zmsg_decode');
      pointer(zmsg_dup):=GetProcAddress(hlib,'zmsg_dup');
      pointer(zmsg_fprint):=GetProcAddress(hlib,'zmsg_fprint');
      pointer(zmsg_print):=GetProcAddress(hlib,'zmsg_print');
      pointer(zmsg_test):=GetProcAddress(hlib,'zmsg_test');
      pointer(zmsg_wrap):=GetProcAddress(hlib,'zmsg_wrap');
      pointer(zmsg_push):=GetProcAddress(hlib,'zmsg_push');
      pointer(zmsg_add):=GetProcAddress(hlib,'zmsg_add');

      pointer(zframe_new):=GetProcAddress(hlib,'zframe_new');
      pointer(zframe_new_empty):=GetProcAddress(hlib,'zframe_new_empty');
      pointer(zframe_destroy):=GetProcAddress(hlib,'zframe_destroy');
      pointer(zframe_recv):=GetProcAddress(hlib,'zframe_recv');
      pointer(zframe_recv_nowait):=GetProcAddress(hlib,'zframe_recv_nowait');
      pointer(zframe_send):=GetProcAddress(hlib,'zframe_send');
      pointer(zframe_size):=GetProcAddress(hlib,'zframe_size');
      pointer(zframe_data):=GetProcAddress(hlib,'zframe_data');
      pointer(zframe_dup):=GetProcAddress(hlib,'zframe_dup');
      pointer(zframe_strhex):=GetProcAddress(hlib,'zframe_strhex');
      pointer(zframe_strdup):=GetProcAddress(hlib,'zframe_strdup');
      pointer(zframe_streq):=GetProcAddress(hlib,'zframe_streq');
      pointer(zframe_more):=GetProcAddress(hlib,'zframe_more');
      pointer(zframe_set_more):=GetProcAddress(hlib,'zframe_set_more');
      pointer(zframe_eq):=GetProcAddress(hlib,'zframe_eq');
      pointer(zframe_fprint):=GetProcAddress(hlib,'zframe_fprint');
      pointer(zframe_print):=GetProcAddress(hlib,'zframe_print');
      pointer(zframe_reset):=GetProcAddress(hlib,'zframe_reset');
      pointer(zframe_put_block):=GetProcAddress(hlib,'zframe_put_block');
      pointer(zframe_test):=GetProcAddress(hlib,'zframe_test');

      pointer(zauth_new):=GetProcAddress(hlib,'zauth_new');
      pointer(zauth_allow):=GetProcAddress(hlib,'zauth_allow');
      pointer(zauth_deny):=GetProcAddress(hlib,'zauth_deny');
      pointer(zauth_configure_plain):=GetProcAddress(hlib,'zauth_configure_plain');
      pointer(zauth_configure_curve):=GetProcAddress(hlib,'zauth_configure_curve');
      pointer(zauth_set_verbose):=GetProcAddress(hlib,'zauth_set_verbose');
      pointer(zauth_destroy):=GetProcAddress(hlib,'zauth_destroy');
      pointer(zauth_test):=GetProcAddress(hlib,'zauth_test');

      pointer(zpoller_new):=GetProcAddress(hlib,'zpoller_new');
      pointer(zpoller_new):=GetProcAddress(hlib,'zpoller_new');
      pointer(zpoller_destroy):=GetProcAddress(hlib,'zpoller_destroy');
      pointer(zpoller_add):=GetProcAddress(hlib,'zpoller_add');
      pointer(zpoller_wait):=GetProcAddress(hlib,'zpoller_wait');
      pointer(zpoller_expired):=GetProcAddress(hlib,'zpoller_expired');
      pointer(zpoller_terminated):=GetProcAddress(hlib,'zpoller_terminated');
      pointer(zpoller_test):=GetProcAddress(hlib,'zpoller_test');

      pointer(zloop_new):=GetProcAddress(hlib,'zloop_new');
      pointer(zloop_destroy):=GetProcAddress(hlib,'zloop_destroy');
      pointer(zloop_poller):=GetProcAddress(hlib,'zloop_poller');
      pointer(zloop_poller_end):=GetProcAddress(hlib,'zloop_poller_end');
      pointer(zloop_set_tolerant):=GetProcAddress(hlib,'zloop_set_tolerant');
      pointer(zloop_timer):=GetProcAddress(hlib,'zloop_timer');
      pointer(zloop_timer_end):=GetProcAddress(hlib,'zloop_timer_end');
      pointer(zloop_set_verbose):=GetProcAddress(hlib,'zloop_set_verbose');
      pointer(zloop_start):=GetProcAddress(hlib,'zloop_start');
      pointer(zloop_test):=GetProcAddress(hlib,'zloop_test');

      pointer(zmonitor_new):=GetProcAddress(hlib,'zmonitor_new');
      pointer(zmonitor_destroy):=GetProcAddress(hlib,'zmonitor_destroy');
      pointer(zmonitor_recv):=GetProcAddress(hlib,'zmonitor_recv');
      pointer(zmonitor_socket):=GetProcAddress(hlib,'zmonitor_socket');
      pointer(zmonitor_set_verbose):=GetProcAddress(hlib,'zmonitor_set_verbose');
      pointer(zmonitor_test):=GetProcAddress(hlib,'zmonitor_test');
      
      pointer(zsocket_tos):=GetProcAddress(hlib,'zsocket_tos');
      pointer(zsocket_plain_server):=GetProcAddress(hlib,'zsocket_plain_server');
      pointer(zsocket_plain_username):=GetProcAddress(hlib,'zsocket_plain_username');
      pointer(zsocket_plain_password):=GetProcAddress(hlib,'zsocket_plain_password');
      pointer(zsocket_curve_server):=GetProcAddress(hlib,'zsocket_curve_server');
      pointer(zsocket_curve_publickey):=GetProcAddress(hlib,'zsocket_curve_publickey');
      pointer(zsocket_curve_secretkey):=GetProcAddress(hlib,'zsocket_curve_secretkey');
      pointer(zsocket_curve_serverkey):=GetProcAddress(hlib,'zsocket_curve_serverkey');
      pointer(zsocket_zap_domain):=GetProcAddress(hlib,'zsocket_zap_domain');
      pointer(zsocket_mechanism):=GetProcAddress(hlib,'zsocket_mechanism');
      pointer(zsocket_ipv6):=GetProcAddress(hlib,'zsocket_ipv6');
      pointer(zsocket_immediate):=GetProcAddress(hlib,'zsocket_immediate');
      pointer(zsocket_ipv4only):=GetProcAddress(hlib,'zsocket_ipv4only');
      pointer(zsocket_type):=GetProcAddress(hlib,'zsocket_type');
      pointer(zsocket_sndhwm):=GetProcAddress(hlib,'zsocket_sndhwm');
      pointer(zsocket_rcvhwm):=GetProcAddress(hlib,'zsocket_rcvhwm');
      pointer(zsocket_affinity):=GetProcAddress(hlib,'zsocket_affinity');
      pointer(zsocket_identity):=GetProcAddress(hlib,'zsocket_identity');
      pointer(zsocket_rate):=GetProcAddress(hlib,'zsocket_rate');
      pointer(zsocket_recovery_ivl):=GetProcAddress(hlib,'zsocket_recovery_ivl');
      pointer(zsocket_sndbuf):=GetProcAddress(hlib,'zsocket_sndbuf');
      pointer(zsocket_rcvbuf):=GetProcAddress(hlib,'zsocket_rcvbuf');
      pointer(zsocket_linger):=GetProcAddress(hlib,'zsocket_linger');
      pointer(zsocket_reconnect_ivl):=GetProcAddress(hlib,'zsocket_reconnect_ivl');
      pointer(zsocket_reconnect_ivl_max):=GetProcAddress(hlib,'zsocket_reconnect_ivl_max');
      pointer(zsocket_backlog):=GetProcAddress(hlib,'zsocket_backlog');
      pointer(zsocket_maxmsgsize):=GetProcAddress(hlib,'zsocket_maxmsgsize');
      pointer(zsocket_multicast_hops):=GetProcAddress(hlib,'zsocket_multicast_hops');
      pointer(zsocket_rcvtimeo):=GetProcAddress(hlib,'zsocket_rcvtimeo');
      pointer(zsocket_sndtimeo):=GetProcAddress(hlib,'zsocket_sndtimeo');
      pointer(zsocket_tcp_keepalive):=GetProcAddress(hlib,'zsocket_tcp_keepalive');
      pointer(zsocket_tcp_keepalive_idle):=GetProcAddress(hlib,'zsocket_tcp_keepalive_idle');
      pointer(zsocket_tcp_keepalive_cnt):=GetProcAddress(hlib,'zsocket_tcp_keepalive_cnt');
      pointer(zsocket_tcp_keepalive_intvl):=GetProcAddress(hlib,'zsocket_tcp_keepalive_intvl');
      pointer(zsocket_tcp_accept_filter):=GetProcAddress(hlib,'zsocket_tcp_accept_filter');
      pointer(zsocket_rcvmore):=GetProcAddress(hlib,'zsocket_rcvmore');
      pointer(zsocket_fd):=GetProcAddress(hlib,'zsocket_fd');
      pointer(zsocket_events):=GetProcAddress(hlib,'zsocket_events');
      pointer(zsocket_last_endpoint):=GetProcAddress(hlib,'zsocket_last_endpoint');
      pointer(zsocket_set_tos):=GetProcAddress(hlib,'zsocket_set_tos');
      pointer(zsocket_set_router_handover):=GetProcAddress(hlib,'zsocket_set_router_handover');
      pointer(zsocket_set_router_mandatory):=GetProcAddress(hlib,'zsocket_set_router_mandatory');
      pointer(zsocket_set_probe_router):=GetProcAddress(hlib,'zsocket_set_probe_router');
      pointer(zsocket_set_req_relaxed):=GetProcAddress(hlib,'zsocket_set_req_relaxed');
      pointer(zsocket_set_req_correlate):=GetProcAddress(hlib,'zsocket_set_req_correlate');
      pointer(zsocket_set_conflate):=GetProcAddress(hlib,'zsocket_set_conflate');
      pointer(zsocket_set_plain_server):=GetProcAddress(hlib,'zsocket_set_plain_server');
      pointer(zsocket_set_plain_username):=GetProcAddress(hlib,'zsocket_set_plain_username');
      pointer(zsocket_set_plain_password):=GetProcAddress(hlib,'zsocket_set_plain_password');
      pointer(zsocket_set_curve_server):=GetProcAddress(hlib,'zsocket_set_curve_server');
      pointer(zsocket_set_curve_publickey):=GetProcAddress(hlib,'zsocket_set_curve_publickey');
      pointer(zsocket_set_curve_publickey_bin):=GetProcAddress(hlib,'zsocket_set_curve_publickey_bin');
      pointer(zsocket_set_curve_secretkey):=GetProcAddress(hlib,'zsocket_set_curve_secretkey');
      pointer(zsocket_set_curve_secretkey_bin):=GetProcAddress(hlib,'zsocket_set_curve_secretkey_bin');
      pointer(zsocket_set_curve_serverkey):=GetProcAddress(hlib,'zsocket_set_curve_serverkey');
      pointer(zsocket_set_curve_serverkey_bin):=GetProcAddress(hlib,'zsocket_set_curve_serverkey_bin');
      pointer(zsocket_set_zap_domain):=GetProcAddress(hlib,'zsocket_set_zap_domain');
      pointer(zsocket_set_ipv6):=GetProcAddress(hlib,'zsocket_set_ipv6');
      pointer(zsocket_set_immediate):=GetProcAddress(hlib,'zsocket_set_immediate');
      pointer(zsocket_set_router_raw):=GetProcAddress(hlib,'zsocket_set_router_raw');
      pointer(zsocket_set_ipv4only):=GetProcAddress(hlib,'zsocket_set_ipv4only');
      pointer(zsocket_set_delay_attach_on_connect):=GetProcAddress(hlib,'zsocket_set_delay_attach_on_connect');
      pointer(zsocket_set_sndhwm):=GetProcAddress(hlib,'zsocket_set_sndhwm');
      pointer(zsocket_set_rcvhwm):=GetProcAddress(hlib,'zsocket_set_rcvhwm');
      pointer(zsocket_set_affinity):=GetProcAddress(hlib,'zsocket_set_affinity');
      pointer(zsocket_set_subscribe):=GetProcAddress(hlib,'zsocket_set_subscribe');
      pointer(zsocket_set_unsubscribe):=GetProcAddress(hlib,'zsocket_set_unsubscribe');
      pointer(zsocket_set_identity):=GetProcAddress(hlib,'zsocket_set_identity');
      pointer(zsocket_set_rate):=GetProcAddress(hlib,'zsocket_set_rate');
      pointer(zsocket_set_recovery_ivl):=GetProcAddress(hlib,'zsocket_set_recovery_ivl');
      pointer(zsocket_set_sndbuf):=GetProcAddress(hlib,'zsocket_set_sndbuf');
      pointer(zsocket_set_rcvbuf):=GetProcAddress(hlib,'zsocket_set_rcvbuf');
      pointer(zsocket_set_linger):=GetProcAddress(hlib,'zsocket_set_linger');
      pointer(zsocket_set_reconnect_ivl):=GetProcAddress(hlib,'zsocket_set_reconnect_ivl');
      pointer(zsocket_set_reconnect_ivl_max):=GetProcAddress(hlib,'zsocket_set_reconnect_ivl_max');
      pointer(zsocket_set_backlog):=GetProcAddress(hlib,'zsocket_set_backlog');
      pointer(zsocket_set_maxmsgsize):=GetProcAddress(hlib,'zsocket_set_maxmsgsize');
      pointer(zsocket_set_multicast_hops):=GetProcAddress(hlib,'zsocket_set_multicast_hops');
      pointer(zsocket_set_rcvtimeo):=GetProcAddress(hlib,'zsocket_set_rcvtimeo');
      pointer(zsocket_set_sndtimeo):=GetProcAddress(hlib,'zsocket_set_sndtimeo');
      pointer(zsocket_set_xpub_verbose):=GetProcAddress(hlib,'zsocket_set_xpub_verbose');
      pointer(zsocket_set_tcp_keepalive):=GetProcAddress(hlib,'zsocket_set_tcp_keepalive');
      pointer(zsocket_set_tcp_keepalive_idle):=GetProcAddress(hlib,'zsocket_set_tcp_keepalive_idle');
      pointer(zsocket_set_tcp_keepalive_cnt):=GetProcAddress(hlib,'zsocket_set_tcp_keepalive_cnt');
      pointer(zsocket_set_tcp_keepalive_intvl):=GetProcAddress(hlib,'zsocket_set_tcp_keepalive_intvl');
      pointer(zsocket_set_tcp_accept_filter):=GetProcAddress(hlib,'zsocket_set_tcp_accept_filter');
      pointer(zsocket_set_hwm):=GetProcAddress(hlib,'zsocket_set_hwm');
      pointer(zsockopt_test):=GetProcAddress(hlib,'zsockopt_test');

      pointer(zbeacon_new):=GetProcAddress(hlib,'zbeacon_new');
      pointer(zbeacon_destroy):=GetProcAddress(hlib,'zbeacon_destroy');
      pointer(zbeacon_hostname):=GetProcAddress(hlib,'zbeacon_hostname');
      pointer(zbeacon_set_interval):=GetProcAddress(hlib,'zbeacon_set_interval');
      pointer(zbeacon_noecho):=GetProcAddress(hlib,'zbeacon_noecho');
      pointer(zbeacon_publish):=GetProcAddress(hlib,'zbeacon_publish');
      pointer(zbeacon_silence):=GetProcAddress(hlib,'zbeacon_silence');
      pointer(zbeacon_subscribe):=GetProcAddress(hlib,'zbeacon_subscribe');
      pointer(zbeacon_unsubscribe):=GetProcAddress(hlib,'zbeacon_unsubscribe');
      pointer(zbeacon_socket):=GetProcAddress(hlib,'zbeacon_socket');
      pointer(zbeacon_test):=GetProcAddress(hlib,'zbeacon_test');

      pointer(zuuid_new):=GetProcAddress(hlib,'zuuid_new');
      pointer(zuuid_destroy):=GetProcAddress(hlib,'zuuid_destroy');
      pointer(zuuid_data):=GetProcAddress(hlib,'zuuid_data');
      pointer(zuuid_size):=GetProcAddress(hlib,'zuuid_size');
      pointer(zuuid_str):=GetProcAddress(hlib,'zuuid_str');
      pointer(zuuid_set):=GetProcAddress(hlib,'zuuid_set');
      pointer(zuuid_export):=GetProcAddress(hlib,'zuuid_export');
      pointer(zuuid_eq):=GetProcAddress(hlib,'zuuid_eq');
      pointer(zuuid_neq):=GetProcAddress(hlib,'zuuid_neq');
      pointer(zuuid_dup):=GetProcAddress(hlib,'zuuid_dup');
      pointer(zuuid_test):=GetProcAddress(hlib,'zuuid_test');
    end;


initialization
  LoadLib('czmq.dll');

finalization
  FreeLib('czmq.dll');

end.
