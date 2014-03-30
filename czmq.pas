{  =========================================================================
    czmq.pas - CZMQ API Pascal Binding

    Copyright (c) 2014 Marcelo Campos Rocha

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

{$IFNDEF DELPHI2009_UP}
    NativeUInt = Cardinal; 
{$ENDIF}

  {  This port range is defined by IANA for dynamic or private ports }
  {  We use this when choosing a port for dynamic binding. }


  {  Callback function for zero-copy methods }


  {** zctx **}

  type
    pzcx_t = ^zctx_t;
    zctx_t = record
    end;
    
  var
  {  Create new context, returns context object, replaces zmq_init }
    zctx_new : function: pzctx_t; cdecl;

  {  Destroy context and all sockets in it, replaces zmq_term }
    zctx_destroy : procedure(var self: pzctx_t); cdecl;

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
    zctx_test : function(verbose: Longbool): Longint; cdecl;
    
  {  Global signal indicator, TRUE when user presses Ctrl-C or the process }
  {  gets a SIGTERM signal. }
  { extern volatile int zctx_interrupted; }

  {** zsocket **}

  const
    ZSOCKET_DYNFROM = $c000;    
    ZSOCKET_DYNTO = $ffff;   

  type
    //  Callback function for zero-copy methods
    zsocket_free_fn = procedure(data: Pointer; arg: Pointer); cdecl;

  var
  
  {  Create a new socket within our CZMQ context, replaces zmq_socket. }
  {  Use this to get automatic management of the socket at shutdown. }
  {  Note: SUB sockets do not automatically subscribe to everything; you }
  {  must set filters explicitly. }
    zsocket_new : function(self: pzctx_t; atype: Longint): Pointer; cdecl;
    
  {  Destroy a socket within our CZMQ context, replaces zmq_close. }
    zsocket_destroy : procedure(self: pzctx_t; socket: Pointer); cdecl;
    
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
    zsocket_connect : function(socket: Pointer; format: PAnsiChar): Longint; cdecl; varargs;
    
  {  Disonnect a socket from a formatted endpoint }
  {  Returns 0 if OK, -1 if the endpoint was invalid or the function }
  {  isn't supported. }
    zsocket_disconnect : function(socket: Pointer; format: PAnsiChar): Longint; cdecl; varargs;
    
  {  Poll for input events on the socket. Returns TRUE if there is input }
  {  ready on the socket, else FALSE. }
    zsocket_poll : function(socket: Pointer; msecs: Longint): Longbool; cdecl; varargs;
    
  {  Returns socket type as printable constant string }
    zsocket_type_str : function(socket: Pointer): PAnsiChar; cdecl;
    
  {  Send data over a socket as a single message frame. }
  {  Accepts these flags: ZFRAME_MORE and ZFRAME_DONTWAIT. }
    zsocket_sendmem : function(socket: Pointer; const data; size: size_t; flags: Longint): Longint; cdecl;
    
    
  {  Send a signal over a socket. A signal is a zero-byte message. }
  {  Signals are used primarily between threads, over pipe sockets. }
  {  Returns -1 if there was an error sending the signal. }
    zsocket_signal : function(socket: Pointer): Longint; cdecl;
    
  {  Wait on a signal. Use this to coordinate between threads, over }
  {  pipe pairs. Returns -1 on error, 0 on success. }
    zsocket_wait : function(socket: Pointer): Longint; cdecl;
    
  {  Send data over a socket as a single message frame. }
  {  Returns -1 on error, 0 on success }
   // zsocket_sendmem : function(socket: Pointer; const data; size: Longint; flags: Longint): Longint; cdecl;
    
  {  Self test of this class }
    zsocket_test : function(verbose: Longbool): Longint; cdecl;

  {** zsockopt **}

    zsocket_tos : function(zocket: Pointer): Longint; cdecl;
    zsocket_plain_server : function(zocket: Pointer): Longint; cdecl;
    zsocket_plain_username : function(zocket: Pointer): PAnsiChar; cdecl;
    zsocket_plain_password : function(zocket: Pointer): PAnsiChar; cdecl;
    zsocket_curve_server : function(zocket: Pointer): Longint; cdecl;
    zsocket_curve_publickey : function(zocket: Pointer): PAnsiChar; cdecl;
    zsocket_curve_secretkey : function(zocket: Pointer): PAnsiChar; cdecl;
    zsocket_curve_serverkey : function(zocket: Pointer): PAnsiChar; cdecl;
    zsocket_zap_domain : function(zocket: Pointer): PAnsiChar; cdecl;
    zsocket_mechanism : function(zocket: Pointer): Longint; cdecl;
    zsocket_ipv6 : function(zocket: Pointer): Longint; cdecl;
    zsocket_immediate : function(zocket: Pointer): Longint; cdecl;
    zsocket_ipv4only : function(zocket: Pointer): Longint; cdecl;
    zsocket_type : function(zocket: Pointer): Longint; cdecl;
    zsocket_sndhwm : function(zocket: Pointer): Longint; cdecl;
    zsocket_rcvhwm : function(zocket: Pointer): Longint; cdecl;
    zsocket_affinity : function(zocket: Pointer): Longint; cdecl;
    zsocket_identity : function(zocket: Pointer): PAnsiChar; cdecl;
    zsocket_rate : function(zocket: Pointer): Longint; cdecl;
    zsocket_recovery_ivl : function(zocket: Pointer): Longint; cdecl;
    zsocket_sndbuf : function(zocket: Pointer): Longint; cdecl;
    zsocket_rcvbuf : function(zocket: Pointer): Longint; cdecl;
    zsocket_linger : function(zocket: Pointer): Longint; cdecl;
    zsocket_reconnect_ivl : function(zocket: Pointer): Longint; cdecl;
    zsocket_reconnect_ivl_max : function(zocket: Pointer): Longint; cdecl;
    zsocket_backlog : function(zocket: Pointer): Longint; cdecl;
    zsocket_maxmsgsize : function(zocket: Pointer): Longint; cdecl;
    zsocket_multicast_hops : function(zocket: Pointer): Longint; cdecl;
    zsocket_rcvtimeo : function(zocket: Pointer): Longint; cdecl;
    zsocket_sndtimeo : function(zocket: Pointer): Longint; cdecl;
    zsocket_tcp_keepalive : function(zocket: Pointer): Longint; cdecl;
    zsocket_tcp_keepalive_idle : function(zocket: Pointer): Longint; cdecl;
    zsocket_tcp_keepalive_cnt : function(zocket: Pointer): Longint; cdecl;
    zsocket_tcp_keepalive_intvl : function(zocket: Pointer): Longint; cdecl;
    zsocket_tcp_accept_filter : function(zocket: Pointer): PAnsiChar; cdecl;
    zsocket_rcvmore : function(zocket: Pointer): Longint; cdecl;
    zsocket_fd : function(zocket: Pointer): Longint; cdecl;
    zsocket_events : function(zocket: Pointer): Longint; cdecl;
    zsocket_last_endpoint : function(zocket: Pointer): PAnsiChar; cdecl;
  {  Set socket options }
    zsocket_set_tos : procedure(zocket: Pointer; tos: Longint); cdecl;
    zsocket_set_router_handover : procedure(zocket: Pointer; router_handover: Longint); cdecl;
    zsocket_set_router_mandatory : procedure(zocket: Pointer; router_mandatory: Longint); cdecl;
    zsocket_set_probe_router : procedure(zocket: Pointer; probe_router: Longint); cdecl;
    zsocket_set_req_relaxed : procedure(zocket: Pointer; req_relaxed: Longint); cdecl;
    zsocket_set_req_correlate : procedure(zocket: Pointer; req_correlate: Longint); cdecl;
    zsocket_set_conflate : procedure(zocket: Pointer; conflate: Longint); cdecl;
    zsocket_set_plain_server : procedure(zocket: Pointer; plain_server: Longint); cdecl;
    zsocket_set_plain_username : procedure(zocket: Pointer; plain_username: PAnsiChar); cdecl;
    zsocket_set_plain_password : procedure(zocket: Pointer; plain_password: PAnsiChar); cdecl;
    zsocket_set_curve_server : procedure(zocket: Pointer; curve_server: Longint); cdecl;
    zsocket_set_curve_publickey : procedure(zocket: Pointer; curve_publickey: PAnsiChar); cdecl;
    zsocket_set_curve_publickey_bin : procedure(zocket: Pointer; var curve_publickey:byte); cdecl;
    zsocket_set_curve_secretkey : procedure(zocket: Pointer; curve_secretkey: PAnsiChar); cdecl;
    zsocket_set_curve_secretkey_bin : procedure(zocket: Pointer; var curve_secretkey:byte); cdecl;
    zsocket_set_curve_serverkey : procedure(zocket: Pointer; curve_serverkey: PAnsiChar); cdecl;
    zsocket_set_curve_serverkey_bin : procedure(zocket: Pointer; var curve_serverkey:byte); cdecl;
    zsocket_set_zap_domain : procedure(zocket: Pointer; zap_domain: PAnsiChar); cdecl;
    zsocket_set_ipv6 : procedure(zocket: Pointer; ipv6: Longint); cdecl;
    zsocket_set_immediate : procedure(zocket: Pointer; immediate: Longint); cdecl;
    zsocket_set_router_raw : procedure(zocket: Pointer; router_raw: Longint); cdecl;
    zsocket_set_ipv4only : procedure(zocket: Pointer; ipv4only: Longint); cdecl;
    zsocket_set_delay_attach_on_connect : procedure(zocket: Pointer; delay_attach_on_connect: Longint); cdecl;
    zsocket_set_sndhwm : procedure(zocket: Pointer; sndhwm: Longint); cdecl;
    zsocket_set_rcvhwm : procedure(zocket: Pointer; rcvhwm: Longint); cdecl;
    zsocket_set_affinity : procedure(zocket: Pointer; affinity: Longint); cdecl;
    zsocket_set_subscribe : procedure(zocket: Pointer; subscribe: PAnsiChar); cdecl;
    zsocket_set_unsubscribe : procedure(zocket: Pointer; unsubscribe: PAnsiChar); cdecl;
    zsocket_set_identity : procedure(zocket: Pointer; identity: PAnsiChar); cdecl;
    zsocket_set_rate : procedure(zocket: Pointer; rate: Longint); cdecl;
    zsocket_set_recovery_ivl : procedure(zocket: Pointer; recovery_ivl: Longint); cdecl;
    zsocket_set_sndbuf : procedure(zocket: Pointer; sndbuf: Longint); cdecl;
    zsocket_set_rcvbuf : procedure(zocket: Pointer; rcvbuf: Longint); cdecl;
    zsocket_set_linger : procedure(zocket: Pointer; linger: Longint); cdecl;
    zsocket_set_reconnect_ivl : procedure(zocket: Pointer; reconnect_ivl: Longint); cdecl;
    zsocket_set_reconnect_ivl_max : procedure(zocket: Pointer; reconnect_ivl_max: Longint); cdecl;
    zsocket_set_backlog : procedure(zocket: Pointer; backlog: Longint); cdecl;
    zsocket_set_maxmsgsize : procedure(zocket: Pointer; maxmsgsize: Longint); cdecl;
    zsocket_set_multicast_hops : procedure(zocket: Pointer; multicast_hops: Longint); cdecl;
    zsocket_set_rcvtimeo : procedure(zocket: Pointer; rcvtimeo: Longint); cdecl;
    zsocket_set_sndtimeo : procedure(zocket: Pointer; sndtimeo: Longint); cdecl;
    zsocket_set_xpub_verbose : procedure(zocket: Pointer; xpub_verbose: Longint); cdecl;
    zsocket_set_tcp_keepalive : procedure(zocket: Pointer; tcp_keepalive: Longint); cdecl;
    zsocket_set_tcp_keepalive_idle : procedure(zocket: Pointer; tcp_keepalive_idle: Longint); cdecl;
    zsocket_set_tcp_keepalive_cnt : procedure(zocket: Pointer; tcp_keepalive_cnt: Longint); cdecl;
    zsocket_set_tcp_keepalive_intvl : procedure(zocket: Pointer; tcp_keepalive_intvl: Longint); cdecl;
    zsocket_set_tcp_accept_filter : procedure(zocket: Pointer; tcp_accept_filter: PAnsiChar); cdecl;
  {  Emulation of widely-used 2.x socket options }
    zsocket_set_hwm : procedure(zocket: Pointer; hwm: Longint); cdecl;
  {  Self test of this class }
    zsockopt_test : function(verbose: Longbool): Longint; cdecl;

  {** zmsg **}

  type
    pzmsg_t = ^zmsg_t;
    zmsg_t = record // opaque dataType
    end;
    
    pzframe_t = ^zframe_t;
    zframe_t = record // opaque dataType
    end;

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
    zmsg_pushstrf : function(self: pzmsg_t; format: PAnsiChar{, ...}): Longint; cdecl; varargs;
    
  {  Push formatted string as new frame to end of message. }
  {  Returns 0 on success, -1 on error. }
    zmsg_addstrf : function(self: pzmsg_t; format: PAnsiChar{, ...}): Longint; cdecl; varargs;
    
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
    zmsg_test : function(verbose:bool): Longint; cdecl;
    
  {** zframe **}

type
    pzframe_t = ^zframe_t;
    zframe_t = record // opaque datatype
    end;

const
    ZFRAME_MORE = 1;    
    ZFRAME_REUSE = 2;    
    ZFRAME_DONTWAIT = 4;    

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
    zframe_streq : function(self: pzframe_t; _string: PAnsiChar):bool; cdecl;
    
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
    zframe_reset : procedure(self: pzframe_t; const data; size: NativeUInt); cdecl;
    
  {  Put a block of data to the frame payload. }
    zframe_put_block : function(self: pzframe_t; data: PByteArray; size: NativeUInt): Longint; cdecl;
    
  {  Self test of this class }
    zframe_test : function(verbose: Longbool): Longint; cdecl;

{** zloop **}

  type
    pzloop_t = ^zloop_t;
    zloop_t = record // opaque struct
    end;
    
    //  Callback function for reactor events
    zloop_fn = function(loop: pzloop_t; poolitem: Pointer; arg: Pointer): Longint; cdecl;
    
    // Callback for reactor timer events
    zloop_timer_fn = function(loop: pzloop_t; timer_id: Longint; arg: Pointer): Longint; cdecl;
    
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

{** zauth **}

  type
    pzauth_t = ^zauth_t;
    zauth_t = record // opaque struct
    end;

  const
    CURVE_ALLOW_ANY = '*';    

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

  {** zpoller **}
  type
    pzpoller_t = ^zpoller_t;
    zpoller_t = record
    end;
    
  {  Create new poller }
    zpoller_new : function(var reader: Pointer{, ...}): pzpoller_t; cdecl; varargs;
    
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

  {** zmonitor **}
  
  type
    pzmonitor_t = ^zmonitor_t;
    zmonitor_t = record // opaque struct
    end;

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

  {** zbeacon **}
  type
    pzbeacon_t = ^zbeacon_t;
    zbeacon_t = record
    end;
    
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

  {** zuuid **}

  const
    ZUUID_LEN = 16;    

  type
    pzuuid_t = ^zuuid_t;
    zuuid_t = record // opaque struct
    end;

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

      Pointer(zctx_new) := GetProcAddress(hlib, 'zctx_new');
      Pointer(zctx_destroy) := GetProcAddress(hlib, 'zctx_destroy');
      Pointer(zctx_shadow) := GetProcAddress(hlib, 'zctx_shadow');
      Pointer(zctx_shadow_zmq_ctx) := GetProcAddress(hlib, 'zctx_shadow_zmq_ctx');
      Pointer(zctx_set_iothreads) := GetProcAddress(hlib, 'zctx_set_iothreads');
      Pointer(zctx_set_linger) := GetProcAddress(hlib, 'zctx_set_linger');
      Pointer(zctx_set_pipehwm) := GetProcAddress(hlib, 'zctx_set_pipehwm');
      Pointer(zctx_set_sndhwm) := GetProcAddress(hlib, 'zctx_set_sndhwm');
      Pointer(zctx_set_rcvhwm) := GetProcAddress(hlib, 'zctx_set_rcvhwm');
      Pointer(zctx_underlying) := GetProcAddress(hlib, 'zctx_underlying');
      Pointer(zctx_test) := GetProcAddress(hlib, 'zctx_test');

      Pointer(zsocket_new) := GetProcAddress(hlib, 'zsocket_new');
      Pointer(zsocket_destroy) := GetProcAddress(hlib, 'zsocket_destroy');
      Pointer(zsocket_bind) := GetProcAddress(hlib, 'zsocket_bind');
      Pointer(zsocket_bind) := GetProcAddress(hlib, 'zsocket_bind');
      Pointer(zsocket_unbind) := GetProcAddress(hlib, 'zsocket_unbind');
      Pointer(zsocket_unbind) := GetProcAddress(hlib, 'zsocket_unbind');
      Pointer(zsocket_connect) := GetProcAddress(hlib, 'zsocket_connect');
      Pointer(zsocket_connect) := GetProcAddress(hlib, 'zsocket_connect');
      Pointer(zsocket_disconnect) := GetProcAddress(hlib, 'zsocket_disconnect');
      Pointer(zsocket_disconnect) := GetProcAddress(hlib, 'zsocket_disconnect');
      Pointer(zsocket_poll) := GetProcAddress(hlib, 'zsocket_poll');
      Pointer(zsocket_type_str) := GetProcAddress(hlib, 'zsocket_type_str');
      Pointer(zsocket_sendmem) := GetProcAddress(hlib, 'zsocket_sendmem');
      Pointer(zsocket_signal) := GetProcAddress(hlib, 'zsocket_signal');
      Pointer(zsocket_wait) := GetProcAddress(hlib, 'zsocket_wait');
      Pointer(zsocket_test) := GetProcAddress(hlib, 'zsocket_test');

      Pointer(zmsg_new) := GetProcAddress(hlib, 'zmsg_new');
      Pointer(zmsg_destroy) := GetProcAddress(hlib, 'zmsg_destroy');
      Pointer(zmsg_recv) := GetProcAddress(hlib, 'zmsg_recv');
      Pointer(zmsg_recv_nowait) := GetProcAddress(hlib, 'zmsg_recv_nowait');
      Pointer(zmsg_send) := GetProcAddress(hlib, 'zmsg_send');
      Pointer(zmsg_size) := GetProcAddress(hlib, 'zmsg_size');
      Pointer(zmsg_content_size) := GetProcAddress(hlib, 'zmsg_content_size');
      Pointer(zmsg_prepend) := GetProcAddress(hlib, 'zmsg_prepend');
      Pointer(zmsg_append) := GetProcAddress(hlib, 'zmsg_append');
      Pointer(zmsg_pop) := GetProcAddress(hlib, 'zmsg_pop');
      Pointer(zmsg_pushmem) := GetProcAddress(hlib, 'zmsg_pushmem');
      Pointer(zmsg_addmem) := GetProcAddress(hlib, 'zmsg_addmem');
      Pointer(zmsg_pushstr) := GetProcAddress(hlib, 'zmsg_pushstr');
      Pointer(zmsg_addstr) := GetProcAddress(hlib, 'zmsg_addstr');
      Pointer(zmsg_pushstrf) := GetProcAddress(hlib, 'zmsg_pushstrf');
      Pointer(zmsg_pushstrf) := GetProcAddress(hlib, 'zmsg_pushstrf');
      Pointer(zmsg_addstrf) := GetProcAddress(hlib, 'zmsg_addstrf');
      Pointer(zmsg_addstrf) := GetProcAddress(hlib, 'zmsg_addstrf');
      Pointer(zmsg_popstr) := GetProcAddress(hlib, 'zmsg_popstr');
      Pointer(zmsg_unwrap) := GetProcAddress(hlib, 'zmsg_unwrap');
      Pointer(zmsg_remove) := GetProcAddress(hlib, 'zmsg_remove');
      Pointer(zmsg_first) := GetProcAddress(hlib, 'zmsg_first');
      Pointer(zmsg_next) := GetProcAddress(hlib, 'zmsg_next');
      Pointer(zmsg_last) := GetProcAddress(hlib, 'zmsg_last');
      Pointer(zmsg_save) := GetProcAddress(hlib, 'zmsg_save');
      Pointer(zmsg_load) := GetProcAddress(hlib, 'zmsg_load');
      Pointer(zmsg_encode) := GetProcAddress(hlib, 'zmsg_encode');
      Pointer(zmsg_decode) := GetProcAddress(hlib, 'zmsg_decode');
      Pointer(zmsg_dup) := GetProcAddress(hlib, 'zmsg_dup');
      Pointer(zmsg_fprint) := GetProcAddress(hlib, 'zmsg_fprint');
      Pointer(zmsg_print) := GetProcAddress(hlib, 'zmsg_print');
      Pointer(zmsg_test) := GetProcAddress(hlib, 'zmsg_test');
      Pointer(zmsg_wrap) := GetProcAddress(hlib, 'zmsg_wrap');
      Pointer(zmsg_push) := GetProcAddress(hlib, 'zmsg_push');
      Pointer(zmsg_add) := GetProcAddress(hlib, 'zmsg_add');

      Pointer(zframe_new) := GetProcAddress(hlib, 'zframe_new');
      Pointer(zframe_new_empty) := GetProcAddress(hlib, 'zframe_new_empty');
      Pointer(zframe_destroy) := GetProcAddress(hlib, 'zframe_destroy');
      Pointer(zframe_recv) := GetProcAddress(hlib, 'zframe_recv');
      Pointer(zframe_recv_nowait) := GetProcAddress(hlib, 'zframe_recv_nowait');
      Pointer(zframe_send) := GetProcAddress(hlib, 'zframe_send');
      Pointer(zframe_size) := GetProcAddress(hlib, 'zframe_size');
      Pointer(zframe_data) := GetProcAddress(hlib, 'zframe_data');
      Pointer(zframe_dup) := GetProcAddress(hlib, 'zframe_dup');
      Pointer(zframe_strhex) := GetProcAddress(hlib, 'zframe_strhex');
      Pointer(zframe_strdup) := GetProcAddress(hlib, 'zframe_strdup');
      Pointer(zframe_streq) := GetProcAddress(hlib, 'zframe_streq');
      Pointer(zframe_more) := GetProcAddress(hlib, 'zframe_more');
      Pointer(zframe_set_more) := GetProcAddress(hlib, 'zframe_set_more');
      Pointer(zframe_eq) := GetProcAddress(hlib, 'zframe_eq');
      Pointer(zframe_fprint) := GetProcAddress(hlib, 'zframe_fprint');
      Pointer(zframe_print) := GetProcAddress(hlib, 'zframe_print');
      Pointer(zframe_reset) := GetProcAddress(hlib, 'zframe_reset');
      Pointer(zframe_put_block) := GetProcAddress(hlib, 'zframe_put_block');
      Pointer(zframe_test) := GetProcAddress(hlib, 'zframe_test');

      Pointer(zauth_new) := GetProcAddress(hlib, 'zauth_new');
      Pointer(zauth_allow) := GetProcAddress(hlib, 'zauth_allow');
      Pointer(zauth_deny) := GetProcAddress(hlib, 'zauth_deny');
      Pointer(zauth_configure_plain) := GetProcAddress(hlib, 'zauth_configure_plain');
      Pointer(zauth_configure_curve) := GetProcAddress(hlib, 'zauth_configure_curve');
      Pointer(zauth_set_verbose) := GetProcAddress(hlib, 'zauth_set_verbose');
      Pointer(zauth_destroy) := GetProcAddress(hlib, 'zauth_destroy');
      Pointer(zauth_test) := GetProcAddress(hlib, 'zauth_test');

      Pointer(zpoller_new) := GetProcAddress(hlib, 'zpoller_new');
      Pointer(zpoller_new) := GetProcAddress(hlib, 'zpoller_new');
      Pointer(zpoller_destroy) := GetProcAddress(hlib, 'zpoller_destroy');
      Pointer(zpoller_add) := GetProcAddress(hlib, 'zpoller_add');
      Pointer(zpoller_wait) := GetProcAddress(hlib, 'zpoller_wait');
      Pointer(zpoller_expired) := GetProcAddress(hlib, 'zpoller_expired');
      Pointer(zpoller_terminated) := GetProcAddress(hlib, 'zpoller_terminated');
      Pointer(zpoller_test) := GetProcAddress(hlib, 'zpoller_test');

      Pointer(zloop_new) := GetProcAddress(hlib, 'zloop_new');
      Pointer(zloop_destroy) := GetProcAddress(hlib, 'zloop_destroy');
      Pointer(zloop_poller) := GetProcAddress(hlib, 'zloop_poller');
      Pointer(zloop_poller_end) := GetProcAddress(hlib, 'zloop_poller_end');
      Pointer(zloop_set_tolerant) := GetProcAddress(hlib, 'zloop_set_tolerant');
      Pointer(zloop_timer) := GetProcAddress(hlib, 'zloop_timer');
      Pointer(zloop_timer_end) := GetProcAddress(hlib, 'zloop_timer_end');
      Pointer(zloop_set_verbose) := GetProcAddress(hlib, 'zloop_set_verbose');
      Pointer(zloop_start) := GetProcAddress(hlib, 'zloop_start');
      Pointer(zloop_test) := GetProcAddress(hlib, 'zloop_test');

      Pointer(zmonitor_new) := GetProcAddress(hlib, 'zmonitor_new');
      Pointer(zmonitor_destroy) := GetProcAddress(hlib, 'zmonitor_destroy');
      Pointer(zmonitor_recv) := GetProcAddress(hlib, 'zmonitor_recv');
      Pointer(zmonitor_socket) := GetProcAddress(hlib, 'zmonitor_socket');
      Pointer(zmonitor_set_verbose) := GetProcAddress(hlib, 'zmonitor_set_verbose');
      Pointer(zmonitor_test) := GetProcAddress(hlib, 'zmonitor_test');
      
      Pointer(zsocket_tos) := GetProcAddress(hlib, 'zsocket_tos');
      Pointer(zsocket_plain_server) := GetProcAddress(hlib, 'zsocket_plain_server');
      Pointer(zsocket_plain_username) := GetProcAddress(hlib, 'zsocket_plain_username');
      Pointer(zsocket_plain_password) := GetProcAddress(hlib, 'zsocket_plain_password');
      Pointer(zsocket_curve_server) := GetProcAddress(hlib, 'zsocket_curve_server');
      Pointer(zsocket_curve_publickey) := GetProcAddress(hlib, 'zsocket_curve_publickey');
      Pointer(zsocket_curve_secretkey) := GetProcAddress(hlib, 'zsocket_curve_secretkey');
      Pointer(zsocket_curve_serverkey) := GetProcAddress(hlib, 'zsocket_curve_serverkey');
      Pointer(zsocket_zap_domain) := GetProcAddress(hlib, 'zsocket_zap_domain');
      Pointer(zsocket_mechanism) := GetProcAddress(hlib, 'zsocket_mechanism');
      Pointer(zsocket_ipv6) := GetProcAddress(hlib, 'zsocket_ipv6');
      Pointer(zsocket_immediate) := GetProcAddress(hlib, 'zsocket_immediate');
      Pointer(zsocket_ipv4only) := GetProcAddress(hlib, 'zsocket_ipv4only');
      Pointer(zsocket_type) := GetProcAddress(hlib, 'zsocket_type');
      Pointer(zsocket_sndhwm) := GetProcAddress(hlib, 'zsocket_sndhwm');
      Pointer(zsocket_rcvhwm) := GetProcAddress(hlib, 'zsocket_rcvhwm');
      Pointer(zsocket_affinity) := GetProcAddress(hlib, 'zsocket_affinity');
      Pointer(zsocket_identity) := GetProcAddress(hlib, 'zsocket_identity');
      Pointer(zsocket_rate) := GetProcAddress(hlib, 'zsocket_rate');
      Pointer(zsocket_recovery_ivl) := GetProcAddress(hlib, 'zsocket_recovery_ivl');
      Pointer(zsocket_sndbuf) := GetProcAddress(hlib, 'zsocket_sndbuf');
      Pointer(zsocket_rcvbuf) := GetProcAddress(hlib, 'zsocket_rcvbuf');
      Pointer(zsocket_linger) := GetProcAddress(hlib, 'zsocket_linger');
      Pointer(zsocket_reconnect_ivl) := GetProcAddress(hlib, 'zsocket_reconnect_ivl');
      Pointer(zsocket_reconnect_ivl_max) := GetProcAddress(hlib, 'zsocket_reconnect_ivl_max');
      Pointer(zsocket_backlog) := GetProcAddress(hlib, 'zsocket_backlog');
      Pointer(zsocket_maxmsgsize) := GetProcAddress(hlib, 'zsocket_maxmsgsize');
      Pointer(zsocket_multicast_hops) := GetProcAddress(hlib, 'zsocket_multicast_hops');
      Pointer(zsocket_rcvtimeo) := GetProcAddress(hlib, 'zsocket_rcvtimeo');
      Pointer(zsocket_sndtimeo) := GetProcAddress(hlib, 'zsocket_sndtimeo');
      Pointer(zsocket_tcp_keepalive) := GetProcAddress(hlib, 'zsocket_tcp_keepalive');
      Pointer(zsocket_tcp_keepalive_idle) := GetProcAddress(hlib, 'zsocket_tcp_keepalive_idle');
      Pointer(zsocket_tcp_keepalive_cnt) := GetProcAddress(hlib, 'zsocket_tcp_keepalive_cnt');
      Pointer(zsocket_tcp_keepalive_intvl) := GetProcAddress(hlib, 'zsocket_tcp_keepalive_intvl');
      Pointer(zsocket_tcp_accept_filter) := GetProcAddress(hlib, 'zsocket_tcp_accept_filter');
      Pointer(zsocket_rcvmore) := GetProcAddress(hlib, 'zsocket_rcvmore');
      Pointer(zsocket_fd) := GetProcAddress(hlib, 'zsocket_fd');
      Pointer(zsocket_events) := GetProcAddress(hlib, 'zsocket_events');
      Pointer(zsocket_last_endpoint) := GetProcAddress(hlib, 'zsocket_last_endpoint');
      Pointer(zsocket_set_tos) := GetProcAddress(hlib, 'zsocket_set_tos');
      Pointer(zsocket_set_router_handover) := GetProcAddress(hlib, 'zsocket_set_router_handover');
      Pointer(zsocket_set_router_mandatory) := GetProcAddress(hlib, 'zsocket_set_router_mandatory');
      Pointer(zsocket_set_probe_router) := GetProcAddress(hlib, 'zsocket_set_probe_router');
      Pointer(zsocket_set_req_relaxed) := GetProcAddress(hlib, 'zsocket_set_req_relaxed');
      Pointer(zsocket_set_req_correlate) := GetProcAddress(hlib, 'zsocket_set_req_correlate');
      Pointer(zsocket_set_conflate) := GetProcAddress(hlib, 'zsocket_set_conflate');
      Pointer(zsocket_set_plain_server) := GetProcAddress(hlib, 'zsocket_set_plain_server');
      Pointer(zsocket_set_plain_username) := GetProcAddress(hlib, 'zsocket_set_plain_username');
      Pointer(zsocket_set_plain_password) := GetProcAddress(hlib, 'zsocket_set_plain_password');
      Pointer(zsocket_set_curve_server) := GetProcAddress(hlib, 'zsocket_set_curve_server');
      Pointer(zsocket_set_curve_publickey) := GetProcAddress(hlib, 'zsocket_set_curve_publickey');
      Pointer(zsocket_set_curve_publickey_bin) := GetProcAddress(hlib, 'zsocket_set_curve_publickey_bin');
      Pointer(zsocket_set_curve_secretkey) := GetProcAddress(hlib, 'zsocket_set_curve_secretkey');
      Pointer(zsocket_set_curve_secretkey_bin) := GetProcAddress(hlib, 'zsocket_set_curve_secretkey_bin');
      Pointer(zsocket_set_curve_serverkey) := GetProcAddress(hlib, 'zsocket_set_curve_serverkey');
      Pointer(zsocket_set_curve_serverkey_bin) := GetProcAddress(hlib, 'zsocket_set_curve_serverkey_bin');
      Pointer(zsocket_set_zap_domain) := GetProcAddress(hlib, 'zsocket_set_zap_domain');
      Pointer(zsocket_set_ipv6) := GetProcAddress(hlib, 'zsocket_set_ipv6');
      Pointer(zsocket_set_immediate) := GetProcAddress(hlib, 'zsocket_set_immediate');
      Pointer(zsocket_set_router_raw) := GetProcAddress(hlib, 'zsocket_set_router_raw');
      Pointer(zsocket_set_ipv4only) := GetProcAddress(hlib, 'zsocket_set_ipv4only');
      Pointer(zsocket_set_delay_attach_on_connect) := GetProcAddress(hlib, 'zsocket_set_delay_attach_on_connect');
      Pointer(zsocket_set_sndhwm) := GetProcAddress(hlib, 'zsocket_set_sndhwm');
      Pointer(zsocket_set_rcvhwm) := GetProcAddress(hlib, 'zsocket_set_rcvhwm');
      Pointer(zsocket_set_affinity) := GetProcAddress(hlib, 'zsocket_set_affinity');
      Pointer(zsocket_set_subscribe) := GetProcAddress(hlib, 'zsocket_set_subscribe');
      Pointer(zsocket_set_unsubscribe) := GetProcAddress(hlib, 'zsocket_set_unsubscribe');
      Pointer(zsocket_set_identity) := GetProcAddress(hlib, 'zsocket_set_identity');
      Pointer(zsocket_set_rate) := GetProcAddress(hlib, 'zsocket_set_rate');
      Pointer(zsocket_set_recovery_ivl) := GetProcAddress(hlib, 'zsocket_set_recovery_ivl');
      Pointer(zsocket_set_sndbuf) := GetProcAddress(hlib, 'zsocket_set_sndbuf');
      Pointer(zsocket_set_rcvbuf) := GetProcAddress(hlib, 'zsocket_set_rcvbuf');
      Pointer(zsocket_set_linger) := GetProcAddress(hlib, 'zsocket_set_linger');
      Pointer(zsocket_set_reconnect_ivl) := GetProcAddress(hlib, 'zsocket_set_reconnect_ivl');
      Pointer(zsocket_set_reconnect_ivl_max) := GetProcAddress(hlib, 'zsocket_set_reconnect_ivl_max');
      Pointer(zsocket_set_backlog) := GetProcAddress(hlib, 'zsocket_set_backlog');
      Pointer(zsocket_set_maxmsgsize) := GetProcAddress(hlib, 'zsocket_set_maxmsgsize');
      Pointer(zsocket_set_multicast_hops) := GetProcAddress(hlib, 'zsocket_set_multicast_hops');
      Pointer(zsocket_set_rcvtimeo) := GetProcAddress(hlib, 'zsocket_set_rcvtimeo');
      Pointer(zsocket_set_sndtimeo) := GetProcAddress(hlib, 'zsocket_set_sndtimeo');
      Pointer(zsocket_set_xpub_verbose) := GetProcAddress(hlib, 'zsocket_set_xpub_verbose');
      Pointer(zsocket_set_tcp_keepalive) := GetProcAddress(hlib, 'zsocket_set_tcp_keepalive');
      Pointer(zsocket_set_tcp_keepalive_idle) := GetProcAddress(hlib, 'zsocket_set_tcp_keepalive_idle');
      Pointer(zsocket_set_tcp_keepalive_cnt) := GetProcAddress(hlib, 'zsocket_set_tcp_keepalive_cnt');
      Pointer(zsocket_set_tcp_keepalive_intvl) := GetProcAddress(hlib, 'zsocket_set_tcp_keepalive_intvl');
      Pointer(zsocket_set_tcp_accept_filter) := GetProcAddress(hlib, 'zsocket_set_tcp_accept_filter');
      Pointer(zsocket_set_hwm) := GetProcAddress(hlib, 'zsocket_set_hwm');
      Pointer(zsockopt_test) := GetProcAddress(hlib, 'zsockopt_test');

      Pointer(zbeacon_new) := GetProcAddress(hlib, 'zbeacon_new');
      Pointer(zbeacon_destroy) := GetProcAddress(hlib, 'zbeacon_destroy');
      Pointer(zbeacon_hostname) := GetProcAddress(hlib, 'zbeacon_hostname');
      Pointer(zbeacon_set_interval) := GetProcAddress(hlib, 'zbeacon_set_interval');
      Pointer(zbeacon_noecho) := GetProcAddress(hlib, 'zbeacon_noecho');
      Pointer(zbeacon_publish) := GetProcAddress(hlib, 'zbeacon_publish');
      Pointer(zbeacon_silence) := GetProcAddress(hlib, 'zbeacon_silence');
      Pointer(zbeacon_subscribe) := GetProcAddress(hlib, 'zbeacon_subscribe');
      Pointer(zbeacon_unsubscribe) := GetProcAddress(hlib, 'zbeacon_unsubscribe');
      Pointer(zbeacon_socket) := GetProcAddress(hlib, 'zbeacon_socket');
      Pointer(zbeacon_test) := GetProcAddress(hlib, 'zbeacon_test');

      Pointer(zuuid_new) := GetProcAddress(hlib, 'zuuid_new');
      Pointer(zuuid_destroy) := GetProcAddress(hlib, 'zuuid_destroy');
      Pointer(zuuid_data) := GetProcAddress(hlib, 'zuuid_data');
      Pointer(zuuid_size) := GetProcAddress(hlib, 'zuuid_size');
      Pointer(zuuid_str) := GetProcAddress(hlib, 'zuuid_str');
      Pointer(zuuid_set) := GetProcAddress(hlib, 'zuuid_set');
      Pointer(zuuid_export) := GetProcAddress(hlib, 'zuuid_export');
      Pointer(zuuid_eq) := GetProcAddress(hlib, 'zuuid_eq');
      Pointer(zuuid_neq) := GetProcAddress(hlib, 'zuuid_neq');
      Pointer(zuuid_dup) := GetProcAddress(hlib, 'zuuid_dup');
      Pointer(zuuid_test) := GetProcAddress(hlib, 'zuuid_test');
    end;


initialization
  LoadLib('czmq.dll');

finalization
  FreeLib('czmq.dll');

end.
