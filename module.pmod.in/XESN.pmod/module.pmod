//! This module implements extra Atom (or RSS) elements inside the XESN namespace.
//!
//! This module is called by Public.Syndication.ATOM if any XESN elements are found.
//!

#if !constant(Public.Parser.XML2)
static void create(mixed ... args)
{
  throw(Error.Generic("This module depends on Public.Parser.XMl2, please install it with monger.\nCheck http://module.gotpike.org/ for more information.\n\n"));
}
#else

import Public.Parser;

constant CONTENT_TYPE = "application/atom+xml";
constant XMLNS = "http://helicopter.geek.nz/xesn";
constant MAJOR = 0;
constant MINOR = 1;
constant TEST = #string "test.xml";

#endif
