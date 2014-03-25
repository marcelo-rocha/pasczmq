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


{ C++ extern C conditionnal removed }
  {  @interface }
  {  This port range is defined by IANA for dynamic or private ports }
  {  We use this when choosing a port for dynamic binding. }

  const
    ZSOCKET_DYNFROM = $c000;    
    ZSOCKET_DYNTO = $ffff;   

    ZFRAME_MORE = 1;    
    ZFRAME_REUSE = 2;    
    ZFRAME_DONTWAIT = 4;    


  {  Callback function for zero-copy methods }


  var
  {** Context API**}

  {  Create new context, returns context object, replaces zmq_init }
    zctx_new : function:Pzctx_t;cdecl;
  {  Destroy context and all sockets in it, replaces zmq_term }
    zctx_destroy : procedure(var self_p:Pzctx_t);cdecl;
  {  Create new shadow context, returns context object }
    zctx_shadow : function(var self:zctx_t):Pzctx_t;cdecl;
  {  @end }
  {  Create a new context by shadowing a plain zmq context }
    zctx_shadow_zmq_ctx : function(var zmqctx:pointer):Pzctx_t;cdecl;
  {  @interface }
  {  Raise default I/O threads from 1, for crazy heavy applications }
  {  The rule of thumb is one I/O thread per gigabyte of traffic in }
  {  or out. Call this method before creating any sockets on the context, }
  {  or calling zctx_shadow, or the setting will have no effect. }
    zctx_set_iothreads : procedure(var self:zctx_t; iothreads:longint);cdecl;
  {  Set msecs to flush sockets when closing them, see the ZMQ_LINGER }
  {  man page section for more details. By default, set to zero, so }
  {  any in-transit messages are discarded when you destroy a socket or }
  {  a context. }
    zctx_set_linger : procedure(var self:zctx_t; linger:longint);cdecl;
  {  Set initial high-water mark for inter-thread pipe sockets. Note that }
  {  this setting is separate from the default for normal sockets. You  }
  {  should change the default for pipe sockets *with care*. Too low values }
  {  will cause blocked threads, and an infinite setting can cause memory }
  {  exhaustion. The default, no matter the underlying ZeroMQ version, is }
  {  1,000. }
    zctx_set_pipehwm : procedure(var self:zctx_t; pipehwm:longint);cdecl;
  {  Set initial send HWM for all new normal sockets created in context. }
  {  You can set this per-socket after the socket is created. }
  {  The default, no matter the underlying ZeroMQ version, is 1,000. }
    zctx_set_sndhwm : procedure(var self:zctx_t; sndhwm:longint);cdecl;
  {  Set initial receive HWM for all new normal sockets created in context. }
  {  You can set this per-socket after the socket is created. }
  {  The default, no matter the underlying ZeroMQ version, is 1,000. }
    zctx_set_rcvhwm : procedure(var self:zctx_t; rcvhwm:longint);cdecl;
  {  Return low-level 0MQ context object, will be NULL before first socket }
  {  is created. Use with care. }
    zctx_underlying : function(var self:zctx_t):pointer;cdecl;
  {  Self test of this class }
    zctx_test : function(verbose:bool):longint;cdecl;
  {  Global signal indicator, TRUE when user presses Ctrl-C or the process }
  {  gets a SIGTERM signal. }
  { extern volatile int zctx_interrupted; }

  {** Socket API **}

  {  Create a new socket within our CZMQ context, replaces zmq_socket. }
  {  Use this to get automatic management of the socket at shutdown. }
  {  Note: SUB sockets do not automatically subscribe to everything; you }
  {  must set filters explicitly. }
    zsocket_new : function(var self:zctx_t; _type:longint):pointer;cdecl;
  {  Destroy a socket within our CZMQ context, replaces zmq_close. }
    zsocket_destroy : procedure(self:zctx_t; socket:pointer);cdecl;
  {  Bind a socket to a formatted endpoint. If the port is specified as }
  {  '*', binds to any free port from ZSOCKET_DYNFROM to ZSOCKET_DYNTO }
  {  and returns the actual port number used. Otherwise asserts that the }
  {  bind succeeded with the specified port number. Always returns the }
  {  port number if successful. }
    zsocket_bind : function(socket:pointer; format:PChar):longint; cdecl; varargs; 

  {  Unbind a socket from a formatted endpoint. }
  {  Returns 0 if OK, -1 if the endpoint was invalid or the function }
  {  isn't supported. }
    zsocket_unbind : function(socket:pointer; format:PChar):longint;cdecl;
  {  Connect a socket to a formatted endpoint }
  {  Returns 0 if OK, -1 if the endpoint was invalid. }
    zsocket_connect : function(socket:pointer; format:PChar):longint;cdecl;
  {  Disonnect a socket from a formatted endpoint }
  {  Returns 0 if OK, -1 if the endpoint was invalid or the function }
  {  isn't supported. }
    zsocket_disconnect : function(socket:pointer; format:Pchar):longint;cdecl;
  {CZMQ_PRINTF_FUNC(2,3); }
  {  Poll for input events on the socket. Returns TRUE if there is input }
  {  ready on the socket, else FALSE. }
    zsocket_poll : function(socket:pointer; msecs:longint): bool;cdecl;
  {  Returns socket type as printable constant string }
    zsocket_type_str : function(socket:pointer):Pchar;cdecl;
  {  Send data over a socket as a single message frame. }
  {  Accepts these flags: ZFRAME_MORE and ZFRAME_DONTWAIT. }
(* Const before type ignored *)
    zsocket_sendmem : function(socket:pointer; const data; size:size_t; flags:longint):longint;cdecl;
  {  Send a signal over a socket. A signal is a zero-byte message. }
  {  Signals are used primarily between threads, over pipe sockets. }
  {  Returns -1 if there was an error sending the signal. }
    zsocket_signal : function(socket:pointer):longint;cdecl;
  {  Wait on a signal. Use this to coordinate between threads, over }
  {  pipe pairs. Returns -1 on error, 0 on success. }
    zsocket_wait : function(socket:pointer):longint;cdecl;
  {  Send data over a socket as a single message frame. }
  {  Returns -1 on error, 0 on success }
(* Const before type ignored *)
    zsocket_sendmem : function(var socket:pointer; var data:pointer; size:size_t; flags:longint):longint;cdecl;
  {  Self test of this class }
    zsocket_test : function(verbose:bool):longint;cdecl;

  {  Create a new empty message object }
    zmsg_new : function:Pzmsg_t;cdecl;
  {  Destroy a message object and all frames it contains }
    zmsg_destroy : procedure(var self_p:Pzmsg_t);cdecl;
  {  Receive message from socket, returns zmsg_t object or NULL if the recv }
  {  was interrupted. Does a blocking recv, if you want to not block then use }
  {  the zloop class or zmsg_recv_nowait() or zmq_poll to check for socket input before receiving. }
    zmsg_recv : function(var socket:pointer):Pzmsg_t;cdecl;
  {  Receive message from socket, returns zmsg_t object, or NULL either if there was }
  {  no input waiting, or the recv was interrupted. }
    zmsg_recv_nowait : function(var socket:pointer):Pzmsg_t;cdecl;
  {  Send message to socket, destroy after sending. If the message has no }
  {  frames, sends nothing but destroys the message anyhow. Safe to call }
  {  if zmsg is null. }
    zmsg_send : function(var self_p:Pzmsg_t; var socket:pointer):longint;cdecl;
  {  Return size of message, i.e. number of frames (0 or more). }
    zmsg_size : function(var self:zmsg_t):size_t;cdecl;
  {  Return total size of all frames in message. }
    zmsg_content_size : function(var self:zmsg_t):size_t;cdecl;
  {  Push frame to the front of the message, i.e. before all other frames. }
  {  Message takes ownership of frame, will destroy it when message is sent. }
  {  Returns 0 on success, -1 on error. Deprecates zmsg_push, which did not }
  {  nullify the caller's frame reference. }
    zmsg_prepend : function(var self:zmsg_t; var frame_p:Pzframe_t):longint;cdecl;
  {  Add frame to the end of the message, i.e. after all other frames. }
  {  Message takes ownership of frame, will destroy it when message is sent. }
  {  Returns 0 on success. Deprecates zmsg_add, which did not nullify the }
  {  caller's frame reference. }
    zmsg_append : function(var self:zmsg_t; var frame_p:Pzframe_t):longint;cdecl;
  {  Remove first frame from message, if any. Returns frame, or NULL. Caller }
  {  now owns frame and must destroy it when finished with it. }
    zmsg_pop : function(var self:zmsg_t):Pzframe_t;cdecl;
  {  Push block of memory to front of message, as a new frame. }
  {  Returns 0 on success, -1 on error. }
    zmsg_pushmem : function(var self:zmsg_t; var src:pointer; size:size_t):longint;cdecl;
  {  Add block of memory to the end of the message, as a new frame. }
  {  Returns 0 on success, -1 on error. }
    zmsg_addmem : function(var self:zmsg_t; var src:pointer; size:size_t):longint;cdecl;
  {  Push string as new frame to front of message. }
  {  Returns 0 on success, -1 on error. }
    zmsg_pushstr : function(var self:zmsg_t; _string:Pchar):longint;cdecl;
  {  Push string as new frame to end of message. }
  {  Returns 0 on success, -1 on error. }
    zmsg_addstr : function(var self:zmsg_t; _string:Pchar):longint;cdecl;
  {  Push formatted string as new frame to front of message. }
  {  Returns 0 on success, -1 on error. }
    zmsg_pushstrf : function(var self:zmsg_t; format:Pchar; args:array of const):longint;cdecl;
    zmsg_pushstrf : function(var self:zmsg_t; format:Pchar):longint;cdecl;
  {  Push formatted string as new frame to end of message. }
  {  Returns 0 on success, -1 on error. }
    zmsg_addstrf : function(var self:zmsg_t; format:Pchar; args:array of const):longint;cdecl;
    zmsg_addstrf : function(var self:zmsg_t; format:Pchar):longint;cdecl;
  {  Pop frame off front of message, return as fresh string. If there were }
  {  no more frames in the message, returns NULL. }
    zmsg_popstr : function(var self:zmsg_t):Pchar;cdecl;
  {  Pop frame off front of message, caller now owns frame }
  {  If next frame is empty, pops and destroys that empty frame. }
    zmsg_unwrap : function(var self:zmsg_t):Pzframe_t;cdecl;
  {  Remove specified frame from list, if present. Does not destroy frame. }
    zmsg_remove : procedure(var self:zmsg_t; var frame:zframe_t);cdecl;
  {  Set cursor to first frame in message. Returns frame, or NULL, if the  }
  {  message is empty. Use this to navigate the frames as a list. }
    zmsg_first : function(var self:zmsg_t):Pzframe_t;cdecl;
  {  Return the next frame. If there are no more frames, returns NULL. To move }
  {  to the first frame call zmsg_first(). Advances the cursor. }
    zmsg_next : function(var self:zmsg_t):Pzframe_t;cdecl;
  {  Return the last frame. If there are no frames, returns NULL. }
    zmsg_last : function(var self:zmsg_t):Pzframe_t;cdecl;
  {  Save message to an open file, return 0 if OK, else -1. The message is  }
  {  saved as a series of frames, each with length and data. Note that the }
  {  file is NOT guaranteed to be portable between operating systems, not }
  {  versions of CZMQ. The file format is at present undocumented and liable }
  {  to arbitrary change. }
    zmsg_save : function(var self:zmsg_t; var file:FILE):longint;cdecl;
  {  Load/append an open file into message, create new message if }
  {  null message provided. Returns NULL if the message could not  }
  {  be loaded. }
    zmsg_load : function(var self:zmsg_t; var file:FILE):Pzmsg_t;cdecl;
  {  Serialize multipart message to a single buffer. Use this method to send }
  {  structured messages across transports that do not support multipart data. }
  {  Allocates and returns a new buffer containing the serialized message. }
  {  To decode a serialized message buffer, use zmsg_decode (). }
    zmsg_encode : function(var self:zmsg_t; var buffer:Pbyte):size_t;cdecl;
  {  Decodes a serialized message buffer created by zmsg_encode () and returns }
  {  a new zmsg_t object. Returns NULL if the buffer was badly formatted or  }
  {  there was insufficient memory to work. }
    zmsg_decode : function(var buffer:byte; buffer_size:size_t):Pzmsg_t;cdecl;
  {  Create copy of message, as new message object. Returns a fresh zmsg_t }
  {  object, or NULL if there was not enough heap memory. }
    zmsg_dup : function(var self:zmsg_t):Pzmsg_t;cdecl;
  {  Print message to open stream }
  {  Truncates to first 10 frames, for readability. }
    zmsg_fprint : procedure(var self:zmsg_t; var file:FILE);cdecl;
  {  Print message to stdout }
    zmsg_print : procedure(var self:zmsg_t);cdecl;
  {  Self test of this class }
    zmsg_test : function(verbose:bool):longint;cdecl;
  {  Push frame plus empty frame to front of message, before first frame. }
  {  Message takes ownership of frame, will destroy it when message is sent. }
  {  DEPRECATED as unsafe -- does not nullify frame reference. }
    zmsg_wrap : procedure(var self:zmsg_t; var frame:zframe_t);cdecl;
  {  DEPRECATED - will be removed for next + 1 stable release }
  {  Add frame to the front of the message, i.e. before all other frames. }
  {  Message takes ownership of frame, will destroy it when message is sent. }
  {  Returns 0 on success, -1 on error. }
    zmsg_push : function(var self:zmsg_t; var frame:zframe_t):longint;cdecl;
  {  DEPRECATED - will be removed for next stable release }
    zmsg_add : function(var self:zmsg_t; var frame:zframe_t):longint;cdecl;

  {  Create a new frame with optional size, and optional data }
    zframe_new : function(var data:pointer; size:size_t):Pzframe_t;cdecl;
  {  Create an empty (zero-sized) frame }
    zframe_new_empty : function:Pzframe_t;cdecl;
  {  Destroy a frame }
    zframe_destroy : procedure(var self_p:Pzframe_t);cdecl;
  {  Receive frame from socket, returns zframe_t object or NULL if the recv }
  {  was interrupted. Does a blocking recv, if you want to not block then use }
  {  zframe_recv_nowait(). }
    zframe_recv : function(var socket:pointer):Pzframe_t;cdecl;
  {  Receive a new frame off the socket. Returns newly allocated frame, or }
  {  NULL if there was no input waiting, or if the read was interrupted. }
    zframe_recv_nowait : function(var socket:pointer):Pzframe_t;cdecl;
  { Send a frame to a socket, destroy frame after sending. }
  { Return -1 on error, 0 on success. }
    zframe_send : function(var self_p:Pzframe_t; var socket:pointer; flags:longint):longint;cdecl;
  {  Return number of bytes in frame data }
    zframe_size : function(var self:zframe_t):size_t;cdecl;
  {  Return address of frame data }
    zframe_data : function(var self:zframe_t):Pbyte;cdecl;
  {  Create a new frame that duplicates an existing frame }
    zframe_dup : function(var self:zframe_t):Pzframe_t;cdecl;
  {  Return frame data encoded as printable hex string }
    zframe_strhex : function(var self:zframe_t):Pchar;cdecl;
  {  Return frame data copied into freshly allocated string }
    zframe_strdup : function(var self:zframe_t):Pchar;cdecl;
  {  Return TRUE if frame body is equal to string, excluding terminator }
    zframe_streq : function(var self:zframe_t; _string:Pchar):bool;cdecl;
  {  Return frame MORE indicator (1 or 0), set when reading frame from socket }
  {  or by the zframe_set_more() method }
    zframe_more : function(var self:zframe_t):longint;cdecl;
  {  Set frame MORE indicator (1 or 0). Note this is NOT used when sending  }
  {  frame to socket, you have to specify flag explicitly. }
    zframe_set_more : procedure(var self:zframe_t; more:longint);cdecl;
  {  Return TRUE if two frames have identical size and data }
  {  If either frame is NULL, equality is always false. }
    zframe_eq : function(var self:zframe_t; var other:zframe_t):bool;cdecl;
  {   Print contents of the frame to FILE stream. }
    zframe_fprint : procedure(var self:zframe_t; prefix:Pchar; var file:FILE);cdecl;
  {  Print contents of frame to stderr }
    zframe_print : procedure(var self:zframe_t; prefix:Pchar);cdecl;
  {  Set new contents for frame }
    zframe_reset : procedure(var self:zframe_t; var data:pointer; size:size_t);cdecl;
  {  Put a block of data to the frame payload. }
    zframe_put_block : function(var self:zframe_t; var data:byte; size:size_t):longint;cdecl;
  {  Self test of this class }
    zframe_test : function(verbose:bool):longint;cdecl;


  var
  {  Create a new zloop reactor }
    zloop_new : function:Pzloop_t;cdecl;
  {  Destroy a reactor }
    zloop_destroy : procedure(var self_p:Pzloop_t);cdecl;
  {  Register pollitem with the reactor. When the pollitem is ready, will call }
  {  the handler, passing the arg. Returns 0 if OK, -1 if there was an error. }
  {  If you register the pollitem more than once, each instance will invoke its }
  {  corresponding handler. }
    zloop_poller : function(var self:zloop_t; var item:zmq_pollitem_t; handler:zloop_fn; var arg:pointer):longint;cdecl;
  {  Cancel a pollitem from the reactor, specified by socket or FD. If both }
  {  are specified, uses only socket. If multiple poll items exist for same }
  {  socket/FD, cancels ALL of them. }
    zloop_poller_end : procedure(var self:zloop_t; var item:zmq_pollitem_t);cdecl;
  {  Configure a registered pollitem to ignore errors. If you do not set this,  }
  {  then pollitems that have errors are removed from the reactor silently. }
    zloop_set_tolerant : procedure(var self:zloop_t; var item:zmq_pollitem_t);cdecl;
  {  Register a timer that expires after some delay and repeats some number of }
  {  times. At each expiry, will call the handler, passing the arg. To }
  {  run a timer forever, use 0 times. Returns a timer_id that is used to cancel }
  {  the timer in the future. Returns -1 if there was an error. }
    zloop_timer : function(var self:zloop_t; delay:size_t; times:size_t; handler:zloop_timer_fn; var arg:pointer):longint;cdecl;
  {  Cancel a specific timer identified by a specific timer_id (as returned by }
  {  zloop_timer). }
    zloop_timer_end : function(var self:zloop_t; timer_id:longint):longint;cdecl;
  {  Set verbose tracing of reactor on/off }
    zloop_set_verbose : procedure(var self:zloop_t; verbose:bool);cdecl;
  {  Start the reactor. Takes control of the thread and returns when the 0MQ }
  {  context is terminated or the process is interrupted, or any event handler }
  {  returns -1. Event handlers may register new sockets and timers, and }
  {  cancel sockets. Returns 0 if interrupted, -1 if cancelled by a handler. }
    zloop_start : function(var self:zloop_t):longint;cdecl;
  {  Self test of this class }
    zloop_test : procedure(verbose:bool);cdecl;


  const
    CURVE_ALLOW_ANY = '*';    

  var
  {  Constructor }
  {  Install authentication for the specified context. Returns a new zauth }
  {  object that you can use to configure authentication. Note that until you }
  {  add policies, all incoming NULL connections are allowed (classic ZeroMQ }
  {  behaviour), and all PLAIN and CURVE connections are denied. If there was }
  {  an error during initialization, returns NULL. }
    zauth_new : function(var ctx:zctx_t):Pzauth_t;cdecl;
  {  Allow (whitelist) a single IP address. For NULL, all clients from this }
  {  address will be accepted. For PLAIN and CURVE, they will be allowed to }
  {  continue with authentication. You can call this method multiple times  }
  {  to whitelist multiple IP addresses. If you whitelist a single address, }
  {  any non-whitelisted addresses are treated as blacklisted. }
    zauth_allow : procedure(var self:zauth_t; address:Pchar);cdecl;
  {  Deny (blacklist) a single IP address. For all security mechanisms, this }
  {  rejects the connection without any further authentication. Use either a }
  {  whitelist, or a blacklist, not not both. If you define both a whitelist  }
  {  and a blacklist, only the whitelist takes effect. }
    zauth_deny : procedure(var self:zauth_t; address:Pchar);cdecl;
  {  Configure PLAIN authentication for a given domain. PLAIN authentication }
  {  uses a plain-text password file. To cover all domains, use "*". You can }
  {  modify the password file at any time; it is reloaded automatically. }
    zauth_configure_plain : procedure(var self:zauth_t; domain:Pchar; filename:Pchar);cdecl;
  {  Configure CURVE authentication for a given domain. CURVE authentication }
  {  uses a directory that holds all public client certificates, i.e. their }
  {  public keys. The certificates must be in zcert_save () format. To cover }
  {  all domains, use "*". You can add and remove certificates in that }
  {  directory at any time. To allow all client keys without checking, specify }
  {  CURVE_ALLOW_ANY for the location. }
    zauth_configure_curve : procedure(var self:zauth_t; domain:Pchar; location:Pchar);cdecl;
  {  Enable verbose tracing of commands and activity }
    zauth_set_verbose : procedure(var self:zauth_t; verbose:bool);cdecl;
  {  Destructor }
    zauth_destroy : procedure(var self_p:Pzauth_t);cdecl;
  {  Selftest }
    zauth_test : function(verbose:bool):longint;cdecl;


  var
  {  Create new poller }
    zpoller_new : function(var reader:pointer; args:array of const):Pzpoller_t;cdecl;
    zpoller_new : function(var reader:pointer):Pzpoller_t;cdecl;
  {  Destroy a poller }
    zpoller_destroy : procedure(var self_p:Pzpoller_t);cdecl;
  { Add a reader to be polled. }
    zpoller_add : function(var self:zpoller_t; var reader:pointer):longint;cdecl;
  {  Poll the registered readers for I/O, return first socket that has input. }
  {  This means the order that sockets are defined in the poll list affects }
  {  their priority. If you need a balanced poll, use the low level zmq_poll }
  {  method directly. If the poll call was interrupted (SIGINT), or the ZMQ }
  {  context was destroyed, or the timeout expired, returns NULL. You can }
  {  test the actual exit condition by calling zpoller_expired () and }
  {  zpoller_terminated (). Timeout is in msec. }
    zpoller_wait : function(var self:zpoller_t; timeout:longint):pointer;cdecl;
  {  Return true if the last zpoller_wait () call ended because the timeout }
  {  expired, without any error. }
    zpoller_expired : function(var self:zpoller_t):bool;cdecl;
  {  Return true if the last zpoller_wait () call ended because the process }
  {  was interrupted, or the parent context was destroyed. }
    zpoller_terminated : function(var self:zpoller_t):bool;cdecl;
  {  Self test of this class }
    zpoller_test : function(verbose:bool):longint;cdecl;


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
    end;


initialization
  LoadLib('czmq.dll');

finalization
  FreeLib('czmq.dll');

end.
