{  =========================================================================
    zmq.pas - ZMQ API Pascal Binding

    Copyright (c) 2014 Marcelo Campos Rocha - http://www.marcelorocha.net

    This file is a derived work from headers of zmq library
    http://zeromq.org.
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

unit zmq;

interface

uses SysUtils;

type
  size_t = NativeUInt;

const
{$IFDEF WINDOWS}
  ZMQ_LIB = 'zmq.dll';
{$ELSE ~WINDOWS}
  ZMQ_LIB = 'libzmq.so';
{$ENDIF ~WINDOWS}

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
var
   zmq_send: function(socket: Pointer; const buf; len: size_t; flags: Integer): Integer; cdecl;
   zmq_send_const: function(socket: Pointer; const buf; len: size_t; flags: Integer): Integer; cdecl;
   zmq_recv: function(socket: Pointer; var buf; len: size_t; flags: Integer): Integer; cdecl;
{$ELSE ~CZMQ_LINKONREQUEST}
   function zmq_send (socket: Pointer; const buf; len: size_t; flags: Integer): Integer; cdecl; external ZMQ_LIB;
   function zmq_send_const (socket: Pointer; const buf; len: size_t; flags: Integer): Integer; cdecl; external ZMQ_LIB;
   function zmq_recv (socket: Pointer; out buf; len: size_t; flags: Integer): Integer; cdecl; external ZMQ_LIB;
{$ENDIF}


{$IFDEF CZMQ_LINKONREQUEST}
  procedure LoadLib(lib : PAnsiChar);
  procedure FreeLib;
{$ENDIF}


implementation

{$IFDEF CZMQ_LINKONREQUEST}
{$IFDEF FPC}
  uses dynlibs;
{$ELSE ~FPC}
  uses Windows;
{$ENDIF ~FPC}
{$ENDIF CZMQ_LINKONREQUEST}

{$IFDEF CZMQ_LINKONREQUEST}
var
    _hlib : TLibHandle;

procedure LoadLib(lib : PAnsiChar);
begin
  _hlib := LoadLibrary(lib);
  if _hlib = 0 then
    raise Exception.Create(Format('Could not load library: %s',[lib]));

  Pointer(zmq_send) := GetProcAddress(_hlib, 'zmq_send');
  Pointer(zmq_send_const) := GetProcAddress(_hlib, 'zmq_send_const');
  Pointer(zmq_recv) := GetProcAddress(_hlib, 'zmq_recv');
end;

procedure FreeLib;
begin
  FreeLibrary(_hlib);
  zmq_send := nil;
  zmq_send_const := nil;
  zmq_recv := nil;
end;
{$ENDIF}


end.
